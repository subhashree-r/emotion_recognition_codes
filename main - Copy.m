clc; clear all;close all;

global eff1 eff2 eff3 eff4 eff5 efft errtot

fs=16000;
t=6*fs;
frame=200;
a=0; m=0; l1=0; l2=0; l3=0; l4=0;
% num=dlmread('num.txt');
num=3;
loop=1;
lpcorder=12;

count=0;
filename = 'testdata.xlsx';

while(loop)
    sel1 = input('training or testing ?\n press\n 0 : training\n 1 : testing\n 2 : exit \n :  ');
    if(sel1 ==0)
        disp('training')
        s2 = input('\nPress 0 to load inbuilt database (7 emotions, 45 trials)\nPress anything else to enter database manually\n');
        
        if s2==0
            num = 7;
            trial = 20;
            for i=1:num
                foldername=sprintf('GMM_ORIGINAL_FINAL');
                
          
                fileName = sprintf('gmdis_mfcc%d.mat',i);
                f=sprintf('%s\\gmdis_mfcc%d.mat',foldername,i);
                status=copyfile(f,fileName);
                fileName1 = sprintf('gmdis_lpc%d.mat',i);
                f1=sprintf('%s\\gmdis_lpc%d.mat',foldername,i);
                status=copyfile(f1,fileName1);
                fileName2 = sprintf('gmdis_lfcc%d.mat',i);
                f2=sprintf('%s\\gmdis_lfcc%d.mat',foldername,i);
                status=copyfile(f2,fileName2);
                fileName3 = sprintf('gmdis_lpcwd%d.mat',i);
                f3=sprintf('%s\\gmdis_lpcwd%d.mat',foldername,i);
                status=copyfile(f3,fileName3);
                fileName4 = sprintf('gmdis_lpcd%d.mat',i);
                f4=sprintf('%s\\gmdis_lpcd%d.mat',foldername,i);
                status=copyfile(f4,fileName4);
            end
        else
            num = input('number of emotions: ');
            trial = input('number trials for each emotion: ');
            training(num,trial,t,frame,lpcorder);
            build_gmm(num,trial);
        end
        disp('training completed succesfully');
    elseif(sel1==1)
        disp('testing')
        auto=input('\nPress 1 to automate testing\nPress anything else to manually test\n');
        if auto==1
            
            [count,a,m,l1,l2,l3,l4]=autotest(count,t,frame,num,lpcorder,filename,a,m,l1,l2,l3,l4);
                      
        else
            y= wavrecord(t,fs);
            y1= preprocessing(y,t,frame);
            k=input('what is your emotion : ');
            count=count+1;
            [A, M, L1, L2, L3, L4]=testing(y1,num,t,frame,lpcorder,count,filename,k);
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
        beep;        
        
    elseif(sel1==2)
        eff=a/count*100
        eff_mfcc=m/count*100
        eff_lpc=l1/count*100
        eff_lfcc=l2/count*100
        eff_lpcwd=l3/count*100
        eff_lpcd=l4/count*100
        loop=0;
        B=[eff eff_mfcc eff_lpc eff_lfcc eff_lpcwd eff_lpcd];
        
        figure
        bar(B);
        set(gca,'XTickLabel',{'overall','Mfcc','Lpc','Lfcc','lpcCeps','OSALPC'})
        ylabel('efficiency');
        
%         figure
%         subplot(321); plot(1:count,efft*100); xlabel('trials'); ylabel('total eff');
%         subplot(322); plot(1:count,eff1*100); xlabel('trials'); ylabel('mfcc eff');
%         subplot(323); plot(1:count,eff2*100); xlabel('trials'); ylabel('lpc eff');
%         subplot(324); plot(1:count,eff3*100); xlabel('trials'); ylabel('lfcc eff');
%         subplot(325); plot(1:count,eff4*100); xlabel('trials'); ylabel('lpcCeps eff');
%         subplot(326); plot(1:count,eff5*100); xlabel('trials'); ylabel('osalpc eff');
        
    else
        disp('invalid option')
    end
end





