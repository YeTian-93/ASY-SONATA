text  = fileread('processed.cleveland.data');
lines = strread(text, '%s','delimiter','\n');
data  = zeros(1,14);
k     = 1;

for l = 1:length(lines)
    temp = str2num(cell2mat(lines(l)));
    if ~isempty(temp)
        data(k,:) = temp;
        if data(k,end) == 0
            data(k,end) = -1.0;
        else
            data(k,end) = 1.0;
        end
        k = k+1;
    end
end

save('raw_data.mat', 'data')

exit;