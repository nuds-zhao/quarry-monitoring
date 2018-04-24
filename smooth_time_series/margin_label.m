function margin_label(root)
ps = 36;
more = ''; %'by RADI';

mkdir([root, 'label\']);

d = dir([root, '*.tif']);
a = imread([root, d(1).name]);
sz = size(a);
for i = 1:length(d)
    fn = d(i).name;
    if (length(more) > 0)
        s = sprintf('gm convert -font Arial -pointsize %d -fill red -draw "text 10,%d ''%s''" %s %s', ps, ps*1, fn(1:4), [root, fn], [root, 'temp.tif']);
        disp(s); system(s); fprintf('\n\n'); 
        s = sprintf('gm convert -font Arial -pointsize %d -fill red -draw "text 10,%d ''%s''" %s %s', ps, sz(1)-ps*0.5, more, [root, 'temp.tif'], [root, 'label\', fn]);
        disp(s); system(s); fprintf('\n\n');   
    else
        s = sprintf('gm convert -font Arial -pointsize %d -fill red -draw "text 10,%d ''%s''" %s %s', ps, ps*1, fn(1:4), [root, fn], [root, 'label\', fn]);
        disp(s); system(s); fprintf('\n\n');        
    end;
end;

