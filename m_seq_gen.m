% M-SEQUENCE GENERATOR
% Function with -input: powers of the primitive polynomial & initial state of the shift register -output: m-sequence 

function m_seq = m_seq_gen(coeff, state)

order = coeff(1);%gets the order of the polynomial
period = 2^(order)-1;
taps = zeros(1, length(coeff)-1); %initialise the feedback connections

m_seq = zeros(1, period); %initialise the m-sequence

for k=1:period
    %get the m-sequence from the LSB of state
    m_seq(k) = state(order);
    
    %get the feedback connections
    for j=1:length(coeff)-1
        taps(j) = state(order-coeff(j+1));
    end
    
    %perform a mod 2 sum of all the taps and store in inject
    inject = mod(sum(taps), 2);
    
    %perform a circular shift of state and replace the MSB of state by inject
    state = circshift(state, 1);
    state(1) = inject;
end

end

    