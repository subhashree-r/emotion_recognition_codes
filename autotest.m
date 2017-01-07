function [count,a,m,l1,l2,l3,l4]=autotest(count,t,frame,num,lpcorder,filename,a,m,l1,l2,l3,l4,j)

global eff1 eff2 eff3 eff4 eff5 efft

% n=input('enter number of trials : ');

snr=input('enter snr (in dB) for auto-testing (enter ''inf'' for no snr) : ');
% for j=1:7
j=1;

for s=1:45
    
%     s=randi(7);
%     switch s
%         case 1
%             j=randi(45);
%         case 2
%             j=randi(45);
%         case 3
%             j=randi(45);
%         case 4
%             j=randi(45);
%         case 5
%             j=randi(45);
%         case 6
%             j=randi(45);
%         case 7
%             j=randi(45);
%     end
%     switch j
%         case 1
    fname=sprintf('NEW_WAV\\%d\\(%d).wav',j,s);
    y= audioread(fname);
    l=length(y);
    y=[y; zeros(t-l,1)];
    Y=awgn(y,snr);
    y1= preprocessing(Y,t,frame);
    count=count+1;
    [A, M, L1, L2, L3, L4]=testing(y1,num,t,frame,lpcorder,count,filename,j);
    
    a=a+A;
    m=m+M;
    l1=L1+l1;
    l2=L2+l2;
    l3=L3+l3;
    l4=L4+l4;
    
    eff1=[eff1,m/count];
    eff2=[eff2,l1/count];
    eff3=[eff3,l2/count];
    eff4=[eff4,l3/count];
    eff5=[eff5,l4/count];
    efft=[efft,a/count];
    
end
switch j
    case 1
        a1=a
        m1=m
        lpc1=l1
        lfcc1=l2
        osalpc1=l3
        lpcd1=l4
    case 2 
        a2=a
        m2=m
        lpc2=l1
        lfcc2=l2
        osalpc2=l3
        lpcd1=l4
    case 3
        a3=a
        m3=m
        lpc3=l1
        lfcc3=l2
        osalpc3=l3
        lpcd3=l4
    case 4
        a4=a
        m4=m
        lpc4=l1
        lfcc4=l2
        osalpc4=l3
        lpcd4=l4
    case 5
        a5=a
        m5=m
        lpc5=l1
        lfcc5=l2
        osalpc5=l3
        lpcd5=l4
    case 6
        a6=a
        m6=m
        lpc6=l1
        lfcc6=l2
        osalpc6=l3
        lpcd6=l4
    case 7
        a7=a
        m7=m
        lpc7=l1
        lfcc7=l2
        osalpc7=l3
        lpcd7=l4

end
end



