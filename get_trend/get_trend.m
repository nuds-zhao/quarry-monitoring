function [m,d,li,ui] = get_trend(y)

% b is the slope, i.e., changes per step.
[N,M]=size(y); % [col, 1]

x=(1:N)'; % [col, 1]
%bls = regress(y,[ones(N,1) x]);
Comb = combnk(1:N,2);
a=y(Comb,:);
a1=a(1:561,:);
a2=a(562:end,:);
a3=a1-a2;
b=repmat(diff(x(Comb),1,2),1,M);
theil=a3./b;
m=median(theil);

d=median(y-x*m);
%d=median(y)-m*median(x);
[mu,sigma,muci,sigmaci]=normfit(theil,0.05);
li=muci(1);
ui=muci(2);
