function [P1onsided,fonesided,P2shifted,fshifted]= get_fft_for_even(X,fs)
L = size(X,2);
Y = fft(X);
P2 = abs(Y/L);
P1onsided = P2(1:L/2+1);
P1onsided(2:end-1) = 2*P1onsided(2:end-1);
fonesided = fs*(0:(L/2))/L;
P2shifted = [P2(L/2+2:end) P2(1:L/2+1)];
fshifted = fs/L*(-L/2+1:L/2);
end