root = 'D:\libwork\data\jingjinji\study_area1\';

n = zeros(35,4);
beijing = imread([root, 'test\beijing.tif']);
tianjin = imread([root, 'test\tianjin.tif']);
demmask = imread([root,'demmask\dilatedmask.tif']);
[Timage, geo]=geotiffread(strcat(root,'cut_toa\refine\',num2str(1984),'-class_proba.tif'));
info=geotiffinfo(strcat(root,'cut_toa\refine\',num2str(1984),'-class_proba.tif'));
subroot = 'cut_toa\refine\';
for i = 1:34
    path=[root,subroot,num2str(i+1983),'-class_proba.tif'];
    if (~exist(path,'file'))
        continue;
    end
    a = imread(path);
    z = a(:,:,2);
    bj_mask = (beijing(:,:,1) == 255) & (demmask==1);
    all = z.*double(demmask);
    tj_mask = (tianjin(:,:,1) == 255) & (demmask==1);
    
%     bj_mask = (beijing(:,:,1) == 255);
%     all = z;
%     tj_mask = (tianjin(:,:,1) == 255);
    xbj = z .* double(bj_mask);
    xtj = z .* double(tj_mask);
    luodi=0.5;
    n(i+1,1)=sum(xbj(xbj>luodi))*900;
    n(i+1,2)=sum(xtj(xtj>luodi))*900;
    n(i+1,4)=sum(all(all>luodi))*900;
    n(i+1,3)=n(i+1,4)-n(i+1,2)-n(i+1,1);
    mask = all>luodi;
    geotiffwrite([root,subroot,'class\',num2str(i+1983),'-class.tif'], mask, geo, 'GeoKeyDirectoryTag', info.GeoTIFFTags.GeoKeyDirectoryTag);
    
end
csvwrite([root,subroot,'htarea-with-demmask.csv'],n);




