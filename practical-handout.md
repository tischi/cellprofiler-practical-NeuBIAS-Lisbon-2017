# CellProfiler Practical:<br/> Counting of in situ PLA signals per cell### Authors- Carolina Wählby and Maxime Bombrun, Centre for Image Analysis, Uppsala University
- Christian Tischer, Advanced Light Microscopy Facility, EMBL Heidelberg
## Background information
In this experiment, we are working with cells (HEK293) growing in a multi-well plate. The cells have either wild-type of mutant Notch3, detected using in situ PLA, resulting in red dots. The amount of antibody for the PLA assay has been varied to confirm saturation (that is, to ensure we maximize Notch detection and that the detection rate is not limited by low antibody concentration). 
The aim of the experiment is to: 
1.	Compare the number of dots per cell in cells expressing wild-type and mutant Notch3. 2.	Measure how the number of dots per cell varies with varying amounts of primary antibody (1EA).
The data that we will analyze is the following:Well | Sample---|---1 | HEK293 WT 1E4 (0.04 mg/mL)
2 | HEK293 WT 1E4 (0.004 mg/mL) 
3 | HEK293 WT 1E4 (0.0004 mg/mL) 
4 | HEK293 WT No antibody5 | HEK293 + Notch3 FL (stable) 1E4 (0.04 mg/mL)
6 | HEK293 + Notch3 FL (stable) 1E4 (0.004 mg/mL) 
7 | HEK293 + Notch3 FL (stable) 1E4 (0.0004 mg/mL) 8 | HEK293 + Notch3 FL (stable) No antibody## Goals and materials
In this exercise, we aim to set up an automated image analysis pipeline that will
1. identify individual cells in the images, based on a nuclear stain.
2. identify all PLA signals.
3. count the number of PLA signals per cell and output this information to a spreadsheet. 
## Methods 
You will use the free and open source CellProfiler software to identify and delineate (segment) each nucleus and cell body, and count the number of PLA signals per cell. You will set up a CellProfiler pipeline consisting of a number of modules; each module performs a unique image-processing step, and multiple modules can be arranged such that they are executed in sequential order. You will test your pipeline on a few images so that you can optimize the settings. Once optimization is complete, you will run the pipeline on all the images in the experiment, collect measurements from each cell and store the measurements in a spreadsheet. You will thereafter open the spreadsheet in Excel or another program of your choice.## Getting started: 
### Installation of CellProfiler
- Download [CellProfiler](www.cellprofiler.org) and install the program on your computer (if it is not already installed).
	- Mac-users should check out their OS version, CellProfiler 2.2 (Stable) works only for Mac OS 10.10+.
	- Windows-users should check out their Java environment: Java x86 will have to be install for Windows x32 and Java x64 for Windows x64 (sometimes not the one recommended by the Java website); please follow the instruction on the CellProfiler download page.
	
### Download the data	-	Go to [this](http://www.cb.uu.se/~carolina/CellProfiler/) page, download **PLA_data.zip**, and unzip the folder.	- Alternatively, you can also download the data from [here](https://github.com/tischi/cellprofiler-practical-NeuBIAS-Lisbon-2017/archive/master.zip).
	
### Configure CellProfiler to load the data
- Start CellProfiler.
- In the CellProfiler interface, you will see the File list panel, a blank panel indicated by the text “Drop files and folders here”. From File Explorer (Windows) or Finder (Mac), drag and drop the folder of sample images named **data_PLA** into this panel. The filenames in the folder should now appear in the panel. You can take a look at the images by double-clicking on the name in the file list (close afterwards).
- Click on the **NamesAndTypes** module; this module allows you to assign a name to each image by which other modules will refer to it. Chose to assign a name to all images,  select the image type **Color image**, and assign the name **raw_data** to all images. Click **[Update]** at the bottom of the table to list the selected files.
- At the bottom left of the CellProfiler interface, click **[View output settings]**. In the panel to the right, adjust the **Default Output Folder**, e.g. create a new folder called **results** on the Desktop. 

### Save your CellProfiler pipeline

- All necessary input and output modules are now set. Before continuing, click **[File]** at the top menu, and **[Save Project]**. Save the project in your output folder; in this way you will know what results were created with what pipeline. 

## Start building a pipeline
Now it is time to start building the analysis pipeline. In order to identify the individual cells, start by identifying the cell nuclei. But before doing so we need to split the image into its different color channels.

### Split the color image using ColorToGray-	To split the image channels, right-click into the **Analysis modules panel** and **Add** the module **ColorToGray** (located under **Image Processing**). 
- Select **raw_data** as your input image.
- Chose to **Split** the **RBG** color channels.
	- You do not have any information in the green channel, so you can set **No** here. 
	- Call the red image **PLA**, and the blue image **DNA**.
