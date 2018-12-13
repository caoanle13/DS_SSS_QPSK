function text = bin2text(binary)

bin_matrix = reshape(binary, [8,length(binary)/8])';
bin_matrix_str = num2str(bin_matrix, '%1d');
text = char(bin2dec(bin_matrix_str))';

end