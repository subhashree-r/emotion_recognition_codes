
function [A, M, L1, L2, L3, L4]=testing(signal,num,t,frame,lpcorder,c,filename,k)

% global errtot

% disp(['test case ',num2str(c)]);

ceps = mfcc(signal, 8000);
lpc_data=lpc_code(signal,t,frame,lpcorder,1);
lfcc_cof=lpc_code(signal,t,frame,lpcorder,2);
lpcwd=lpc_code(signal,t,frame,lpcorder,3);
lpcd=lpc_code(signal,t,frame,lpcorder,4);

for i=1:7
    fileName = sprintf('gmdis_mfcc%d.mat',i);
    load(fileName);
    fileName1 = sprintf('gmdis_lpc%d.mat',i);
    load(fileName1);
    fileName2 = sprintf('gmdis_lfcc%d.mat',i);
    load(fileName2);
    fileName3 = sprintf('gmdis_lpcwd%d.mat',i);
    load(fileName3);
    fileName4 = sprintf('gmdis_lpcd%d.mat',i);
    load(fileName4);   
    
    [prob, log_like_mfcc] = posterior(gmdis_mfcc,ceps(:,1:13));
    result_mfcc(i)= log_like_mfcc;
    [~, log_like_lpc] = posterior(gmdis_lpc,transpose(lpc_data(2:lpcorder+1,:)));
    result_lpc(i)= log_like_lpc;
    [~, log_like_lfcc] = posterior(gmdis_lfcc,transpose(lfcc_cof(2:lpcorder+1,:)));
    result_lfcc(i)= log_like_lfcc;
    [~, log_like_lpcwd] = posterior(gmdis_lpcwd,transpose(lpcwd(2:lpcorder+1,:)));
    result_lpcwd(i)= log_like_lpcwd;
    [~, log_like_lpcd] = posterior(gmdis_lpcd,transpose(lpcd(2:lpcorder+1,:)));
    result_lpcd(i)= log_like_lpcd;
end

minimum_mfcc= min(result_mfcc);
minimum_lpc=min(result_lpc);
minimum_lfcc=min(result_lfcc);
minimum_lpcwd=min(result_lpcwd);
minimum_lpcd=min(result_lpcd);
M=[minimum_mfcc minimum_lpc minimum_lfcc minimum_lpcwd minimum_lpcd]
desired=min(M);
E1=0;E2=0;E3=0;E4=0;E5=0;
for i=1:7
E1= E1+((result_mfcc(i)-desired).^2);
E2= E2+((result_lpc(i)-desired).^2);
E3= E3+((result_lfcc(i)-desired).^2);
E4= E4+((result_lpcwd(i)-desired).^2);
E5= E5+((result_lpcd(i)-desired).^2);
end
MSE1=sqrt((E1)/7);
MSE2=sqrt((E2)/7);
MSE3=sqrt((E3)/7);
MSE4=sqrt((E4)/7);
MSE5=sqrt((E5)/7);
MSE=[MSE1 MSE2 MSE3 MSE4 MSE5]

for i=1:7
     err_mfcc(i)= (result_mfcc(i) - minimum_mfcc)./ max(result_mfcc); 
    err_lpc(i)= (result_lpc(i) - minimum_lpc)./ max(result_lpc);
    err_lfcc(i)= (result_lfcc(i) - minimum_lfcc)./ max(result_lfcc);
    err_lpcwd(i)= (result_lpcwd(i) - minimum_lpcwd)./ max(result_lpcwd);
    err_lpcd(i)= (result_lpcd(i) - minimum_lpcd)./ max(result_lpcd);
end
% for i=1:7
%      err_mfcc(i)= (result_mfcc(i) - minimum_mfcc); 
%     err_lpc(i)= (result_lpc(i) - minimum_lpc);
%     err_lfcc(i)= (result_lfcc(i) - minimum_lfcc);
%     err_lpcwd(i)= (result_lpcwd(i) - minimum_lpcwd);
%     err_lpcd(i)= (result_lpcd(i) - minimum_lpcd);
% end
% index of min element in result
errormfcc=sum((err_mfcc));
errorlpc=sum((err_lpc));
errorlfcc=sum((err_lfcc));
errorlpcwd=sum((err_lpcwd));
errorlpcd=sum((err_lpcd));
E=[errormfcc errorlpc errorlfcc errorlpcwd errorlpcd]
for i=1:7
    if(result_mfcc(i)==minimum_mfcc)
        mfcc_out=i;
    end
    if(result_lpc(i)==minimum_lpc)
        lpc_out=i;
    end
    if(result_lfcc(i)==minimum_lfcc)
        lfcc_out=i;
    end
    if(result_lpcwd(i)==minimum_lpcwd)
        lpcwd_out=i;
    end
    if(result_lpcd(i)==minimum_lpcd)
        lpcd_out=i;
    end
