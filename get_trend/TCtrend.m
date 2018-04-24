function TCtrend(path)
d = dir(strcat(path,'\KT_1*.tif'));
%isub = [d(:).isdir];
dFiles = {d(:).name}';
sque_b=zeros(447*362,34);
sque_g=zeros(447*362,34);
sque_w=zeros(447*362,34);
sl={sque_b,sque_g,sque_w};
iml={[],[],[]};
idl='BGW';
for id =1:3
for i = 1:length(dFiles)
  dd=strcat(path,'\',dFiles{i});
  im =imread(dd);
  [x,y,z]=size(im);
  iml{id} = im(:,:,id);
  %im_g=im(:,:,2);
  %im_w=im(:,:,3);
  sl{id}(:,i)=reshape(iml{id},x*y,1);
  %sque_g=[sque_g,reshape(im_g,x*y,1)];
  %sque_w=[sque_w,reshape(im_w,x*y,1)];
end
  [Timage, geo]=geotiffread(strcat(path,'\',dFiles{1}));
    info=geotiffinfo(strcat(path,'\',dFiles{1}));

[TC,b,li,ui]=get_trend(sl{id}');
%[TC,b]=TheilSen(sl{id}');
TC = reshape(TC,x,y);
fprintf('Write file\n');
%toafile=strcat(path,'\KTtrans');
%toafile=strcat(toafile,'\',dFolds{i});
%mkdir(toafile);
toafilename=strcat(path,'\TC',idl(id),dFiles{1}(6:7),'-',dFiles{end}(6:7),'.tif');
 geotiffwrite(toafilename, TC, geo, 'GeoKeyDirectoryTag', info.GeoTIFFTags.GeoKeyDirectoryTag);
end
