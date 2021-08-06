

%% 1) DEFINING ROOM PARAMETERS
recv_coord=zeros(1,3); 
src_coord=[0,3,1.8];
room_dim=[5,10,3];
rev_time=3;
M=128;
window=rectwin(M); %(hanning(M)).';
R=M; %length(h)-1; %75% overlap
%% 2) DEFINING SOUNDS 
duration=1;
frequency=1440;
phase=0;
Fs=16000;
[sinusoid,sin_axis]=generate_sinusoid(duration,frequency,phase,Fs);

%reading recordings
[Flute,sampF_flute]=audioread('flute.wav');
Flute=(Flute(:,1).');
[Guitar,sampF_guitar]=audioread('guitar.wav');
Guitar=(Guitar(:,1).');
[ah,sampF_ah]=audioread('unvoiced_sh.wav');
ah=ah.';
[sh,sampF_sh]=audioread('voiced_a.wav');
sh=sh.';
%resampling

res_flute=Resample(Fs,sampF_flute,Flute);
res_guitar=Resample(Fs,sampF_guitar,Guitar);
res_ah=Resample(Fs,sampF_ah,ah);
res_sh=Resample(Fs,sampF_sh,sh);
%% CODE
load("h.mat");
%[h,beta_hat]=rir_generator(340,Fs,recv_coord,src_coord,room_dim,rev_time); %CALCULATING IMPULSE RESPONSE
n=0:length(h)-1;



rev_sinusoid=conv(sinusoid,h);
%rev_sinusoid=OLAConv(window,sinusoid,h,R);
x_rev_sinusoid=[0:length(rev_sinusoid)-1];

rev_ah=conv(res_ah,h);
%rev_ah=OLAConv(window,res_ah,h,R);
x_rev_ah=0:length(rev_ah)-1;

rev_sh=conv(res_sh,h);
%rev_sh=OLAConv(window,res_sh,h,R);
x_rev_sh= 0:length(rev_sh)-1;


figure(1)
subplot(7,1,1)
title("Room impulse response")
xlabel("n samples")
plot(n,h)

subplot(7,1,2)
title("Sine")
xlabel("n samples")
plot(sin_axis,sinusoid)

subplot(7,1,3)
title("Reverberated Sine")
xlabel("n samples")
plot(x_rev_sinusoid,rev_sinusoid)

subplot(7,1,4)
title("Ah")
xlabel("n samples")
plot(0:length(res_ah)-1,res_ah)

subplot(7,1,5)
title("Reverberated Ah")
xlabel("n samples")
plot(x_rev_ah,rev_ah)

subplot(7,1,6)
title("Sh")
xlabel("n samples")
plot(0:length(res_sh)-1,res_sh)

subplot(7,1,7)
title("Reverberated Sh")
xlabel("n samples")
plot(x_rev_sh,rev_sh)


audiowrite("sh.wav",rev_sh,Fs);





%% TESTING
sound(sinusoid,Fs);
pause(4);
sound(rev_sinusoid,Fs);
pause(4);
sound(res_ah,Fs);
pause(4);
sound(rev_ah,Fs);
pause(4);
sound(res_sh,Fs);
pause(4);
sound(rev_sh,Fs);



%% FUNCTIONS
function [sine,axis]=generate_sinusoid(duration,frequency,phase,Fs)
       axis=[0:1/Fs:duration];
       omega=2*pi*frequency;
       sine=sin(omega*axis +phase);
end


function final_conv_signal=OLAConv(window,sig1,sig2,R)
    M=R; %length(window);
    frames = floor((length(sig1)-M)/R ) + 1; 
    final_conv_signal=zeros(1,length(sig1)+length(sig2)-1);
    
    for m=0:frames-1
        win_sig1=sig1(m*R+1:m*R+M).*window;
        zp_dim=length(win_sig1)+length(sig2)-1;
        win_conv_sig=zeros(1,zp_dim);
        FD_sig1=fft(sig1,zp_dim);
        %FD_sig1=FD_sig1*exp(1i*2*pi*m*R);%Traslation into the origin
        FD_sig2=fft(sig2,zp_dim);
        FD_win_conv_sig=FD_sig1.*FD_sig2; %Frequency domain convolution
        %FD_win_conv_sig=FD_win_conv_sig*exp(-1i*2*pi*m*R);%Translation back in the original place
        win_conv_sig=real(ifft(FD_win_conv_sig));
        indices=m*R+1:(m*R)+zp_dim;
        final_conv_signal(indices)=final_conv_signal(indices)+win_conv_sig;
        
    end
end


function zeropadded_signal=zeropad(signal,dim)
         %assert(size(dim)>size(signal))
        zeropadded_signal=zeros(1,dim);
        zeropadded_signal(1:length(signal)+1)=signal;
end


function res_signal=Resample(target_Fs, Fs, signal)
        [P,Q]=rat(target_Fs/Fs);
        res_signal=resample(signal,P,Q);
end


