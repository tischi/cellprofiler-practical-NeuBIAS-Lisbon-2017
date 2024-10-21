
for (i = 1; i <= 8; i++) 
{
	run("Close All");
	open("/Users/tischer/Documents/cellprofiler-practical-NeuBIAS-Lisbon-2017/PLA_data/Well_"+i+".tif");
	run("Split Channels");
	selectWindow("Well_"+i+".tif (red)");
	saveAs("Tiff", "/Users/tischer/Documents/cellprofiler-practical-NeuBIAS-Lisbon-2017/PLA_data/Well_"+i+"_C1.tif");
	selectWindow("Well_"+i+".tif (blue)");
	saveAs("Tiff", "/Users/tischer/Documents/cellprofiler-practical-NeuBIAS-Lisbon-2017/PLA_data/Well_"+i+"_C0.tif");
}
