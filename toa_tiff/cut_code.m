function cut_code(root,cutpath)
region='507585 4436955 520995 4426095';
ulx='507585';
uly='4436955';
lrx='520995';
lry='4426095';
d = dir(strcat(root,'\L*'));
isub = [d(:).isdir];
dFolds = {d(isub).name}';
for i = 1:length(dFolds)
    %path=char(strcat(root,'\',dFolds{i},'\TOA_',dFolds{i},'.tif'));
    fpath=dir(strcat(root,'\',dFolds{i},'\*sr_band*.tif'));
    files={fpath.name}';
    for j = 1:length(files)
    path=char(strcat(root,'\',dFolds{i},'\',files{j}));
    file_exist=exist(path,'file');
    if file_exist==2
    cutfile_path=strcat(cutpath,'\cut\',dFolds{i});
       mkdir(cutfile_path)
     cut=char(strcat(cutfile_path,'\cut_',files{j}));
     s = sprintf('gdal_translate -of gtiff -projwin %s "%s" "%s.tif"', region,path, cut);

     fprintf('%s\n', s);
    system(s);
    fprintf('\n');
    else
      fprintf('%s\n', files{j});
    end   
    end
end
