function combine(rootin, rootout)
n = length(rootin);
a = imread([rootin{1}, '2015.tif']);
h = size(a,1);
w = size(a,2);
cc = zeros([h, w*n, 3], 'uint8');

mkdir(rootout);
d = dir([rootin{1}, '*.tif']);
for i = 1:length(d)
    for j = 1:n
        a = imread([rootin{j}, d(i).name]);
        cc(:,(j-1)*w+1:j*w,:) = a;
    end;
    imwrite(cc, [rootout, d(i).name]);
end;

    