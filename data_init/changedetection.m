root = 'D:\libwork\data\jingjinji\study area1\';
t84=imread([root,num2str(1984),'\class-p.tif']);
t90=imread([root,num2str(1990),'\class-p.tif']);
temp=t84;
temp(t90==2)=0;
t90(t84==1 & t90~=2)=6;
t90(t84==1 & t90==2)=0;

imwrite(t90,[root,'90-84.tif']);
