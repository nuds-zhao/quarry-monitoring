r = 50;
eps = 0.2^2;

rootp=[root,'result_test\weighted_mean\resultimages\'];
d = dir([rootp, '*proba.tif']);
t = length(d);

side = 1000;
a = imread([rootp, d(1).name]);
if z > 1
    a = boxSmaller(a,z);
end;
sz = size(a);

ccc = zeros([sz(1),sz(2),sz(3),t], 'single');

for k = 1:t
    disp(k);
    a = imread([rootp, d(k).name]);
    aa = single(a);
    if (z > 1)
        aa = boxSmaller(aa,z);
    end;
    ccc(:,:,:,k) = aa;
end;
% 
% for i = 1:5
%    gm(i) = mean2(ccc(:,:,i,end));
%    gs(i) = std2(ccc(:,:,i,end));
% end;
