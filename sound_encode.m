function [qu_signal_bi,Fs]=sound_encode(Audio_name, time, bit_number)

% Read Audio file i
[sound_data,Fs] = audioread(Audio_name);


% make Audio file normalized 
sound_data = sound_data/max(abs(sound_data));

% define time of Audio
sound_data = sound_data(1:Fs*time);


% ----------  make this Audio to 2^n steps and binary code -----------
steps = -1:(1/((2^bit_number)-1))*2:1;
n = size(steps);
n = n(2);

% so now we must to make this 2^n steps to binary codes
code_book = [0:2^bit_number-1];
code_book = de2bi(code_book);

qu_signal = [];                     % decimal Signal after Equ
qu_signal_bi = ones(1,bit_number);  % Binary Signal after Equ

% find nearest steps 
for i = 1:length(sound_data)
    min = [3];
    for j = 1:length(steps)
       if (abs(sound_data(i) - steps(j)) < min(1))
           min(1) = abs(sound_data(i) - steps(j));
           min(2) = steps(j);
           min(3) = j;
       end  
    end
    qu_signal(i) = min(2);
    qu_signal_bi(i,1:end) = code_book(min(3),1:end);
end

end