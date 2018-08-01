di=getDirectory("choose the parent folder");
n=nResults;
NUMBERS=newArray(n);
PLAQUES=newArray(n);
DYSTROPHY=newArray(n);
Ani=newArray(n);
Ori=newArray(n);
for (i=0;i<n;i++){
	selectWindow("Results");
	num=getResult("Randomize",i);
	file=getResultString("Original",i);
	folder=getResultString("Animal",i);
	Ani[i]=folder;
	Ori[i]=file;
	NUMBERS[i]=num;
}
run("Clear Results");
selectWindow("Results");
run("Close");
setResult("Plaque number",0, 0);
setResult("Plaque size",0, 0);
setResult("Dystrophy size",0, 0);
updateResults();
selectWindow("Results");
IJ.renameResults("TempOutput");

for (i=0;i<n;i++){
	num=NUMBERS[i];
	file=Ori[i];
	folder=Ani[i];
	direct=di+"\\"+folder+"\\"+file;
	open(direct);
	rename(num);
	selectWindow(num);
	if (i==0) {run("Measure");}
	getDimensions(width,height,channels,slices,frames);
	run("Duplicate...", "title=TS duplicate channels=2");
	selectWindow("TS");
	run("Select None");
	back=0;
	for (w=1;w<=slices;w++){
		setSlice(w);
		getStatistics(area,mean);
		if (mean>back) {
			slistart=w;
			back=mean; 
		}
	}
	setSlice(slistart);
	getStatistics(area,mean,min,max,std);
	setThreshold(mean+2.5*std,255);
	run("Convert to Mask", "method=Default background=Light");
	run("Set Measurements...", "area redirect=None decimal=3");
	run("Clear Results");
	run("Analyze Particles...", "size=5-Infinity circularity=0.00-1.00 show=Nothing display add stack");
	k=nResults;
	if (k==0) {waitForUser("choose the middle plane");}
	else {
	max=getResult("Area",0);
	sli=0;
	for (j=1;j<k;j++){
		temp=getResult("Area",j);
		if (temp>max) {
			sli=j;
			max=temp;
		}
	}
	roiManager("Show None");
	selectWindow("TS");
	roiManager("select", sli);
	waitForUser("choose the middle plane");}
	
	selectWindow("TS");
	sli=getSliceNumber;
	if (sli==1) {sli=2;}
	if (sli==slices) {sli=slices-1;}
	selectWindow("TS");
	close();
	selectWindow(num);
	roiManager("reset");
	run("Z Project...", "start=" +sli-1+ " stop=" +sli+1+ " projection=[Max Intensity]");
	rename("Zpro");

	run("Clear Results");
	run("Duplicate...", "title=Zpro-TR duplicate channels=2");
	selectWindow("Zpro-TR");
	makeRectangle(6, 4, 33, 33);
	getStatistics(area_bac,mean_bac);
	if (mean_bac>=10) {
		makeRectangle(361, 361, 33, 33);
		getStatistics(area_bac,mean_bac);
	}
	run("Select None");
	getStatistics(area_tol,mean_tol);
	totalTR=area_tol*(mean_tol-mean_bac);
	setThreshold(mean_tol+mean_bac,255);
	run("Convert to Mask");
	run("Analyze Particles...", "size=3-Infinity add");
	if (roiManager("count")==1){
	roiManager("select", 0);
	getSelectionCoordinates(Xpoints,Ypoints);
	Array.getStatistics(Xpoints,min,max,mean_X);
	Array.getStatistics(Ypoints,min,max,mean_Y);
	} else if (roiManager("count")>1){
		for (p=0;p<roiManager("count"); p++) {
			roiManager("select", p);
			getSelectionCoordinates(Xpoints,Ypoints);
			Array.getStatistics(Xpoints,min,max,tem_X);
			Array.getStatistics(Ypoints,min,max,tem_Y);
			if (150<=tem_X&&tem_X<=250 && 150<=tem_Y&&tem_Y<=250) {
				mean_X=tem_X;
				mean_Y=tem_Y;
			}
		}
	} else if (roiManager("count")==0) {waitForUser("choose the plaque");
			getSelectionCoordinates(Xpoints,Ypoints);
			Array.getStatistics(Xpoints,min,max,mean_X);
			Array.getStatistics(Ypoints,min,max,mean_Y);}
	
	selectWindow("Zpro-TR");
	close();
	roiManager("reset");
	selectWindow("Zpro");
	th=15;
	for (q=0; q<15;q++){
		setSlice(2);
		makeOval(mean_X-(150-q*10)/2, mean_Y-(150-q*10)/2, 150-q*10, 150-q*10);
		getStatistics(area_tem,mean_tem);
		if (mean_tem*area_tem<=totalTR*0.9&&th>q) th=q;
	}
	run("Select None");
	run("Duplicate...", "title=Zpro-TR2 duplicate channels=2");
	selectWindow("Zpro-TR2");
	makeOval(mean_X-(150-th*10)/2, mean_Y-(150-th*10)/2, 150-th*10, 150-th*10);
	getStatistics(area_pla,mean_pla);
	setThreshold(mean_pla*0.5+mean_bac*2,255);
	run("Convert to Mask");
	run("Analyze Particles...", "size=3-Infinity add");
	selectWindow("Zpro-TR2");
	close();
	pla=0;
	if (roiManager("count")==0) {waitForUser("choose the plaque");}
	else {
	for (p=0;p<roiManager("count"); p++) {
		roiManager("select", p);
		getSelectionCoordinates(Xpoints,Ypoints);
		Array.getStatistics(Xpoints,min,max,tem_X);
		Array.getStatistics(Ypoints,min,max,tem_Y);
		if (150<=tem_X&&tem_X<=250 && 150<=tem_Y&&tem_Y<=250) {pla=p;}
	}
	roiManager("select",pla);
	setTool("freehand");
	waitForUser("Confirm the plaque");}

	selectWindow("Zpro");
	getStatistics(area_plaque);
	PLAQUES[i]=area_plaque;
	roiManager("reset");
	getSelectionCoordinates(Xpoints,Ypoints);
	Array.getStatistics(Xpoints,min,max,plaque_center_X);
	Array.getStatistics(Ypoints,min,max,plaque_center_Y);
	run("Select None");
// measuring dystrophy
	selectWindow("Zpro");
	makeOval(plaque_center_X-20, plaque_center_Y-20, 40, 40);
	setSlice(1);
	getStatistics(area_La_total,mean_La_max);
	for (p=0;p<20;p++){
		setSlice(1);
		getStatistics(area_La_total,mean_La_temp);
		if (mean_La_temp>=mean_La_max) {run("Enlarge...", "enlarge=1"); mean_La_max=mean_La_temp;}
		else p=90;
	}
	for (m=0;m<20;m++){
		setSlice(1);
		getStatistics(area_La_total,mean_La_temp);
		if (mean_La_temp>=mean_La_max*0.8) run("Enlarge...", "enlarge=1");
		else m=90;
	}
	setSlice(1);
	getStatistics(area, mean, min, max, std, histogram);
	Array.getStatistics(histogram, min, max, mean_h);
	totalpix=mean_h*256;
	sum=0;
	for (th_La=0; th_La<256; th_La++){
		if (sum<totalpix*0.25) sum=sum+histogram[th_La];
		else {thL=th_La;th_La=900;}
		}
		
	run("Select None");
	run("Duplicate...", "title=Zpro-Lamp1 duplicate channels=1");
	selectWindow("Zpro-Lamp1");
	run("Smooth");
	setThreshold(thL,255);
	run("Convert to Mask", "method=Default background=Light black");
	run("Analyze Particles...", "size=10-Infinity add");
	selectWindow("Zpro-Lamp1");
	close();
	ds=roiManager("count");
	if (ds==0) {setTool("freehand"); waitForUser("choose the dystrophy");}
	else {
	dys=0;
	for (u=0;u<ds;u++) {
		roiManager("select", u);
		getSelectionCoordinates(Xpoints,Ypoints);
		Array.getStatistics(Xpoints,min,max,tem_X);
		Array.getStatistics(Ypoints,min,max,tem_Y);
		if (150<=tem_X&&tem_X<=250 && 150<=tem_Y&&tem_Y<=250) {dys=u;}
	}
	roiManager("select",dys);
	setTool("freehand");
	waitForUser("Confirm the dystrophy");}
	
	selectWindow("Zpro");
	getStatistics(area_dystrophy);
	DYSTROPHY[i]=area_dystrophy;
	roiManager("reset");
	run("Select None");
	selectWindow("Zpro");
	close();
	selectWindow(num);
	close();

	selectWindow("Results");
	IJ.renameResults("TempR");
	selectWindow("TempOutput"); 
        IJ.renameResults("Results"); 
	setResult("Plaque number",i, NUMBERS[i]);
	setResult("Plaque size",i, PLAQUES[i]);
	setResult("Dystrophy size",i, DYSTROPHY[i]);
	updateResults();
	selectWindow("Results");
	IJ.renameResults("TempOutput");
	selectWindow("TempR");
	IJ.renameResults("Results");
}
run("Clear Results");

for (i=0;i<n;i++) {
	setResult("Plaque number", i, NUMBERS[i]);
	setResult("Plaque size",i, PLAQUES[i]);
	setResult("Dystrophy size",i, DYSTROPHY[i]);
}
