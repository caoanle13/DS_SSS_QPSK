% DIGITAL MODULATOR
% Function with -input: binary stream - output: QPSK symbol stream

function modulated = QPSK_modulator(bin_mapped, bit_number)

%Serial to parallel conversion
parallel_stream_1 = bin_mapped(1:2:bit_number);
parallel_stream_2 = bin_mapped(2:2:bit_number);

phi = pi/10; %phi = 18° = pi/10 rad

% Place the symbols in the correct quadrant with the correct angle.
modulated = (parallel_stream_2 + 1i*parallel_stream_1) * exp(1i*(phi-pi/4));
end