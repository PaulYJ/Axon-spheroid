Fi=File.openDialog("choose one of the files");
Dir=File.getParent(Fi);
Par=File.getParent(Dir);
ind=lengthOf(Par);
tem=substring(Dir,ind+1, ind+4);
ani=substring(Dir,ind+1);
num=parseInt(tem);
a=getFileList(Dir);
for (i=0;i<a.length;i++) {
	setResult("Animal",i,ani);
	setResult("Original", i, a[i]);
	va=floor(random*10000)+num+i;
	setResult("Randomize", i, va);
}
updateResults();
