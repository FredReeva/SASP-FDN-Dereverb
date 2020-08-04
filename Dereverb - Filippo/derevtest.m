[signal,Fs]=audioread("sh.wav");
load("h.mat");
sound(signal,Fs);
n=0:length(h)-1;
k=n;
%room frequency response
H=fft(h);
%calculate cepstrum
H_log=log(abs(H))+1i*angle(H);

%even part of the complex cepstrum
h_even=(1/length(n)).*(real(H_log).*exp(1i*(2*pi/length(n))*k*(n')));

%cepstrum related to the minimum phase  sequence
h_mp=zeros(1,length(n));
h_mp(1)=h_even(1);
h_mp(length(n)/2)=h_even(length(n)/2);
h_mp(2:(length(n)/2)-1)=2*h_even(2:(length(n)/2)-1);

%DFT of h_mp
H_mp=h_mp.*exp(-1i*(2*pi/length(n))*k*n');

%minimum phase part in linear domain
H_mp_ld=exp(H_mp);
inverse_H_mp_ld=1./H_mp_ld;
%calculating the remaining all-pass sequence
H_ap=H.*inverse_H_mp_ld;


h_dereverb_mp=ifft(H_mp_ld);
h_dereverb_ap=ifft(H_ap);

derev_signal=conv(signal,h_dereverb_mp);
derev_signal=conv(derev_signal,h_dereverb_ap);

sound(real(derev_signal),Fs);
