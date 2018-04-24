%function Data_preprocess()
path='D:\libwork\data\Landsat\xionganMay';
region='374715 4337715 445395 4283145';
d = dir(strcat(path,'\L*'));
isub = [d(:).isdir];
dFolds = {d(isub).name}';
for i = 1:length(dFolds)
  dd=strcat(path,'\',dFolds{i});
  sen=dFolds{i}(4);
  sen=str2double(sen);
  date=dFolds{i}(18:21);%take 2013 from LC08_L1TP_123033_20130512_20170504_01_T1,the Landsat colllection 1 level 1 products' name
  outfilename=strcat(dd,'\sixbands_',date,'.tif');
  readin(dd,sen,outfilename);
  cut(dd,path,region);
  subpath='cut';
  image2csv(path,subpath,date);
end
image2csv(path,'traindata','trainL5');
image2csv(path,'traindata','trainL8');

% end









