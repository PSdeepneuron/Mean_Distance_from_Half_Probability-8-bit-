//Set directory to save results in table to use for analysis
#@ File (style="directory") imageFolder;
dir = File.getDefaultDir;
dir = replace(dir,"\\","/");

waitForUser("Starting frame","Put the annotated image at the slice from where the process should start\nthen press OK");
getPixelSize(unit, pixelWidth, pixelHeight);
getVoxelSize(width, height, depth, unit);
pixel_area = pixelWidth*pixelHeight;
pixel_volume = pixel_area * nSlices; 

run("Duplicate...", "duplicate");

total_gray_distance = 0

for (i=0;i<nSlices;i++) {
	for (x=0;x<256;x++) {
		for (y=0;y<256;y++) {
			total_gray_distance = abs(getPixel(x, y)-127.5);
		}
	}
	run("Next Slice [>]");
}

mean_total_gray_distance = total_gray_distance/pixel_volume;
print(mean_total_gray_distance);

mean_distance_to_gray_centre_array = newArray();
mean_distance_to_gray_centre_array = Array.concat(mean_distance_to_gray_centre_array,mean_total_gray_distance);

save_option = getBoolean("Want to save results?");
if (save_option == 1){
//Make a table containing the arrays
Table.create("Probability_Gray_Distance");
Table.setColumn("mean_distance_to_gray_centre",mean_distance_to_gray_centre_array);
Table.save(dir+"Probability_Gray_Distance"+".csv");