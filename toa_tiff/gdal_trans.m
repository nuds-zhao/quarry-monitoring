root='D:\libwork\data\jingjinji\study_area1\';
for i=1984:2017
    dir = num2str(i);
    %fpath=[root,dir,'\',dir(3:4),'.dat'];
    %file_exist=exist(fpath,'file');
    
    cpath=[root,dir,'\class.dat'];

    file_exist=exist(cpath,'file');
    if file_exist==2
        %out=[root,dir,'\',dir(3:4),'.tif'];
        mkdir([root,'class']);
        cout=[root,'class\',dir(3:4),'_class.tif'];
        %s = sprintf('gdal_translate  "%s" "%s"', fpath, out);
         s = sprintf('gdal_translate  "%s" "%s"', cpath, cout);
        fprintf('%s\n', s);
        system(s);
        fprintf('\n');
     else
      fprintf('%s not exist\n', cpath);
    end
end
