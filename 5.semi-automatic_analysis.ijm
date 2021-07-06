dir_in = getDirectory("Select Input Directory (cut composite dendrites)");
dir_out = getDirectory("chose output directory (separate for each prtein)");
list_in = getFileList(dir_in);

for (i=0; i<list_in.length; i++) {
		open_file = dir_in+list_in[i];
		run("Bio-Formats Importer", "check_for_upgrades open=&open_file autoscale color_mode=Default rois_import=[ROI manager] view=Hyperstack stack_order=XYCZT");
		name = File.nameWithoutExtension;
		
		run("Stack to Images");
		run("Threshold...");
		setAutoThreshold("Default");
		waitForUser("Adjust threshold, then hit OK");
		run("Create Mask");
		run("Create Selection");
		roiManager("Add");
		selectWindow("mask");

		 
		mask_save = dir_out+"/masks/"+name+"_mask"+i;
		saveAs("Tiff", mask_save);
		close();
		
		roiManager("Select", 0);
		roiManager("Delete");
		//setTool("hand");
		name_ch1 = name+"-0001";
		selectWindow(name_ch1);
		roiManager("Measure");
		getStatistics(area, mean, min, max, std, histogram);
		thresh1 = mean+3*std;
		
		//makeRectangle(19, 0, 80, 197);
		setThreshold(thresh1, 65535);
		run("Convert to Mask");
		thresholded_1_save = dir_out+"/thresholded/"+name+".1";
		saveAs("Tiff", thresholded_1_save);
		
		name_ch2 = name+"-0002";
		selectWindow(name_ch2);
		roiManager("Measure");
		getStatistics(area, mean, min, max, std, histogram);
		thresh2 = mean+3*std;

//		makeRectangle(19, 0, 80, 197);
		setThreshold(thresh2, 65535);
		run("Convert to Mask");
		thresholded_2_save = dir_out+"/thresholded/"+name+".2";
		saveAs("Tiff", thresholded_2_save);
		
		run("JACoP ");
//		thresh1_name = name+i+".1.tif";
//		thresh2_name = name+i+".2.tif";
//		selectWindow(thresh1_name);
//		selectWindow(thresh2_name);
//		run("JACoP ", "imga=&thresh1_name imgb=&thresh2_name thra=1 thrb=1 pearson mm");
		waitForUser("click analyze and close JAcob window");
		
//		selectWindow("Log");
		log_save = dir_out+"/logs/"+name+"_log";
		saveAs("Text", log_save);
		close("Log");
		run("Dispose All Windows", "/all image non-image");
		
}

		