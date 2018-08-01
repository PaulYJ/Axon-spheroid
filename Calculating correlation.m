%%
FileTif='noDS_example.tif';
InfoImage=imfinfo(FileTif);
mImage=InfoImage(1).Width;
nImage=InfoImage(1).Height;
NumberImages=length(InfoImage);
ImageSerial=zeros(nImage,mImage,NumberImages,'uint16');

TifLink = Tiff(FileTif, 'r');
for i=1:NumberImages
   TifLink.setDirectory(i);
   ImageSerial(:,:,i)=TifLink.read();
end
TifLink.close();

%%
[m n p] = size(ImageSerial);
a = ImageSerial;
b = permute(a,[3,1,2]);
c = reshape(b,p,[]);
bw = roipoly(mat2gray(a(:,:,1)));
bw = repmat(bw,[1 1 p]);
d = repmat(mean(reshape(a(bw),[],p))',1,m*n);
%%
c = double(c);
x = bsxfun(@minus,c,mean(c,1));
y = bsxfun(@minus,d,mean(d,1));
temp = sum(x.*y)./sqrt(sum(x.*x).*sum(y.*y));
corrimg = reshape(temp,m,n);
figure,imshow(corrimg,[-1 1]);colormap Gray
