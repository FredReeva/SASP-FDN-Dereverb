%% FUNCTIONS
function [sine,axis]=generate_sinusoid(duration,frequency,phase,Fs)
       axis=[0:1/Fs:duration];
       omega=2*pi*frequency;
       sine=sin(omega*axis +phase);
end


function final_conv_signal=OLAConv(window,sig1,sig2,R)
    M=length(window);
    frames = floor((length(sig1)-M)/R ) + 1; 
    final_conv_signal=zeros(1,length(sig1)+length(sig2)-1);
   
    for m=0:frames-1
        win_sig1=sig1(m*R+1:m*R+M).*window;
        
        zp_dim=length(win_sig1)+length(sig2)-1;
        FD_sig1=fft(sig1,zp_dim);
        %FD_sig1=FD_sig1*exp(1i*2*pi*m*R);%Traslation into the origin
        FD_sig2=fft(sig2,zp_dim);
        FD_win_conv_sig=FD_sig1.*FD_sig2; %Frequency domain convolution
        %FD_win_conv_sig=FD_win_conv_sig*exp(-1i*2*pi*m*R);%Translation back in the original place
        win_conv_sig=ifft(FD_win_conv_sig);
        indices=m*R+1:(m*R)+zp_dim;
        final_conv_signal(indices)=win_conv_sig;
        
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
