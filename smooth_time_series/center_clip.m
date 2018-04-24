function center_clip(rootin, rootout, sz)
mkdir([rootout]);
d = dir([rootin, '*.tif']);
a = imread([rootin, d(1).name]);
y0 = floor((size(a,1) - sz(1)) / 2);
x0 = floor((size(a,2) - sz(2)) / 2);

for i = 1:length(d)
    s = sprintf('gdal_translate -srcwin %d %d %d %d %s %s', x0, y0, sz(2), sz(1), [rootin, d(i).name], [rootout, d(i).name]);
    fprintf('%s\n', s);
    system(s);
end;

