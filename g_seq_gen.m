% GOLD SEQUENCE GENERATOR
% Function with -input: two m-sequences & delay between them -output: gold sequence

function g_seq = g_seq_gen(m_seq_1, m_seq_2, delay)
% delay the second m-sequence
m_seq_2_delayed = circshift(m_seq_2, delay);
%perform a mod 2 sum of the two m-sequences to obtain the gold sequence
g_seq = mod(m_seq_1+m_seq_2_delayed, 2);