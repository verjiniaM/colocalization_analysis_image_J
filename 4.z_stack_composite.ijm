//Z-projection stack from channel 1and 2 (no DAPI)

dir_in = getDirectory("Input Directory ");
dir_out = getDirectory("z_comp Directory ");
list_in = getFileList(dir_in);
setBatchMode(true);
for (i=0; i<list_in.length; i++) {
	//open the file	
	open_file = dir_in+list_in[i];
	run("Bio-Formats Importer", "check_for_upgrades open=&open_file autoscale color_mode=Default rois_import=[ROI manager] view=Hyperstack stack_order=XYCZT");
	// take filename and make a z projection
	name = File.nameWithoutExtension;
	run("Z Project...", "projection=[Sum Slices]");

	name_org = name+".czi";
	selectWindow(name_org);
	close();
    // remove DAPI from z-projection
	run("Stack to Images");
	DAPI = "SUM_"+name+"-0003";
	selectWindow(DAPI);
	close();
	z_name = name + "_z_comp";
	run("Images to Stack", "name=&z_name title=[] use");
	setForegroundColor(16, 0, 0);
	run("8-bit");
	setForegroundColor(2, 0, 0);
	run("8-bit");
	run("16-bit");
	saveAs("Tiff", dir_out+z_name+".tiff");
	close("*");
}
setBatchMode(false);