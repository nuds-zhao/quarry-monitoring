root = 'D:\libwork\data\jingjinji\study_area1\';
subroot = 'cut_toa\result_test\weighted_mean\refine\';
subr = 'cut_toa\refine\';
n = zeros(35,4);
beijing = imread([root, 'test\beijing.tif']);
tianjin = imread([root, 'test\tianjin.tif']);
demmask = imread([root,'demmask\dilatedmask.tif']);


for i = 1:34
    path=[root,subr,num2str(i+1983),'-class_proba.tif'];
    if (~exist(path,'file'))
        continue;
    end
    a = imread(path);
    z = a(:,:,2);
    bj_mask = (beijing(:,:,1) == 255) & (demmask==1);
    xbj = z .* double(bj_mask);
    tj_mask = (tianjin(:,:,1) == 255) & (demmask==1);
    xtj = z .* double(tj_mask);
    all = z.*double(demmask);
%     if (i==7)
%         luodi=2;
%     elseif(ismember(i,[17,18,19,20]))
%         luodi=5;
%     elseif(ismember(i,[21,22,23,24,26,27,28]))
%         luodi=4;
%     elseif(ismember(i,[25,30,31,32,34]))
%         luodi=3;
%     else
%         luodi=1;
%     end
    
%     n(i+1,1)=numel(find(xbj=luodi))*900;
%     n(i+1,2)=numel(find(xtj>luodi))*900;
%     n(i+1,3)=numel(find(z>luodi))*900;
%     n(i+1,4)=n(i+1,3)-n(i+1,2)-n(i+1,1);
    luodi=0.5;
    n(i+1,1)=sum(xbj(xbj>luodi))*900;
    n(i+1,2)=sum(xtj(xtj>luodi))*900;
    n(i+1,3)=sum(all(all>luodi))*900;
    n(i+1,4)=n(i+1,3)-n(i+1,2)-n(i+1,1);
    
end
csvwrite([root,subr,'htarea-with-demmask2.csv'],n);




