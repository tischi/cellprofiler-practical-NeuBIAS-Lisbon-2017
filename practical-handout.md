# CellProfiler Practical: Counting of in situ PLA signals per cell



2 | HEK293 WT 1E4 (0.004 mg/mL) 
3 | HEK293 WT 1E4 (0.0004 mg/mL) 
4 | HEK293 WT No antibody
6 | HEK293 + Notch3 FL (stable) 1E4 (0.004 mg/mL) 
7 | HEK293 + Notch3 FL (stable) 1E4 (0.0004 mg/mL) 







- Start CellProfiler.
- In the CellProfiler interface, you will see the File list panel, a blank panel indicated by the text “Drop files and folders here”. From File Explorer (Windows) or Finder (Mac), drag and drop the folder of sample images named **data_PLA** into this panel. The filenames in the folder should now appear in the panel. You can take a look at the images by double-clicking on the name in the file list (close afterwards).
- Click on the **NamesAndTypes** module; this module allows you to assign a name to each image by which other modules will refer to it. Chose to assign a name to all images,  select the image type **Color image**, and assign the name **raw_data** to all images. Click **[Update]** at the bottom of the table to list the selected files.
- At the bottom left of the CellProfiler interface, click **[View output settings]**. In the panel to the right, adjust the **Default Output Folder**, e.g. create a new folder called **results** on the Desktop. 
- All necessary input and output modules are now set. Before continuing, click **[File]** at the top menu, and **[Save Project]**. Save the project in your output folder; in this way you will know what results were created with what pipeline. 

## Start building a pipeline
Now it is time to start building the analysis pipeline. In order to identify the individual cells, start by identifying the cell nuclei. But before doing so we need to split the image into its different color channels.


	- Select the input image: **DNA**.
	- Name the primary objects to be identified: **Nuclei**
	- The remaining settings need to be adjusted to best detect the nuclei, using CellProfiler's **Test Mode** (see below).
	
## How to use CellProfiler's Test Mode

CellProfilers Test mode is a super useful feature that will allow you to see the results of your chosen settings, and adjust them as needed.

- Go to the **Test** item in the menu bar at the top of the CellProfiler interface and select **Start test run** (or use the corresponding button in the bottom left). You will see a pointer and **"** icons appear next to the modules in the pipeline. Click **[Step]** below the pipeline panel to progress through each module in the pipeline, one by one.
- Make sure that the **Eyes** next to the module names are openend to see the output of each module (you can click on them to close them).

## Resume building and optimizing you pipeline 

### Adjust nuclei detection using IdentifyPrimaryObjects
- **[Step]** through the pipeline to **IdentifyPrimaryObjects** and examine the results using the zooming tool in the top menu of the module output window. Using the default settings, you will realize that the nuclei are split into very many small parts (this is called over-segmentation). The module assumes that individual nuclei can be separated based on variations in signal intensity. In this dataset, there is a lot of variation in the intensity also within the nuclei. Using the numbering at the edge of the image, you will realize that these cells have a diameter greater than the default setting. 
- Change the setting **Typical diameter** to **30 to 80**, and keep the automatic foreground/background threshold. 
- Further, set **Method to distinguish clumped objects: Shape**. 

### Detection of the cytoplasm using IdentifySecondaryObjects
- **Select the input image: PLA** 
	- We will use this as a guide to see how large the cytoplasms are.
- **Select input objects setting: Nuclei**
	- The nuclei will act as seeds for delineation of cytoplasms. 
- **[Step]** through the module in **Test mode**. 

By default, secondary objects are identified with the Propagation method, which defines cell boundaries by growing outwards from the primary objects, i.e. the nuclei, and taking into account both the distance from the nearest primary object, and the local intensity in the image channel (in this case the PLA channel). The result is poor as the PLA signal is not a cytoplasmic stain. 

- Test the method called **Distance-N**, and set it to **30**, and re-run using Step. Click on the **[?]** next to his setting to learn what it does.

### Detection of the PLA dots using IdentifyPrimaryObjects


- Chose PLA as input
- Name the primary objects to be identified setting, enter PLA_dots as a descriptive name.
- Run using Step to see what happens when using the default settings. 
- Now, adjust the Typical diameter to 2-8 pixels. 

For the PLA dots we know that some images may lack dots, and we will therefore use a fixed intensity threshold, or else background noise may be detected as true signals.

- Set Threshold strategy to Manual, and 0.05.
- Run using Step, and visually confirm the result.

### Count the number of PLA dots per cell using RelateObjects
- Add RelateObjects (located under Object Processing).
- Select PLA_dots as the child objects, 
- and Cells as the parent objects. 

This module will automatically count the number of child objects (PLA signals) per parent object (Cell). For now, were not extracting any other measurements (such as signal intensity), so the other settings can be left at the default settings.







### Examine the numeric output using Excel




- Select the PLA image as your input image, and call the output FilteredPLA.
- Select the operation Enhance, Feature type Speckles, and feature size 2. 
- **[Start Test Mode]** and **[Step]** through the module and see if the output looks cleaner. You may want to test other values of the feature size. 
- Next, change the IdentifyPrimaryObjects module to have the Filtered PLA as input instead of PLA. 
- You may need to adjust the background threshold to better fit the filtered image.


Re-run the full experiment using this new pipeline and see if the results changed.