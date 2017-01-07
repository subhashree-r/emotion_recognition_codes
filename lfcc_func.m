function[A]=lfcc_func(x)
[r,c]=size(x);
% pELowfreq = filter([1 1],[1 -1]/16000, x);
for i=1:r
    C(i,:) = real(fft(log2(abs(fft(x(i,:))))));
end
[r,c]=size(C);
A=C(1:13);
end




