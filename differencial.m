function [output] = differencial(data, state)
% --- this function is made for defferencial coding and decoding together


% --- so in data we must comparison each data to it`s neighbour data and
%     and set data in Dispute of data
n = length(data);


% --- state 0 for encode
if (state == 0)
    diffCoded_data = data;
    last_bit = 0;
    % --- decide now each data changed or not
    for i = 1:n
      if data(i) == 1
        last_bit = 1 - last_bit;
      end
      diffCoded_data(i) = last_bit;
    end
    output = diffCoded_data; 
    
    
% --- state 1 for decode
elseif (state == 1)
    diffDecoded_data = [data(1)];
    K = size(data);
    K = K(2);
    for i = 2:K
      if data(i) == data(i - 1)
        diffDecoded_data(i) = 0;
      else
        diffDecoded_data(i) = 1;
      end
    end
    output = diffDecoded_data; 
else
    disp(" :) ")
end

end