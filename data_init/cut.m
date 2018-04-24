function cut(root,cutpath,region)
%region='507585 4436955 520995 4426095';
% ulx='507585';
% uly='4436955';
% lrx='520995';
% lry='4426095';
%path=char(strcat(root,'\',dFolds{i},'\TOA_',dFolds{i},'.tif'));  

    fpath=dir(strcat(root,'\sixbands*.tif'));
    files=fpath.name;
    path=char(strcat(root,'\',files));
    file_exist=exist(path,'file');
    if file_exist==2
        cutfile_path=strcat(cutpath,'\cut');
        cut=char(strcat(cutfile_path,'\',files(10:13)));
        if ~exist(cutfile_path,'dir')
           mkdir(cutfile_path);
        end
        if exist([cut,'.tif'],'file')
             fprintf('%s.tif already exist!\n', cut);
             return;
        end
         s = sprintf('gdal_translate -of gtiff -projwin %s "%s" "%s.tif"', region,path, cut);
         fprintf('%s\n', s);
        system(s);
        fprintf('\n');
    else
      fprintf('%s not exist!\n', files);
    end   
end