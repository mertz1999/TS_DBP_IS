function [diffDecoded_data] = demodulation(SignalAfterChannel, carier)
% ------------Demodulation--------------------
% we make our signal demodulated by DPSK demodulation 


% --- we need size of our carrier so we make it
T = size(carier);
T = T(2);


% --- in this loop we seperate signal as long as carier and cross each of
%     them to previus section be cuase we set the beginning of data to 0 so
%     we do`nt need to spent time to search what was it :) so continue !!!
output_dem = [];
for k = T+1:T:length(SignalAfterChannel)
    % --- break the loop if we don`t have yet necessarly number of data
    if k+T-1 > length(SignalAfterChannel)
        break;
    end
    % --- seperate signals block
    signalBlock = SignalAfterChannel(k:k+T-1);
    signalBlock_prev = SignalAfterChannel(k-T:k-1);
    % --- it`s time to cross them
    Multiplied_Signal = 0; 
    Multiplied_Signal = signalBlock .* signalBlock_prev;
    % --- in this section we decide that our data is 1 or zero
    if mean(Multiplied_Signal) >= 0
        finded = 0;
    else 
        finded = 1;
    end
    output_dem = [output_dem,finded];    
end


%----------- Differencial Decode ---------------
diffDecoded_data = output_dem;

end