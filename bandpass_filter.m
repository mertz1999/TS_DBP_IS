function [tog] = bandpass_filter(L, c1, c2,ripple,sampling_frequency)
% ---- tring to make a band pass filter
% ---- L = number of signal, c1,2 = Frequency tolerance 1 and 2 for example
%       this filter !cut from   Fc-C2 -> Fc+C1

% ---- define number of filter member that we wand to be 1 or 0 (with ripple)
% N1 = (c1/180)*L;
% N2 = (c2/180)*L;

% c1 = c1 / 6.28;
% c2 = c2 / 6.28;

N1 = c1/((sampling_frequency*6.28)/L);
N2 = c2/((sampling_frequency*6.28)/L);



cn1 = [];          % ---- this is chebishev Cofficients for low pass
cn2 = [];          % ---- this is chebishev Cofficients for high pass
T = 1;             % ---- it`s sampling frequency


w1 = 1:T:L/2;      % ---- range of this filter
w2 = w1;           % ---- range of this filter


result1 = [];      % ---- this is low pass output
result2 = [];      % ---- this is high pass output


wc1 = L/2 - N1;    % ---- cut-off frequency 1
wc2 = L/2 - N2;    % ---- cut-off frequency 2


% ---- make Cn1 Cofficient ---- %
for n=0:(length(w1)-1)
    if (n == 0)
        cn1(1) = 0;
        cn2(1) = 0;
    elseif (n == 1)
        cn1(2) = w1(n+1)/wc1;
        cn2(2) = w1(n+1)/wc2;
    else
        cn1(n+1) = 2 * (w1(n+1)/wc1) * cn1(n) - cn1(n-1);
        cn2(n+1) = 2 * (w2(n+1)/wc2) * cn2(n) - cn2(n-1);
    end
end


% % ---- make Cn2 Cofficient ---- %
% for n=0:(length(w1)-1)
%     if (n == 0)
%         cn2(1) = 0;
%     elseif (n == 1)
%         cn2(2) = w1(n+1)/wc2;
%     else
%         cn2(n+1) = 2 * (w2(n+1)/wc2) * cn2(n) - cn2(n-1);
%     end
% end


% ---- make our filter1 ---- %
for i=1:length(w1)
    result1(i) = 1 - 1/(1 + ripple*(cn1(i)^2));
    result2(i) = 1 - 1/(1 + ripple*(cn2(i)^2));
end
% --- flip this one
result1 = fliplr(result1);
figure
plot(result1)
title("result1")

% % ---- make our filter2 ---- %
% for i=1:length(w2)
%     result2(i) = 1 - 1/(1 + ripple*(cn2(i)^2));
% end


% ---- set low pass and high pass together
tog = [result1,result2];


% ---- bescuse of mathmatical error this data may be Nan so we set them to 1
for i=1:length(tog)
    if isnan(tog(i))
        tog(i) =1;
    end
end


% ---- if mod L on 2 is`nt 0 we must to set a single data in prev data i
%      set it at the end
if (mod(L,2) ~= 0)
    tog= [tog,1];
end

% --- woooooow it`s END :)
end