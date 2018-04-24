function add_mask(root)
if exist([root, 'mask.png'], 'file')
    mkdir([root, 'mask']);
    m = imread([root, 'mask.png']);
    m = double(m);
    m = m / max(m(:));
    
    d = dir([root, 'label/', '*.tif']);
    for i = 1:length(d)
        b = double(imread([root, 'label/', d(i).name]))/255;
        b(:,:,1) = b(:,:,1) .* (1-m) + 255 .* m;
        b(:,:,2) = b(:,:,2) .* (1-m) + 0;
        b(:,:,3) = b(:,:,3) .* (1-m) + 0;
        imwrite(b, [root, 'mask/', d(i).name]);
    end;
end;
