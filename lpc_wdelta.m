function[A]=lpc_wdelta(input,lpcorder)
x=input;
order=lpcorder;
c=xcorr(x);
n2=length(c);
%one side of autocorrelation c                                                                      
mid=(n2+1)/2;
r=c(mid:n2);
a=zeros(order+1,order+1);
e=zeros(1,order);
g=zeros(1,order);
gamma=zeros(1,order+1);
for i=1:order+1
a(i,1)=1;
end
e(1)=r(1);
gamma(1)=1;
for j=1:order   
    p=j;
    for i=1:p
        term=a(p,i)*r(p+2-i);
        g(p)=g(p)+term;
    end
    gamma(p+1)=g(p)/e(p);
    e(p+1)=(1-(gamma(p+1))^2)*e(p);                                        
    if p>1
    for l=2:p
        a(p+1,l)=a(p,l)-(gamma(p+1)*a(p,p+2-l));
        a(p+1,p+1)=-gamma(p+1);
    end
    end
    a(p+1,p+1)=-gamma(p+1);
end

[r,c]=size(a);
a=reshape(a',1,[]);
ceps1=fft(a);
ceps2=abs(ceps1).^2;
ceps3=log10(ceps2);
ceps4=ifft(ceps3);
ceps=abs(ceps4).^2;
% n=length(ceps);
% for i=3:n
%     D(i-2)=ceps(i)-ceps(i-2);
% end
% D=[D 0 0];
 a=reshape(ceps',r,c)';
%D=delta(a);

 A=a(order+1,:);
 
end
