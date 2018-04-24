root = 'D:\libwork\data\jingjinji\study_area1\cut_toa\refine\class';
[Timage, geo]=geotiffread(strcat(root,'/1984.tif'));
info=geotiffinfo(strcat(root,'/1984.tif'));
b_list={'1984','1992','2002','2010','2013','2016','2007'};
a_list={'1992','2002','2010','2013','2016','2017','2008'};
for i=1:7
    b = b_list{i};
    a = a_list{i};
    before = imread([root,'/',b,'-class.tif']);
    after = imread([root,'/',a,'-class.tif']);
    m=ones(size(before,1),size(before,2),1);
    mm(:,:,1)=im2uint8(~before);
    mm(:,:,2)=im2uint8(~after);
    mm(:,:,3)=m*255;
%imwrite(double(mm), [rootp, 'refine\jpeg\', d(k).name(1:4), '.jpg']);
    geotiffwrite([root,'/',b(3:4),'-',a(3:4),'.tif'], double(mm), geo, 'GeoKeyDirectoryTag', info.GeoTIFFTags.GeoKeyDirectoryTag);
end