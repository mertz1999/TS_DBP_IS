fclose('all');
fileID = fopen('./logs/log2.txt','w');
fprintf(fileID,' ---------------  Digital-com Simulation  ---------------------\n ---------------          Mertz           ---------------------\n ---------------          2020            ---------------------\n\n\n');
% ---------------  Digital-com Simulation  ---------------------
% ---------------          Mertz           ---------------------
% ---------------          2020            ---------------------

% --- define number of bits that we quntize the Audio Signal(1 channel)
bits = 4;
fprintf(fileID,'--- number of bit quantize  : %.2f \n',bits);
% --- encode Audio Signal par: ('file name'  'time'  'bits')
tic
[qu_signal_bi,Fs] = sound_encode('./input_music/salar1.wav', 3, bits);
time1 = toc;


% --- make an stream data with one row
data = [];
for i=1:length(qu_signal_bi)
    temp = 0;
    temp = qu_signal_bi(i,1:bits);
    data = [data,temp];
end
clear i;
% data = [0 0 1 0];


% --- hamming Coding
hamdata = [];
for i=1:8:length(data)
    if (i+7 <= length(data))
        temp = hamming(data(i:i+7),0);
        hamdata = [hamdata temp];
        temp = [];
    end
end
% % --- insert a zero at the begining of data becuase of Diffrential decoding
hamdata = [0,hamdata];
fprintf(fileID,'--- number of bit data      : %.2f \n',length(data));
fprintf(fileID,'--- number of bit data ham  : %.2f \n',length(hamdata));

% --- it`s time to make modulated Signal par: ['binary data' 'carrier Freq' 'SNR']
tic
[SignalAfterChannel, carier] = modulation(hamdata, 50, 2, -4,fileID);
time2 = toc;


% --- now we demudulated Signal par: ['Signal' 'carrier for time of carrier']
tic
[Demod_data] = demodulation(SignalAfterChannel, carier);
time3 = toc;


% --- hamming decoding
hamdata_dec = Demod_data;
hamdata_dec = [];
for i=1:12:length(Demod_data)
    if (i+11 <= length(Demod_data))
        temp = hamming(Demod_data(i:i+11),1);
        hamdata_dec = [hamdata_dec temp];
        temp = [];
    end
end
fprintf(fileID,'--- number of error         : %.2f \n',symerr(data,hamdata_dec));
fprintf(fileID,'--- number of error rate    : %.10f \n',symerr(data,hamdata_dec)/length(data));
% symerr(data,hamdata_dec)
% --- after Demod signal we must set data in bits`s number of columns
output_data = zeros(16384,bits);
for i=1:bits:(length(hamdata_dec)-bits)
    temp = 0;
    temp = hamdata_dec(i:i+bits-1);
    j = floor(i/bits) + 1;
    output_data(j,1:bits) = temp;
end
clear i
 

% --- it`s time to make Audio file from our binary data
tic
unqu_signal = sound_decode(output_data, bits);
time4 = toc;

fprintf(fileID,'\n \n --------  TIMES ---------- \n');
fprintf(fileID,'***  time of sound-encode   : %.4f \n',time1);
fprintf(fileID,'***  time of modulation     : %.4f \n',time2);
fprintf(fileID,'***  time of demodulation   : %.4f \n',time3);
fprintf(fileID,'***  time of sound-deencode : %.4f \n',time4);
fileID = fclose('all');

