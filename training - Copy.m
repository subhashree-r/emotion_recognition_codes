function training(num,trial,t,frame,lpcorder)

format long
fs=8000;
dlmwrite('num.txt',num);

for j=1:num
    
    fprintf('\nword %d ,you want to add as a file or record it', j )
    sel2=input('\nPress 0: file\nPress 1: Record:');
        
    for i=1:trial
        if(sel2 == 0)
            fprintf('\nenter the file name for word %d, trial %d : ', j,i )
            fname=input('','s');
            y1=dlmread(fname);
        elseif(sel2==1)
            fprintf('speak %d word,%d trail',j,i)
            y = wavrecord(t,fs);
            y1= preprocessing(y,t,frame);
            fileName0 = sprintf('voice%d%d.txt',j,i);
            dlmwrite(fileName0,y1);
            sel3=input('If you want to repeat last word\nPress 0.\n else  \nPress 1 :');
            
            if(sel3 ==0)
                fprintf('speek %d word,%d trail again',j,i)
                y = wavrecord(t,fs);
                y1= preprocessing(y,t,frame);
                
                fileName0 = sprintf('voice%d%d.txt',j,i);
                dlmwrite(fileName0,y1);
            end
                        
        else
            disp('invalid input');
        end
        close
        %         figure
        %         plot(y1)
        
        ceps = mfcc(y1, fs);
        fileName = sprintf('mfcc%d%d.txt',j,i);
        dlmwrite(fileName,ceps);
        
        lpc_data=lpc_code(y1,t,frame,lpcorder,1);
        fileName1 = sprintf('lpc%d%d.txt',j,i);
        dlmwrite(fileName1,lpc_data);
        
        lfcc_cof=lpc_code(y1,t,frame,lpcorder,2);
        fileName1 = sprintf('lfcc%d%d.txt',j,i);
        dlmwrite(fileName1,lfcc_cof);
        
        lpcwd=lpc_code(y1,t,frame,lpcorder,3);
        fileName1 = sprintf('lpcwd%d%d.txt',j,i);
        dlmwrite(fileName1,lpcwd);
        
        lpcd=lpc_code(y1,t,frame,lpcorder,4);
        fileName1 = sprintf('lpcd%d%d.txt',j,i);
        dlmwrite(fileName1,lpcd);
        
    end
    
    fprintf('word %d completed',j)
    
end
end


