function lpc_data=lpc_code(y1,~,~,lpcorder,q)
frame=200;
windowStep=100;
signal=y1;

cols = fix((length(signal)-windowStep)/windowStep);
preEmphasized = filter([1 -.97], 1, signal);
hamWindow = 0.54 - 0.46*cos(2*pi*(0:frame-1)/frame);

for start=0:cols-1
    first = start*windowStep + 1;
    last = first + frame-1;
    Data(1:frame) = preEmphasized(first:last).*hamWindow;
    %[a(:,start+1),g(start+1)]=lpc(Data,12);
    if q==1
        [a(:,start+1)]=lpc_filtercoef(Data,lpcorder);        
    elseif q==2
        [a(:,start+1)]=lfcc_func(Data);        
    elseif q==3
        [a(:,start+1)]=lpc_wdelta(Data,lpcorder);        
    else
        [a(:,start+1)]=lpc_delta(Data,lpcorder);        
    end
end
lpc_data=a;
end