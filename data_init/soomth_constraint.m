function soomth_constraint()
root='D:\libwork\data\jingjinji\study_area1\cut_toa\result\'; 
pro_ta=csvread([root,'proba_ta.csv']);
pro_nt=csvread([root,'proba_nt.csv']);
p_ta=med_soomth(pro_ta);
p_nt=med_soomth(pro_nt);
plot(pro_nt(151,:));

hold on;
plot(p_nt(151,:));


p=p_ta+p_nt;
in=find(p~=1);
ps=p(in);
p_ta=p_ta./p;
p_nt=p_nt./p;




function pro_out=med_soomth(pro)
pro_out=zeros(size(pro));
ed=size(pro,2);
pro_out(:,1)=pro(:,1);
pro_out(:,ed)=pro(:,ed);
pro_out(:,ed-1)=median(pro(:,ed-2:ed),2);
pro_out(:,2)=median(pro(:,1:3),2);
for i =3:ed-2
    pro_out(:,i)=median(pro(:,i-1:i+1),2);
end