end
check_threshold=10000;

if(mfcc_out > check_threshold   &  lpc_out > check_threshold & lfcc_out > check_threshold &lpcwd_out > check_threshold &lpcd_out > check_threshold )
    disp('word not found');
    % else
    %     if(mfcc_out == lpc_out)
    %         fprintf('\ndetected word is : %d  : \n', mfcc_out )
    %         out=mfcc_out;
    %     else
    %         if (err_mfcc(lpc_out) < err_lpc(mfcc_out))
    %             fprintf('\ndetected word is : %d  : \n', lpc_out )
    %             out=lpc_out;
    %         else
    %             fprintf('\ndetected word is : %d  : \n', mfcc_out )
    %             out=mfcc_out;
    %         end
    %     end
    % end
else
    e11=err_mfcc(mfcc_out);
    e12=err_mfcc(lpc_out);
    e13=err_mfcc(lfcc_out);
    e14=err_mfcc(lpcwd_out);
    e15=err_mfcc(lpcd_out);
    
    e21=err_lpc(mfcc_out);
    e22=err_lpc(lpc_out);
    e23=err_lpc(lfcc_out);
    e24=err_lpc(lpcwd_out);
    e25=err_lpc(lpcd_out);
    
    e31=err_lfcc(mfcc_out);
    e32=err_lfcc(lpc_out);
    e33=err_lfcc(lfcc_out);
    e34=err_lfcc(lpcwd_out);
    e35=err_lfcc(lpcd_out);
    
    e41=err_lpcwd(mfcc_out);
    e42= err_lpcwd(lpc_out);
    e43=err_lpcwd(lfcc_out);
    e44=err_lpcwd(lpcwd_out);
    e45= err_lpcwd(lpcd_out);
    
    e51= err_lpcd(mfcc_out);
    e52= err_lpcd(lpc_out);
    e53= err_lpcd(lfcc_out);
    e54= err_lpcd(lpcwd_out);
    e55= err_lpcd(lpcd_out);
end

% h1=table(err_mfcc,err_lpc,err_lfcc,err_lpcCeps,err_osalpc);
% cols=table(mfcc,lpc,lfcc,lpcCeps,osalpc);

errors=[e11 e12 e13 e14 e15;e21 e22 e23 e24 e25;e31 e32 e33 e34 e35;e41 e42 e43 e44 e45;e51 e52 e53 e54 e55];
R=sum(abs(errors'));
k
S=E;
combo=[mfcc_out, lpc_out,lfcc_out,lpcwd_out,lpcd_out]
 sum( combo==mode(combo) );
if  sum( combo==mode(combo) )>=3
    decision=mode(combo);
elseif sum( combo==mode(combo) )==2
    c=find(combo==mode(combo));
    [m,n]=size(find(combo==mode(combo)));
    if n==2
% % % %         en=[E(c(1,1)) E(c(1,2))];
% % % %         ;algo=find(min(en)==en);
% % % %         decision=combo(algo)
if C(1,1)|C(1,2)==3
    decision=combo(3);
else
%     en=[E(c(1,1)) E(c(1,2))];
    en=[E(c(1,1)) E(c(1,2))];
    algo=find(min(en)==en);
    
end
% 
% algo=find(min(MSE)==MSE);
%      decision=combo(algo)
else
decision=combo(3);
%     elseif n==1
%         decision=combo(c(1,1));
%     end

%         
% else
%     decision=combo(3);
% %     S=sum(abs(errors'))
% %     algo=find(min(S)==S);
% %     decision=combo(algo);
% end

% errtot=[errtot; sum(abs(errors))];

% xlswrite(filename,h1,c ,'B1:F1');
% xlswrite(filename,cols,c,'A2:A6');
% xlswrite(filename,errors,c,'B2:F6');
    end
if mfcc_out==k
    M=1;
else
    M=0;
end
if lpc_out==k
    L1=1;
else
    L1=0;
end
if lfcc_out==k
    L2=1;
else
    L2=0;
end
if lpcwd_out==k
    L3=1;
else
    L3=0;
end
if lpcd_out==k
    L4=1;
else
    L4=0;
end

% decision=mode(combo);
% decision=floor(.09*mfcc_out+.17*lpc_out+.32*lfcc_out+.24*lpcwd_out+.18*lpcd_out);

if decision==k
    A=1;
else
    A=0;
end
% xlswrite(filename,decision,c,'A8');

%  if decision==1
%     disp('happy');
%  elseif decision==2
%      disp('sad');
%  elseif decision==3
%      disp('angry');
%  elseif decision==4
%      disp('disgust');
% elseif decision==5
%     disp('fear');
% elseif decision==6
%      disp('bore');
%  else
%      disp('neutral');
%  end

end







