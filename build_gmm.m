function  build_gmm(num,trial)
N=5;
% num=6;
% trial=10;

for i=1:num
    temp2=[];
    for j=1:trial
        fileName = sprintf('mfcc%d%d.txt',i,j);
        temp= dlmread(fileName);
        temp2=[temp2 temp];
    end
    s=size(temp2);
    
    OPTIONS = statset('MaxIter',5000,'Display','final','TolFun',1e-6);
    gmdis_mfcc=gmdistribution.fit(transpose(temp2),N,'Options',OPTIONS,'CovType','diagonal' ,'SharedCov',true,'Regularize',.5);
    fileName = sprintf('gmdis_mfcc%d.mat',i);
    save(fileName,'gmdis_mfcc');
%     a='1 done'
end

for i=1:num
    temp2=[];
    for j=1:trial
        fileName = sprintf('lpc%d%d.txt',i,j);
        temp= dlmread(fileName);
        temp2=[temp2 temp];
    end
    s=size(temp2);
    
    OPTIONS = statset('MaxIter',5000,'Display','final','TolFun',1e-6);
    gmdis_lpc=gmdistribution.fit(transpose(temp2(2:s(1),:)),N,'Options',OPTIONS,'CovType','diagonal' );
    
    fileName = sprintf('gmdis_lpc%d.mat',i);
    save(fileName,'gmdis_lpc');
%     a='2 done'
end

for i=1:num
    temp2=[];
    for j=1:trial
        fileName = sprintf('lfcc%d%d.txt',i,j);
        temp= dlmread(fileName);
        temp2=[temp2 temp];
    end
    s=size(temp2);
    
    OPTIONS = statset('MaxIter',5000,'Display','final','TolFun',1e-6);
    gmdis_lfcc=gmdistribution.fit(transpose(temp2(2:s(1),:)),N,'Options',OPTIONS,'CovType','diagonal' );
    
    fileName = sprintf('gmdis_lfcc%d.mat',i);
    save(fileName,'gmdis_lfcc');
%     a='3 done'
end

for i=1:num
    temp2=[];
    for j=1:trial
        fileName = sprintf('lpcwd%d%d.txt',i,j);
        temp= dlmread(fileName);
        temp2=[temp2 temp];
    end
    s=size(temp2);
    
    OPTIONS = statset('MaxIter',5000,'Display','final','TolFun',1e-6);
    gmdis_lpcwd=gmdistribution.fit(transpose(temp2(2:s(1),:)),N,'Options',OPTIONS,'CovType','diagonal' );
    
    fileName = sprintf('gmdis_lpcwd%d.mat',i);
    save(fileName,'gmdis_lpcwd');
%     a='4 done'
end

for i=1:num
    temp2=[];
    for j=1:trial
        fileName = sprintf('lpcd%d%d.txt',i,j);
        temp= dlmread(fileName);
        temp2=[temp2 temp];
    end
    s=size(temp2);
    
    OPTIONS = statset('MaxIter',5000,'Display','final','TolFun',1e-6);
    gmdis_lpcd=gmdistribution.fit(transpose(temp2(2:s(1),:)),N,'Options',OPTIONS,'CovType','diagonal' );
    
    fileName = sprintf('gmdis_lpcd%d.mat',i);
    save(fileName,'gmdis_lpcd');
%     a='5 done'
end

end