### Identify nuclei using IdentifyPrimaryObjectsMost cell segmentation projects start by finding the nuclei as they are typically well separate and relatively easy to detect.
- **Add > Object Processing > IdentifyPrimaryObjects**.
	- Select the input image: **DNA**.
	- Name the primary objects to be identified: **Nuclei**
	- The remaining settings need to be adjusted to best detect the nuclei, using CellProfiler's **Test Mode** (see below).
	
## How to use CellProfiler's Test Mode

CellProfilers Test mode is a super useful feature that will allow you to see the results of your chosen settings, and adjust them as needed.

- Go to the **Test** item in the menu bar at the top of the CellProfiler interface and select **Start Test Mode** (or use the corresponding **[Start Test Mode]** button in the bottom left of the CellProfiler interface).
- You will see a pointer and **"** icons appear next to the modules in the pipeline. 
- Click **[Step]** below the pipeline panel to progress through each module in the pipeline, one by one.
	- Alternatively you can click on the **"** icon *after* the module that you'd like to examine and click **[Run]** in order to execute all steps until this one
- Make sure that the **Eyes** next to the module names are openend to see the output of each module (you can click on them to close them).
- Note that you can select the image that you are working on using **[Test > Choose Image Set]**
	- It is critical that you optimise you pipeline not only for one image, but for representative subset of your data, e.g. one image per biological condition	

## Resume building and optimizing your pipeline 

### Adjust nuclei segmentation

**[Step]** through the pipeline to **IdentifyPrimaryObjects** and examine the results using the zooming tool in the top menu of the module output window. Using the default settings, you will realize that the nuclei are split into very many small parts (this is called over-segmentation). The module assumes that individual nuclei can be separated based on variations in signal intensity. In this dataset, there is a lot of variation in the intensity also within the nuclei. Using the numbering at the edge of the image, you will realize that these cells have a diameter greater than the default setting. 

- Change the **Typical diameter** setting to **30 to 80**
- Keep the automatic foreground/background threshold. 
- Further, set **Method to distinguish clumped objects: Shape**. - Now, look at the result clicking **[Step]** again.This should look much better now! However, as you will realize it is difficult to get a perfect segmentation of all nuclei. It is however important to remember that a few small errors will have a small impact on the end result if you use a non-biased automated approach and analyze many cells, as compared to analyzing few cells manually. If you want to, you can try the other options. Use the **[?]** next to the settings to learn what they mean. When you have confirmed, by eye, that the settings result in reasonable segmentation of most of the nuclei, the next step is to define an approximate cytoplasm of each cell. 

### Detection of the cytoplasm using IdentifySecondaryObjects- **Add > Object Processing > IdentifySecondaryObjects**
- **Select the input image: PLA** 
	- We will use this as a guide to see how large the cytoplasms are.
- **Select input objects setting: Nuclei**
	- The nuclei will act as seeds for delineation of cytoplasms. 
- **[Step]** through the module in **Test mode**. 

By default, secondary objects are identified with the Propagation method, which defines cell boundaries by growing outwards from the primary objects, i.e. the nuclei, and taking into account both the distance from the nearest primary object, and the local intensity in the image channel (in this case the PLA channel). The result is poor as the PLA signal is not a cytoplasmic stain. 

- Test the method called **Distance-N**, and set it to **30**, and re-run using Step. Click on the **[?]** next to his setting to learn what it does.

### Detection of the PLA dots using IdentifyPrimaryObjects
Next, find the PLA dots using the same module as for finding the nuclei, but with other settings.
-	**Add > Object Processing > IdentifyPrimaryObjects**
- Chose **PLA** as input
- Name the primary objects to be identified **PLA_dots** 
- Run the module using **[Step]** to see what happens when using the default settings. 
- Now, adjust the **Typical diameter** to **2-8 pixels**. 

For the PLA dots we know that some images may lack dots, and we will therefore use a fixed intensity threshold, or else background noise may be detected as true signals.

