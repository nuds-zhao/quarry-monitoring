root='D:\libwork\data\jingjinji\study_area1\';
for i=1984:2017
    dir = num2str(i);
    %p=[root,dir,'\class-p.tif'];
    p=[root,dir,'\',dir(3:4),'.tif'];
    file_exist=exist(p,'file');
    if file_exist==2
        %mkdir([root,'class']);
        mkdir([root,'image']);
        %cout=[root,'class\',dir,'_class-p.tif'];
        cout=[root,'image\',dir,'.tif'];
        copyfile(p,cout);
    else
      fprintf('%s not exist\n', p);
    end
end
    