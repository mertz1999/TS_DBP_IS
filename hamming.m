function [output] = hamming(input, state)
% --- this function used for hamming coded with state 0 
% --- this function used for hamming decode with state 1 

if state == 0
    % --- for coding 
    % --- make parity bits
    data = input;
    p1 = mod( sum([data(1) data(2) data(4) data(5) data(7)]), 2 );
    p2 = mod( sum([data(1) data(3) data(4) data(6) data(7)]), 2 );
    p3 = mod( sum([data(2) data(3) data(4) data(8)]), 2 );
    p4 = mod( sum([data(5) data(6) data(7) data(8)]), 2 );
    % --- make output of data coded
    data_coded = [p1 p2 data(1) p3 data(2) data(3) data(4) p4 data(5) data(6) data(7) data(8)];
    output = data_coded;
    
elseif state == 1
    
    % --- for decoding and find one mistake and reverse that
    a = input;
    % --- find new parities
    p1 = mod( sum([a(3) a(5) a(7) a(9) a(11)]), 2 );
    p2 = mod( sum([a(3) a(6) a(7) a(10) a(11)]), 2 );
    p3 = mod( sum([a(5) a(6) a(7) a(12)]), 2 );
    p4 = mod( sum([a(9) a(10) a(11) a(12)]), 2 );
    % --- check for parities being True
    check = [];
    if p1 ~= a(1)
        check = [check 1];
    end

    if p2 ~= a(2)
        check = [check 2];
    end

    if p3 ~= a(4)
        check = [check 4];
    end

    if p4 ~= a(8)
        check = [check 8];
    end
    % --- find sum of False Parities`s index
    check = sum(check);
    % --- reverse 
    if (check ~= 0 && check <= 12)
        a(check) = ~a(check);
    end

    decode = [a(3) a(5) a(6) a(7) a(9) a(10) a(11) a(12)];
    output = decode;
end
end