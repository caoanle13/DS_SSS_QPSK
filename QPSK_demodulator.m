function demodulated_data = QPSK_demodulator(despreaded_signal)

phi = pi/10;
despreaded_signal_shifted = despreaded_signal * exp(1i*(-phi+pi/4));

demod_1 = imag(despreaded_signal_shifted) < 0;
demod_2 = real(despreaded_signal_shifted) < 0;

demodulated_data = [demod_1; demod_2];
demodulated_data = demodulated_data(:)';

