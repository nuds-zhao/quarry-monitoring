function convertToa(path)
% % d = dir(strcat(path,'LS8_C_20140226*'));
% % isub = [d(:).isdir];
% % dFolds = {d(isub).name}';
% % for i = 1:length(dFolds)
% %   dd=strcat(path,'\',dFolds{i})
% % [TOAref,geo,info]=nd2toarbtTif(dd);
% % toafile=strcat(toafilepath,'\',dFolds{i});
% % mkdir(toafile);
% % toafilename=strcat(toafile,'\TOA_',dFolds{i},'.tif');
% %  geotiffwrite(toafilename, TOAref, geo, 'GeoKeyDirectoryTag', info.GeoTIFFTags.GeoKeyDirectoryTag);
% % % enviwrite(toafilename,TOAref,'single',resolu,ul,'bsq',zc,vert);
% % end
% tic;
% [TOAref,ul,zc,resolu]=nd2toarbt('I:\TM7\L7\LE70430342001234EDC00');
% toafile= 'I:\TM7\L7\LE70430342001234EDC00\toa';
% mkdir(toafile);
% toafilename=strcat(toafile,'\TOA_LE70430342001234EDC00');
% enviwrite(toafilename,TOAref,'single',resolu,ul,'bsq',zc);
% toc
d = dir(strcat(path,'\L*'));
isub = [d(:).isdir];
dFolds = {d(isub).name}';
for i = 1:length(dFolds)
  dd=strcat(path,'\',dFolds{i});
[TOAref,geo,info]=nd2toarbtTif(dd);
fprintf('Write file\n');
toafile=strcat(path,'\toa');
toafile=strcat(toafile,'\',dFolds{i});
mkdir(toafile);
toafilename=strcat(toafile,'\TOA_',dFolds{i},'.tif');
 geotiffwrite(toafilename, TOAref, geo, 'GeoKeyDirectoryTag', info.GeoTIFFTags.GeoKeyDirectoryTag);
% enviwrite(toafilename,TOAref,'single',resolu,ul,'bsq',zc,vert);
end