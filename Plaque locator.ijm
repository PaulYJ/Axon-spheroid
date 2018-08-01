run("Clear Results");
roiManager("reset");
ti=getTitle();
selectWindow(ti);
setTool("multipoint");
waitForUser("Choose the plaques for analyze");
roiManager("Add");
getSelectionCoordinates(Xpoints, Ypoints);

fi=File.openDialog("select the original file");
di=getDirectory("Choose store location");

run("Bio-Formats Importer", "open=" +fi+ " color_mode=Default crop view=Hyperstack stack_order=XYCZT series_1 x_coordinate_1=0 y_coordinate_1=0 width_1=400 height_1=400");
getDimensions(width,height,channels,slices,frames);
close();

n=Xpoints.length;
for (i=1; i<=n; i++){
	name=di+"plaque_"+d2s(i,0)+".tif";
	x=Xpoints[i-1]-200;
	y=Ypoints[i-1]-200;
	run("Bio-Formats Importer", "open=" +fi+ " color_mode=Default crop specify_range view=Hyperstack stack_order=XYCZT c_begin=2 c_end=3 c_step=1 z_begin=1 z_end=slices z_step=1 x_coordinate_1=x y_coordinate_1=y width_1=400 height_1=400");
	save(name);
	close();
}
