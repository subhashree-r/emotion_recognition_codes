function ceps = mfcc(signal,~)

% preprocessing
% plot(signal);

alpha=.97;
preEmp = filter([1 -alpha], 1, signal);
pE=(preEmp-mean(preEmp))/max(preEmp-mean(preEmp));
% figure; plot(pE);

% pE=signal;

fs=16000;
total=length(pE); % t=6*fs
frame=200;

overlap=100;
skip=frame-overlap;
blks=floor((total-frame)/skip+1);
ll=1-skip;
blocks=zeros(blks,frame);
for i=1:blks
    ll=ll+skip;
    ul=ll-1+frame;
    blocks(i,:)=pE(ll:ul);
end

y=zeros(blks,frame);
nfft=2^nextpow2(frame);
SIG=zeros(blks,nfft);
P=zeros(blks,nfft);

cut=frame;
no_filters=26;
filterbank=zeros(no_filters,cut);

snip=13;
N=2;

lfreq=133;
ufreq=8000;
lfreq_mel=1125*log(1+lfreq/700);
ufreq_mel=1125*log(1+ufreq/700);
freqs_mel=linspace(lfreq_mel,ufreq_mel,no_filters+2);
freqs=700*(exp(freqs_mel/1125)-1);
f=floor((nfft+1)*freqs/fs);
x=linspace(0,cut-1,cut);

for i=1:no_filters
    filterbank(i,:)=( x-f(i))/(f(i+1)-f(i)).*(x>=f(i)&x<f(i+1))+(f(i+2)- x)/(f(i+2)-f(i+1)).*(x>=f(i+1)&x<f(i+2));
end

fb_energy=zeros(blks,no_filters);
logfb_energy=zeros(blks,no_filters);
dcts=zeros(blks,no_filters);

ham=.54-.46*cos(2*pi*(0:frame-1)/(frame-1));

for i=1:blks
    
    y(i,:)=ham.*blocks(i,:);
    SIG(i,:)=fft(y(i,:),nfft);
    P(i,:)=abs(SIG(i,:)).^2 / nfft;
    
    for j=1:no_filters;
        %         figure
        %         subplot(131); plot(0:cut-1,P(i,1:cut));
        %         subplot(132); plot(0:cut-1,filterbank(j,:));
        E=filterbank(j,:).*P(i,1:cut);
        fb_energy(i,j)=sum(E);
        %         subplot(133); plot(0:cut-1,E);
    end
    
    logfb_energy(i,:)=log10(fb_energy(i,:));
    dcts(i,:)=dct(logfb_energy(i,:));
    
end

cof=dcts(:,1:snip);
static_cof=[zeros(N,snip);cof;zeros(N,snip)];

deltas=zeros(blks,snip);

de=0;
for n=1:N
    de=de+n^2;
end
for t=1:blks
    nu=0;
    for n=1:N
        nu=nu+n*(static_cof(t+n+N,:)-static_cof(t-n+N,:));
    end
    deltas(t,:)=nu/2/de;
end

ceps=[cof deltas];

delta=[zeros(N,snip);deltas;zeros(N,snip)];

accl=zeros(blks,snip);

for t=1:blks
    nu=0;
    for n=1:N
        nu=nu+n*(delta(t+n+N,:)-delta(t-n+N,:));
    end
    accl(t,:)=nu/2/de;
end

ceps=[ceps  accl];

end

