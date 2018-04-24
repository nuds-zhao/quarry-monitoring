a = imread([root, '20161031_new.tif']);
aa = double(a)/255;
b = imread([root, '20060329.tif']);
bb = double(b)/255;
cc = bb;

for i = 1:3
    
    maa = mean2(aa(:,:,i));
    saa = std2(aa(:,:,i));
    mbb = mean2(bb(:,:,i));
    sbb = std2(bb(:,:,i));
    cc(:,:,i) = (bb(:,:,i) - mbb)/sbb*saa+maa;

end;

imshow([bb, cc, aa]);



