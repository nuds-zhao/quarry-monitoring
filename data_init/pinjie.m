d = dir(strcat('D:\libwork\data\jingjinji\study_area1\cut_toa\refine\class\*class.tif'));
%isub = [d(:).isdir];% 判断是否是文件夹
dFolds = {d(:).name}';
bigmap=zeros(362*6,447*6);
j=1;
for i= 1:length(dFolds)%1984:2017
    ipath = strcat('D:\libwork\data\jingjinji\study_area1\cut_toa\refine\class\',dFolds{i});
    disp(i);
    in=imread(ipath);
    
    bigmap(1+(ceil(i/6)-1)*362:362*ceil(i/6),1+(j-1)*447:447*j)=in;
    j=j+1;
    if j>6
        j=1;
    end
end
imwrite(bigmap,'D:\libwork\文章\图片\everyyear\bigmap.png');