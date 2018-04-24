function transAll(path)
d = dir(strcat(path,'\L*'));
isub = [d(:).isdir];
dFolds = {d(isub).name}';
for i = 1:length(dFolds)
  dd=strcat(path,'\',dFolds{i});
  sen=dFolds{i}(4);
[KTimage,geo,info]=KTtransTif(dd,sen);
fprintf('Write file\n');
toafile=strcat(path,'\mbands');
%toafile=strcat(toafile,'\',dFolds{i});
mkdir(toafile);
toafilename=strcat(toafile,'\',dFolds{i}(11:14),'.tif');
 geotiffwrite(toafilename, KTimage, geo, 'GeoKeyDirectoryTag', info.GeoTIFFTags.GeoKeyDirectoryTag);
end
