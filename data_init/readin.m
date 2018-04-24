function [img,geo,info]=readin(filepath,sen,outfilename)
 if exist(outfilename,'file')
      fprintf('%s already exist!\n',outfilename);
      return;
  end
if sen==5||sen==7
    return
    % Read in all bands
    % Band1
    n_B1=dir(strcat(filepath,'\*B1.TIF'));
    im_B1=single(imread(strcat(filepath,'\',n_B1.name)));
    % Band2
    n_B2=dir(strcat(filepath,'\*B2.TIF'));
    im_B2=single(imread(strcat(filepath,'\',n_B2.name)));
    % Band3
    n_B3=dir(strcat(filepath,'\*B3.TIF'));
    im_B3=single(imread(strcat(filepath,'\',n_B3.name)));
    % Band4
     n_B4=dir(strcat(filepath,'\*B4.TIF'));
    im_B4=single(imread(strcat(filepath,'\',n_B4.name)));
    % Band5
     n_B5=dir(strcat(filepath,'\*B5.TIF'));
    im_B5=single(imread(strcat(filepath,'\',n_B5.name)));
elseif sen ==8
        % Read in all bands
    % Band1
    n_B1=dir(strcat(filepath,'\*B2.TIF'));
    im_B1=single(imread(strcat(filepath,'\',n_B1.name)));
    % Band2
    n_B2=dir(strcat(filepath,'\*B3.TIF'));
    im_B2=single(imread(strcat(filepath,'\',n_B2.name)));
    % Band3
    n_B3=dir(strcat(filepath,'\*B4.TIF'));
    im_B3=single(imread(strcat(filepath,'\',n_B3.name)));
    % Band4
     n_B4=dir(strcat(filepath,'\*B5.TIF'));
    im_B4=single(imread(strcat(filepath,'\',n_B4.name)));
    % Band5
     n_B5=dir(strcat(filepath,'\*B6.TIF'));
    im_B5=single(imread(strcat(filepath,'\',n_B5.name)));
 
end
    % Band7
    n_B7=dir(strcat(filepath,'\*B7.TIF'));
    im_B7=single(imread(strcat(filepath,'\',n_B7.name)));
    %read mapinfo
   [Timage, geo]=geotiffread(strcat(filepath,'\',n_B7.name));
    info=geotiffinfo(strcat(filepath,'\',n_B7.name));
    [x,y]=size(im_B1);
    img0=[reshape(im_B1,x*y,1),reshape(im_B2,x*y,1), reshape(im_B3,x*y,1),reshape(im_B4,...
    x*y,1),reshape(im_B5,x*y,1),reshape(im_B7,x*y,1)];

    img=reshape(img0,x,y,6);
      fprintf('Write file\n');
  %toafile=strcat(path,'\KTtrans');
  geotiffwrite(outfilename, img, geo, 'GeoKeyDirectoryTag', info.GeoTIFFTags.GeoKeyDirectoryTag);
end