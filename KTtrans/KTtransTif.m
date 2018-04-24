function [TCimage,geo,info]=KTtransTif(filepath,sen)
if sen=='5'||'7';
    % Read in all bands
    % Band1
    n_B1=dir(strcat(filepath,'\*band1*.tif'));
    im_B1=single(imread(strcat(filepath,'\',n_B1.name)));
    % Band2
    n_B2=dir(strcat(filepath,'\*band2*.tif'));
    im_B2=single(imread(strcat(filepath,'\',n_B2.name)));
    % Band3
    n_B3=dir(strcat(filepath,'\*band3*.tif'));
    im_B3=single(imread(strcat(filepath,'\',n_B3.name)));
    % Band4
     n_B4=dir(strcat(filepath,'\*sr_band4*.tif'));
    im_B4=single(imread(strcat(filepath,'\',n_B4.name)));
    % Band5
     n_B5=dir(strcat(filepath,'\*band5*.tif'));
    im_B5=single(imread(strcat(filepath,'\',n_B5.name)));
elseif sen =='8'
        % Read in all bands
    % Band1
    n_B1=dir(strcat(filepath,'\*band2*.tif'));
    im_B1=single(imread(strcat(filepath,'\',n_B1.name)));
    % Band2
    n_B2=dir(strcat(filepath,'\*band3*.tif'));
    im_B2=single(imread(strcat(filepath,'\',n_B2.name)));
    % Band3
    n_B3=dir(strcat(filepath,'\*band4*.tif'));
    im_B3=single(imread(strcat(filepath,'\',n_B3.name)));
    % Band4
     n_B4=dir(strcat(filepath,'\*sr_band5*.tif'));
    im_B4=single(imread(strcat(filepath,'\',n_B4.name)));
    % Band5
     n_B5=dir(strcat(filepath,'\*band6*.tif'));
    im_B5=single(imread(strcat(filepath,'\',n_B5.name)));
 
end
    % Band7
    n_B7=dir(strcat(filepath,'\*band7*.tif'));
    im_B7=single(imread(strcat(filepath,'\',n_B7.name)));
    %read mapinfo
   [Timage, geo]=geotiffread(strcat(filepath,'\',n_B7.name));
    info=geotiffinfo(strcat(filepath,'\',n_B7.name));
    
        % only processing pixesl where all bands have values (id_mssing)
    id_missing=im_B1==0|im_B2==0|im_B3==0|im_B4==0|im_B5==0|im_B7==0;
     %[cut_image, geo]=geotiffread(strcat(filepath,'\',n_B7.name));
    %info=geotiffinfo(strcat(filepath,'\',n_B7.name));

    [x,y]=size(im_B1);
img0=[reshape(im_B1,x*y,1),reshape(im_B2,x*y,1), reshape(im_B3,x*y,1),reshape(im_B4,...
    x*y,1),reshape(im_B5,x*y,1),reshape(im_B7,x*y,1)];
%img1 = KT_computer(img0);
img1=img0;
 TCimage=reshape(img1,x,y,6);
%img0=double(img0);
%KT factors for L7
function img1 = KT_computer(img0)
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
img1 = img0 * KT';

%min0 = min(img1);
%max0 = max(img1);
%dm = max0 - min0;
%img11 = img1 - repmat(min0,x*y,1);
%img2 = (img11./repmat(dm,x*y,1))*65535;
%image = reshape(img2,x,y,6)
%figure,imshow(uint16(image(:,:,1))),title('KT变换第一分量：亮度');
%figure,imshow(uint16(image(:,:,2))),title('KT变换的第二分量：绿度');
%figure,imshow(uint16(image(:,:,3))),title('KT变换的第三分量：湿度');
%filename=[filepath,'\TC.tif'];
%geotiffwrite(filename, TCimage, geo, 'GeoKeyDirectoryTag', info.GeoTIFFTags.GeoKeyDirectoryTag);
%figure
%imshow(uint8(image(:,:,4))),title('KT变换的第四分量：黄度指数及噪声');
 
