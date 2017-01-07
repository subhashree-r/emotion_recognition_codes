function[A]=lpc_filtercoef(input,lpcorder)
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

A=a(order+1,:);
end