- Set **Threshold strategy** to **Manual**, and chose **0.05** as a threshold.
	- You can later do an [additional task](#additional task:-adjust-spot-detection-threshold-using-negative controls) in order to learn how to decide on the 0.05 threshold in a scientific manner 
- **[Step]**, and visually confirm the result.

### Count the number of PLA dots per cell using RelateObjects

- **Add > Object Processing > RelateObjects**.
- Select **PLA_dots** as the **child** objects, 
- Select **Cells** as the **parent** objects. 

This module will automatically count the number of child objects (PLA signals) per parent object (Cell). For now, were not extracting any other measurements (such as signal intensity), so the other settings can be left at the default settings.### Creating overlay images using OverlayOutlinesIt is very important to save the result of segmentations and measurements as an image to visually confirm the analysis! As a first step we will create a new image where we overlay the segmentation results on the raw data.
- **Add > Image Processing > OverlayOutlines**
- Display outlines on the **raw_data** image.  
- Use the default **OrigOverlay** as output name. 
- Add outlines from objects **Cells**, **Nuclei**, and **PLA_dots** using **Add another outline**. 
- **[Step]** to check what it is doing
- Adjust the outline colors to your liking

### Save of overlay images using SaveImages

Now that we created the overlay image we need to save it to disk!
- **Add > FileProcessing > SaveImages** 
- Select **OrigOverlay** as the image to save 
- Select **From image filename** as method for constructing file name, and use **raw_data** to provide the image name.
- Also check the box to **Append a suffix**, name this suffix **_overlay**.
	- This means that your result images will have the same name as the input images, but with the suffix **_result**. 
- Use file format **png**. 
- Select **Yes** for **Overwrite existing files without warning?**
	- Otherwise each time you run the pipeline again you have to manually confirm for each image that it can be overwritten (lots of work if you have 1000 images ;).
- Other settings can be left at their default values. 
- Execute using **[Step]**
	- Inspect you results folder using **Finder** or **Windows Explorer**: the image should have appeared! 	
### Saving of numeric results using ExportToSpreadsheet- **Add > File Processing > ExportToSpreadsheet** - Chose **Tab** as delimiter.	- Comma delimited files are more likely to be interpreted wrongly, e.g. by Excel.- Click on **Yes** for **Select the measurements to export**	- Select **Cells/Children/PLA/dots/count** 
		- click arrow to expand categories
	- Also select **Image/Filename/raw/data**.	- Click OK.
- Also check that you want to **Calculate per-image means (and standard deviations) for object measurements** as these will simplify later plotting.
- Note that the ExportToSpreadsheet will only work after exiting test mode.
- Save your project before proceeding.
### Run your pipelineNow it is time to finally run your pipeline on all images!
- **[Exit test mode]**- Select the **Window** item from the menu bar and select **Hide all windows on run**
	- Otherwise you will be flooded by output images.
- Click [Analyze Images] (next to the **[Start Test Mode]** button).

### Examine the numeric output using ExcelThe pipeline will now analyze all the images and create several output files. Open this file named Something_Cells.csv in Excel or similar. The file contains image number, object number (object being cell), and Children_PLA_dots_Count, which corresponds to the total number of PLA signals per cell. Rather than using this detailed information, open the file called Something_Image.csv. If using Swedish Excel also click Advanced to specify that . marks the decimal point. Now, create a bar-chart with errors based on means and standard deviations. 
Questions:1.	Is there a significant difference in dots per cell in cells expressing wild-type and mutant Notch3?2.	How can we improve the experiment to better answer this question? 3.	In the current choice of antibody concentrations, do we know that we have saturated the system, or would it be meaningful to try higher concentrations?4.	What would you judge is the largest source of error in this experiment?
### Additional task: Adjust spot detection threshold using negative controls
In order to find an objective threshold, one method is to examine an image where you are sure that there are no objects (e.g. control with secondary antibody only) and set the threshold just slightly above the value where would start detecting something.
To do so here, go the CellProfiler's menu and **[Test > Start Test Mode]** and then **[Test > Choose Image Set]** and then select one of the wells that don't have antibody staining (i.e. **Well_4** or **Well_8**).
Now **[Run]** or **[Step]** to the **IdentifyPrimaryObjects** module where you find the **PLA_dots**. 

If you mouse-over in the Input image you will see the gray values (Intensities) displayed at the bottom of the window. Chose your threshold slightly larger than the displayed intensities.### Additional task: Local background subtraction using EnhanceOrSupressFeatures
In fluorescence microscopy of biological samples there typically is some kind of "background" signal. The sources include:
1. Unbound protein that is diffusing in the cytoplasm and not bound to distinct structures.2. Out-of-focus signal, which appears blurry.3. Unspecific staining or autofluorescence.
Such background can be reduced by pre-processing the images with a filter that only keeps the signal of locally bright structures. 
To try this with the PLA staining of this practical, go back to your CellProfiler pipeline, and
- **Add > Image Processing > EnhanceOrSupressFeatures** 	- This module should be added right before the second IdentifyPrimaryObjects where you find the PLA signals.
- Select the **PLA** image as your **input image**, and call the **output** **FilteredPLA**.
- Select the operation **Enhance**, Feature type **Speckles**, and feature size **6**.
	- Consider reading to the help **[?]**
- Select **Speed and accuracy**: **Slow / circular** 
- **[Start Test Mode]** and **[Step]** through the module and see if the output looks cleaner.
	- Explore different values for the feature size, e.g. **2** and **40**. What happens? 
- Next, change the following **IdentifyPrimaryObjects** module to have the **FilteredPLA** as input instead of PLA. 
	- You may need to adjust the threshold to better fit the filtered image.

Re-run the full analysis using **[Analyze Images]** and see if the results have changed.