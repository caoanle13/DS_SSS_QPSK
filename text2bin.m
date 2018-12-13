% "SOURCE ENCODER"
% Function with input: text (string)  - output: binary stream (array)

function message_bin = text2bin(message)
temp = dec2bin(message, 8);
temp = temp';
temp = temp(:)';
message_bin = temp == '1';
end