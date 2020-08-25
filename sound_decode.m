function [unqu_signal] = sound_decode(qu_signal_bi, bit_number)

% its time to make Audio wave file
steps = [];
steps = -1:(1/((2^bit_number)-1))*2:1;

unqu_signal = bi2de(qu_signal_bi,2);

for i=1:length(unqu_signal)
    unqu_signal(i) = steps(unqu_signal(i)+1);
end

end