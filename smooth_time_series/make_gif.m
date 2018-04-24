function make_gif(root, sel, out, delay)

d = dir([root, sel]);

a = imread([root, d(1).name]);
if (ndims(a)==2)
    b = zeros([size(a,1), size(a,2), 3], 'uint8');
    b(:,:,1) = a; b(:,:,2) = a; b(:,:,3) = a;
else
    b = a;
end;
[imind,cm] = rgb2ind(b,256);
imwrite(imind,cm, out,'gif', 'Loopcount',inf, 'DelayTime',delay);

for i = 2:length(d)
    a = imread([root, d(i).name]);
    if (ndims(a)==2)
        b = zeros([size(a,1), size(a,2), 3], 'uint8');
        b(:,:,1) = a; b(:,:,2) = a; b(:,:,3) = a;
    else
        b = a;
    end;
    [imind,cm] = rgb2ind(b,256);
    imwrite(imind,cm, out,'gif','WriteMode','append','DelayTime',delay);
end;

