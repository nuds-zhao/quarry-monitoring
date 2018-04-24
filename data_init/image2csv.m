
%function image2csv(root,subpath,date)
%root='D:\libwork\data\jingjinji\study_area1\';
%root='D:\libwork\data\jingjinji\study_area1\image\csv\result\resultimages\refine\';
%     dir = num2str(i);
%   ipath=[root,'image\',dir,'.tif']; 
root = 'D:\libwork\data\beijing';
date = 'GF2_201706_test';
if ~exist([root,'\csv'],'dir')
    mkdir([root,'\csv']);
end
if exist([root,'\csv\',date,'-data.csv'],'file')
    fprintf('%s already exist!\n',[root,'\csv\',date,'-data.csv']);
    return;
end
ipath=[root,'\',date,'.tif'];
file_exist=exist(ipath,'file');
if file_exist==2
    disp(date);
    [Timage,geo] = geotiffread(strcat(root,'/GF2_201706_test.tif'));
    in=Timage;
    sz=size(in);      
    inst=reshape(in,sz(1)*sz(2),sz(3));
    inst=double(inst);
%     if exist([root,'\',subpath,'\',date,'-label.tif'],'file')
%         lab=imread([root,'\',subpath,'\',date,'-label.tif']);
%         lab=reshape(lab,sz(1)*sz(2),1);
%         if date(7)=='5'
%             sen=5;
%         else
%             sen=8;
%         end
%         imb=index_compute(inst,sen);
%         instances=[inst,imb,double(lab)];
%     else
%         if str2double(date)<2012
%             sen=5;
%         else
%             sen=8;
%         end
%         imb=index_compute(inst,sen);
%         instances=[inst,imb];
%     end
    instances = inst;
    td=size(instances,2);
    csvwrite([root,'\csv\',date,'-data.csv'],[zeros(1,td);single(instances)]);
%       inst=reshape(in,362*447,6);%case 1
%         cla=imread([root,'class\rearranged\',dir,'_class-p.tif']);
%         cla=reshape(cla,362*447,1);
%         instances=[inst,cla];
%         mkdir([root,'\csv']); 
%         csvwrite([root,'image\csv\',dir,'-data.csv'],[zeros(1,7);instances]);
%         mkdir([root,'\refinedcsv']);%case 2
%         csvwrite([root,'\refinedcsv\',dir,'-class_proba_refined.csv'],[zeros(1,5);inst]);
    else
        fprintf('%s not exist\n', ipath);
end
   


% function imb=index_compute(ima,sen)
% 
% ndvi=(ima(:,4)-ima(:,3))./(ima(:,4)+ima(:,3));
% ndwi=(ima(:,2)-ima(:,4))./(ima(:,2)+ima(:,4));
% ndmi=(ima(:,4)-ima(:,5))./(ima(:,4)+ima(:,5));
% %KT factors for L7
% KT_etm = [0.3561, 0.3972, 0.3904, 0.6966, 0.2286, 0.1596;
%  
%          -0.3344,-0.3544,-0.4556, 0.6966,-0.0242,-0.2630;
%  
%          0.2626, 0.2141, 0.0926, 0.0656, -0.7629,-0.5388;
%          
%           0.0805 -0.0498  0.1950 -0.1327  0.5752 -0.7775;
%           
%          -0.7252 -0.0202  0.6683  0.0631 -0.1494 -0.0274;
%           
%           0.4000 -0.8172  0.3832  0.0602 -0.1095  0.0985];
% %KT factors for L5
% KT_tm = [0.2043, 0.4158, 0.5524, 0.5741, 0.3124, 0.2303;
%  
%          -0.1603,-0.2819,-0.4934, 0.7940,-0.0002,-0.1446;
%  
%          0.0315, 0.2021, 0.3102, 0.1594,-0.6806,-0.6109;
%          
%          -0.2117 -0.0284 0.1302  -0.1007  0.6529 -0.7078;
%          
%          -0.8669 -0.1835  0.3856  0.0408 -0.1132  0.2272;
%          
%          0.3677  -0.8200  0.4354  0.0518 -0.0066 -0.0104]; 
% %KT factors for L8
% KT_OLI = [0.3029, 0.2786, 0.4733, 0.5599, 0.508, 0.1872;
%  
%          -0.2941, -0.243,-0.5424, 0.7276, 0.0713,-0.1608;
%  
%          0.1511, 0.1973, 0.3283, 0.3407, -0.7117,-0.4559;
%          
%          -0.8239  0.0849  0.4396 -0.058   0.2013 -0.2773;
%          
%          -0.3294  0.0557  0.1056  0.1855 -0.4349  0.8085;
%          
%           0.1079 -0.9023  0.4119  0.0575 -0.0259  0.0252]; 
%       
% if sen==5
%     KT = KT_tm;
% elseif sen==7
%     KT=KT_etm;
% elseif sen ==8
%     KT=KT_OLI;
% end
% img = double(ima) * KT';
% imb=[ndvi,ndwi,ndmi,img(:,1),img(:,2),img(:,3)];
% end

