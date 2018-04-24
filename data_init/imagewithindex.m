function imagewithindex()
%root='D:\libwork\data\jingjinji\study_area1\';
root = 'D:\libwork\data\xiongan\classify';
subroot = 'cut_toa\';
%root='D:\libwork\data\jingjinji\study_area1\image\csv\result\resultimages\refine\';
d = dir(strcat(root,'\*.tif'));
%isub = [d(:).isdir];% 判断是否是文件夹
dFolds = {d(:).name}';
for i= 1:length(dFolds)%1984:2017
    ipath = strcat(root,'\',dFolds{i});
    %dir = num2str(i);
    %ipath=[root,subroot,'cut\',dir,'.tif'];
    %ipath=[root,dir,'-class_proba.tif'];
    file_exist=exist(ipath,'file');
    if file_exist==2
        disp(i);
        in=imread(ipath);
        inst=reshape(in,362*447,6);
        inst=double(inst);
        if i+1983<2012
            sen='5';
        else
            sen='8';
        end
        index = index_compute(inst,sen);
        %inst=reshape(in,362*447,5);
        cla=imread([root,'class\rearranged\',dir,'_class-p.tif']);
        cla=reshape(cla,362*447,1);
        cla_mask=cla==1;
        cla=double(cla) .* double(cla_mask);
        instances=[inst,index,double(cla)];
        sz=size(instances);
        mkdir([root,subroot,'csvwithindex']); 
        csvwrite([root,subroot,'csvwithindex\',dir,'-data.csv'],[zeros(1,sz(2));instances]);
        else
      fprintf('%s not exist\n', ipath);
    end
    
end

end

function imb=index_compute(ima,sen)

ndvi=(ima(:,4)-ima(:,3))./(ima(:,4)+ima(:,3));
ndwi=(ima(:,2)-ima(:,4))./(ima(:,2)+ima(:,4));
ndbi= -(ima(:,4)-ima(:,5))./(ima(:,4)+ima(:,5));

%KT factors for L7
KT_etm = [0.3561, 0.3972, 0.3904, 0.6966, 0.2286, 0.1596;
 
         -0.3344,-0.3544,-0.4556, 0.6966,-0.0242,-0.2630;
 
         0.2626, 0.2141, 0.0926, 0.0656, -0.7629,-0.5388;
         
          0.0805 -0.0498  0.1950 -0.1327  0.5752 -0.7775;
          
         -0.7252 -0.0202  0.6683  0.0631 -0.1494 -0.0274;
          
          0.4000 -0.8172  0.3832  0.0602 -0.1095  0.0985];
%KT factors for L5
KT_tm = [0.2043, 0.4158, 0.5524, 0.5741, 0.3124, 0.2303;
 
         -0.1603,-0.2819,-0.4934, 0.7940,-0.0002,-0.1446;
 
         0.0315, 0.2021, 0.3102, 0.1594,-0.6806,-0.6109;
         
         -0.2117 -0.0284 0.1302  -0.1007  0.6529 -0.7078;
         
         -0.8669 -0.1835  0.3856  0.0408 -0.1132  0.2272;
         
         0.3677  -0.8200  0.4354  0.0518 -0.0066 -0.0104]; 
%KT factors for L8
KT_OLI = [0.3029, 0.2786, 0.4733, 0.5599, 0.508, 0.1872;
 
         -0.2941, -0.243,-0.5424, 0.7276, 0.0713,-0.1608;
 
         0.1511, 0.1973, 0.3283, 0.3407, -0.7117,-0.4559;
         
         -0.8239  0.0849  0.4396 -0.058   0.2013 -0.2773;
         
         -0.3294  0.0557  0.1056  0.1855 -0.4349  0.8085;
         
          0.1079 -0.9023  0.4119  0.0575 -0.0259  0.0252]; 
      
if sen=='5'
    KT = KT_tm;
elseif sen=='7'
    KT=KT_etm;
elseif sen =='8';
    KT=KT_OLI;
end
img = double(ima) * KT';
imb=[ndvi,ndwi,ndbi,img(:,1),img(:,2),img(:,3)];
end
