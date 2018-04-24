function get_label()
%root='D:\libwork\data\Landsat\xionganMay\';
root = 'D:\libwork\data\xiongan\classify';
d = dir(strcat(root,'\mask\*.tif'));
%isub = [d(:).isdir];% 判断是否是文件夹
dFolds = {d(:).name}';
mkdir([root,'\csv\']);
for i = 1:length(dFolds)
  dd=strcat(root,'\mask\',dFolds{i});
  temp = imread(dd);
  T = find(temp);
  T=T-1;
  dlmwrite([root,'\csv\',dFolds{i}(1:end-4),'.csv'],[0;T],'precision','%d');
end
% 
% tian8=imread([root,'cut\tianL8.tif']);
% town8=imread([root,'cut\townL8.tif']);
% wetland8=imread([root,'cut\wetlandL8.tif']);
% tian5=imread([root,'cut\tianL5.tif']);
% town5=imread([root,'cut\townL5.tif']);
% wetland5=imread([root,'cut\wetlandL5.tif']);
% 
% L5f = find(tian5);
% L5t = find(town5);
% L5w = find(wetland5);
% L8f = find(tian8);
% L8t = find(town8);
% L8w = find(wetland8);
% 
% dlmwrite([root,'csv\L5farm.csv'],[0;L5f],'precision',7);
% dlmwrite([root,'csv\L5town.csv'],[0;L5t],'precision',7);
% dlmwrite([root,'csv\L5wetland.csv'],[0;L5w],'precision',7);
% dlmwrite([root,'csv\L8farm.csv'],[0;L8f],'precision',7);
% dlmwrite([root,'csv\L8town.csv'],[0;L8t],'precision',7);
% dlmwrite([root,'csv\L8wetland.csv'],[0;L8w],'precision',7);
end

