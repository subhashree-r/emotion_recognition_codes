function signal = preprocessing(y,total,frame)

% for i=1:(total*2/frame)-1
%     si=(i-1)*frame/2+1;
%     ei=si+frame-1;
%     blocks(i,:)= y(si:ei);
% end

overlap=100;
skip=frame-overlap;
blks=floor((total-frame)/skip+1);
ll=-skip+1;
for i=1:blks
    ll=ll+skip;
    ul=ll-1+frame;
    blocks(i,:)=y(ll:ul);
end

sumthresh= 0.05;
zerocrossthresh = 0.060;

dim1=size(blocks);
n = dim1(1);
len = dim1(2);
min = n+1;
max = 0;
sumthreshtotal = len * sumthresh;
zerocrossthreshtotal = len * zerocrossthresh;
for i = 5:n
    currsum(i) = sum(abs(blocks(i,1:len)));
    currzerocross(i) = zerocross(blocks(i,1:len));
    if and((currsum(i) > sumthreshtotal),(currzerocross(i) > zerocrossthreshtotal))
        if i < min
            min = i;
        end
        if i > max;
            max = i;
        end
    end
end

if max > min
    f1 = blocks(min:max,1:len);
    e=sum(abs(f1).^2);
    e=sum(e);
    f=f1/(sqrt(e)); %energy normaliszation
    
    lenf1= size(f);
    lenf=lenf1(1);
    
    for j=1:lenf
        signal((j-1)*frame+1:j*frame)= f(j,:);
    end
else
    f1 = zeros(0,0);
    signal=f1;
end

if(length(signal)==0)
    disp('speak last word again')
    y = wavrecord(total,8000);
    y= preprocessing(y,total,frame);
end

end

