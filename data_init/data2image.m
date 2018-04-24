%function data2image(root,cla_num)
%csv转图片，并按类生成proba的时间序列csv
%root='D:\libwork\data\jingjinji\study_area1\image\csv'; 
root = 'D:\libwork\data\beijing';
subroot = '\result\';
%subroot='\result_test\weighted_mean\';

if ~exist([root,'\resultimages'],'dir')
    mkdir([root,'\resultimages']);
else
    fprintf('%s already exists!\n',[root,'\resultimages']);
end
%d = dir(strcat(root,'\cut\*.tif'));
%isub = [d(:).isdir];% 判断是否是文件夹
% dFolds = {d(:).name}';
% [Timage, geo]=geotiffread(strcat(root,'\cut\',dFolds{1}));
% info=geotiffinfo(strcat(root,'\cut\',dFolds{1}));
[Timage,geo] = geotiffread(strcat(root,'/GF2_201706_test.tif'));
info = geotiffinfo(strcat(root,'/GF2_201706_test.tif'));
sz=size(Timage);
% pro_ta=zeros(sz(1)*sz(2),33);
% pro_nt=zeros(sz(1)*sz(2),33);
% k=1;
cla_im =zeros(sz(1),sz(2));
d2 = dir(strcat(root,subroot,'GF2-class_proba.csv'));
%isub = [d(:).isdir];% 判断是否是文件夹
dFolds2 = {d2(:).name}';
for i=1:length(dFolds2)
    %dir=num2str(i);
    cpath=[root,subroot,dFolds2{i}];
    file_exist=exist(cpath,'file');
    
    if file_exist==2
        disp(i)
        d3 = dir(strcat(root,subroot,'GF2-class.csv'));
        %isub = [d(:).isdir];% 判断是否是文件夹
        dFolds3 = {d3(:).name}';
        if ~isempty(dFolds3)
            cppath=[root,subroot,dFolds3{i}];
            cla=csvread(cppath);
            cla = cla(2:end,2);
            cla(cla==0)=[];
            %cla_temp=reshape(cla,10,sz(2)*sz(1)/10);
            for j=0:sz(1)/10-1
                for l=1:10
                    cla_im(l+j*10,:)=cla(l+j*sz(1)*10:10:l+(j+1)*sz(1)*10-1);
                end
                disp (j);
            end
            
            %cla_im = reshape(cla_temp,sz(1),sz(2));
%             if exist([root,'\resultimages\',dFolds3{i}(1:16),'.tif'],'file')
%                 fprintf('%s already exist!\n',[root,'\resultimages\',dFolds3{i}(1:16),'.tif']);
%                 continue;
%             end
            geotiffwrite([root,'\resultimages\',dFolds3{i}(1:4),'.tif'], cla_im, geo, 'GeoKeyDirectoryTag', info.GeoTIFFTags.GeoKeyDirectoryTag);
        end
%         cla_proba=csvread(cpath);
%         
%         proba_im = reshape(cla_proba(2:end,2:end),sz(1),sz(2),cla_num);
%         pro_ta(:,k)=cla_proba(2:end,2);
%         pro_nt(:,k)=cla_proba(2:end,3);
%         k=k+1;
%         if exist([root,'\resultimages\',dFolds2{i}(1:16),'.tif'],'file')
%             fprintf('%s already exist!\n',[root,'\resultimages\',dFolds2{i}(1:16),'.tif']);
%             continue;
%         end
%         geotiffwrite([root,'\resultimages\',dFolds2{i}(1:16),'.tif'], proba_im, geo, 'GeoKeyDirectoryTag', info.GeoTIFFTags.GeoKeyDirectoryTag);
%         
        
    else
      fprintf('%s not exist\n', cpath);
    end
end
%csvwrite([root,'\result_test/proba_ta.csv'],pro_ta);
%csvwrite([root,'\result_test/proba_nt.csv'],pro_nt);