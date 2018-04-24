root = 'D:\libwork\data\jingjinji\study_area1\class\';
mkdir([root, 'rearranged\']);
d = dir([root, '*.tif']);
t = length(d);

a = imread([root, d(1).name]);
sz = size(a);
ccc = zeros([sz(1),sz(2),t], 'single');

for k = 1:t
    disp(k);
    a = imread([root, d(k).name]);
    aa = single(a);
    ccc(:,:,k) = aa;
end;
%arrange classes as 1 for loudi 2 for shan 3 for tian 4 for cun 5 for
%huangdi

for k=1:2
    
    idxh=find(ccc(:,:,k)==2);
    idxs=find(ccc(:,:,k)==3);
    idxt=find(ccc(:,:,k)==4);
    idxc=find(ccc(:,:,k)==5);
    idxu=find(ccc(:,:,k)==0);
    k=k-1;
    ccc(idxu+sz(1)*sz(2)*k)=4;
    ccc(idxh+sz(1)*sz(2)*k)=5;
    ccc(idxs+sz(1)*sz(2)*k)=2;
    ccc(idxt+sz(1)*sz(2)*k)=3;
    ccc(idxc+sz(1)*sz(2)*k)=4;
end

for k=[3 4 5]
    idxu=find(ccc(:,:,k)==0);
    k=k-1;
    ccc(idxu+sz(1)*sz(2)*k)=4;
end

for k=[6 8 9 10]
    
    idxc=find(ccc(:,:,k)==3);
    idxh=find(ccc(:,:,k)==4);
    idxt=find(ccc(:,:,k)==5);
    idxu=find(ccc(:,:,k)==0);
    k=k-1;
    ccc(idxu+sz(1)*sz(2)*k)=4;
    ccc(idxc+sz(1)*sz(2)*k)=4;
    ccc(idxh+sz(1)*sz(2)*k)=5;
    ccc(idxt+sz(1)*sz(2)*k)=3;
end

for k=[7]
    
    idxl=find(ccc(:,:,k)==2);
    idxs=find(ccc(:,:,k)==1);
    idxt=find(ccc(:,:,k)==4);
    idxc=find(ccc(:,:,k)==5);
    idxh=find(ccc(:,:,k)==3);
    idxu=find(ccc(:,:,k)==0);
    k=k-1;
    ccc(idxu+sz(1)*sz(2)*k)=4;
    ccc(idxl+sz(1)*sz(2)*k)=1;
    ccc(idxs+sz(1)*sz(2)*k)=2;
    ccc(idxt+sz(1)*sz(2)*k)=3;
    ccc(idxc+sz(1)*sz(2)*k)=4;
    ccc(idxh+sz(1)*sz(2)*k)=5;
    
end

for k=11:14
    
    idxs=find(ccc(:,:,k)==5);
    idxt=find(ccc(:,:,k)==4);
    idxc=find(ccc(:,:,k)==2);
    idxh=find(ccc(:,:,k)==3);
    idxu=find(ccc(:,:,k)==0);
    k=k-1;
    ccc(idxu+sz(1)*sz(2)*k)=4;
    ccc(idxs+sz(1)*sz(2)*k)=2;
    ccc(idxt+sz(1)*sz(2)*k)=3;
    ccc(idxc+sz(1)*sz(2)*k)=4;
    ccc(idxh+sz(1)*sz(2)*k)=5;
    
end

for k=[15 16]
    
    idxs=find(ccc(:,:,k)==4);
    idxt=find(ccc(:,:,k)==3);
    idxc=find(ccc(:,:,k)==2);
    idxh=find(ccc(:,:,k)==5);
    idxu=find(ccc(:,:,k)==0);
    k=k-1;
    ccc(idxu+sz(1)*sz(2)*k)=4;
    ccc(idxs+sz(1)*sz(2)*k)=2;
    ccc(idxt+sz(1)*sz(2)*k)=3;
    ccc(idxc+sz(1)*sz(2)*k)=4;
    ccc(idxh+sz(1)*sz(2)*k)=5;
    
end

for k=17:20
    
    idxl=find(ccc(:,:,k)==5);
    idxs=find(ccc(:,:,k)==3);
    idxt=find(ccc(:,:,k)==2);
    idxc=find(ccc(:,:,k)==1);
    idxh=find(ccc(:,:,k)==4);
    idxu=find(ccc(:,:,k)==0);
    k=k-1;
    ccc(idxu+sz(1)*sz(2)*k)=4;
    ccc(idxl+sz(1)*sz(2)*k)=1;
    ccc(idxs+sz(1)*sz(2)*k)=2;
    ccc(idxt+sz(1)*sz(2)*k)=3;
    ccc(idxc+sz(1)*sz(2)*k)=4;
    ccc(idxh+sz(1)*sz(2)*k)=5;
    
end

for k=[21 22 23 24 26 27 28]
    
    idxl=find(ccc(:,:,k)==4);
    idxs=find(ccc(:,:,k)==3);
    idxt=find(ccc(:,:,k)==2);
    idxc=find(ccc(:,:,k)==1);
    idxh=find(ccc(:,:,k)==5);
    idxu=find(ccc(:,:,k)==0);
    k=k-1;
    ccc(idxu+sz(1)*sz(2)*k)=4;
    ccc(idxl+sz(1)*sz(2)*k)=1;
    ccc(idxs+sz(1)*sz(2)*k)=2;
    ccc(idxt+sz(1)*sz(2)*k)=3;
    ccc(idxc+sz(1)*sz(2)*k)=4;
    ccc(idxh+sz(1)*sz(2)*k)=5;
    
end

for k=[25]            
    
    idxl=find(ccc(:,:,k)==3);
    idxs=find(ccc(:,:,k)==2);
    %idxt=find(ccc(:,:,k)==4);
    idxc=find(ccc(:,:,k)==1);
    idxh=find(ccc(:,:,k)==4);
    idxu=find(ccc(:,:,k)==0);
    k=k-1;
    ccc(idxu+sz(1)*sz(2)*k)=4;
    ccc(idxl+sz(1)*sz(2)*k)=1;
    ccc(idxs+sz(1)*sz(2)*k)=2;
    ccc(idxc+sz(1)*sz(2)*k)=4;
    ccc(idxh+sz(1)*sz(2)*k)=5;
    
    ccc(idxt(10:30)+sz(1)*sz(2)*k)=3;%随机给20个当作田类，因为监督分类时只选了4类
end

for k=[29 30 31  33]
    
    idxl=find(ccc(:,:,k)==3);
    idxs=find(ccc(:,:,k)==2);
    idxt=find(ccc(:,:,k)==5);
    idxc=find(ccc(:,:,k)==1);
    idxh=find(ccc(:,:,k)==4);
    idxu=find(ccc(:,:,k)==0);
    k=k-1;
    ccc(idxu+sz(1)*sz(2)*k)=4;
    ccc(idxl+sz(1)*sz(2)*k)=1;
    ccc(idxs+sz(1)*sz(2)*k)=2;
    ccc(idxt+sz(1)*sz(2)*k)=3;
    ccc(idxc+sz(1)*sz(2)*k)=4;
    ccc(idxh+sz(1)*sz(2)*k)=5;
    
end

for k=[32]
    
    idxs=find(ccc(:,:,k)==4);
    idxc=find(ccc(:,:,k)==2);
    idxh=find(ccc(:,:,k)==3);
    idxu=find(ccc(:,:,k)==0);
    k=k-1;
    ccc(idxu+sz(1)*sz(2)*k)=4;
    ccc(idxs+sz(1)*sz(2)*k)=2;
    ccc(idxt+sz(1)*sz(2)*k)=3;
    ccc(idxc+sz(1)*sz(2)*k)=4; 
    ccc(idxt(10:30)+sz(1)*sz(2)*k)=5;

end


for k=1:t
    imwrite(uint8(ccc(:,:,k)),[root, 'rearranged\', d(k).name]);
end
