function [SignalAfterChannel, carier] = modulation(data, c_Fs, m, snr,fileID)

% data size
n = length(data);

% carrier signal frequency
fs = c_Fs;
fprintf(fileID,'--- Carrier Frequency       : %.2f \n',fs);

% sampling frequency
sampling_frequency = 500;
fprintf(fileID,'--- Sampling Frequency      : %.2f \n',sampling_frequency);


% length of a carrier signal in time domain(secounds)
signalLength = 2*pi / (fs/2);
fprintf(fileID,'--- Bit Rate                : %.2f \n',sampling_frequency/signalLength);


% psk modulation number
M = m;

% SNR in AWGN channel
SNR = snr;
fprintf(fileID,'--- SNR                     : %.2f \n',SNR);

% asinchronizedness in channel
asyinc = 1;

% trying to create a carrier signal.
% time domain. 
T = 0:1/sampling_frequency:signalLength;
carier = sin(fs*T);
carier2 = sin(fs*50*T);

%--------------differencial coding------------

diffCoded_data = differencial(data, 0);

% -------------modulation---------------------

% prepare coefficients for modulation
txSig = pskmod(diffCoded_data,M,pi);

% transmitter's output signal. which is in the ideal form
outputSignal = [];

for i = 1:n
    temp = carier * txSig(i);
    outputSignal = [outputSignal,temp];
end
outputSignal = real(outputSignal);

% ----------------------------------------------------------
outputSignal2 = [];

for i = 1:n
    temp = carier2 * txSig(i);
    outputSignal2 = [outputSignal2,temp];
end
outputSignal2 = real(outputSignal2);
% -------------------------------------------------


% --- bandpass_filter(L, c1, c2,ripple)
c1 = 55;
c2 = 55;

fprintf(fileID,'--- Filter low %.2f and high %.2f \n',c1,c2);
% ----------------Channel---------------------

% have signal pass through awgn channel
SignalAfterChannel = awgn(outputSignal, SNR);


real_out = real(fft(SignalAfterChannel));
imag_out = imag(fft(SignalAfterChannel));

filter = bandpass_filter(length(real_out),c1,c2,1,sampling_frequency);

real_after_filter = filter .* real_out; 
Freq_Sig = real_after_filter + 1j * imag_out;  
plot(real_after_filter)

outputSignal = real(ifft(Freq_Sig)); 




SignalAfterChannel = outputSignal;

end