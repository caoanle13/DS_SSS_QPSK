function varargout = DS_SSS_QPSK(varargin)
% DS_SSS_QPSK MATLAB code for DS_SSS_QPSK.fig
% Last Modified by GUIDE v2.5 04-Jan-2018 12:02:31
% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @DS_SSS_QPSK_OpeningFcn, ...
                   'gui_OutputFcn',  @DS_SSS_QPSK_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before DS_SSS_QPSK is made visible.
function DS_SSS_QPSK_OpeningFcn(hObject, eventdata, handles, varargin)
% Choose default command line output for DS_SSS_QPSK
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);


% -------PN-CODE: GOLD SEQUENCE (DELAY=16,17 FOR MESSAGE,JAMMER)-------

% M-sequences parameters and generation

coeff_1 = [5 2 0]; % primitive polynomial: x^5+x^2+1
state_1 = [1 1 1 1 1]; % initial state defined as all 1s
m_seq_1 = m_seq_gen(coeff_1, state_1); %generate the m-sequence

coeff_2 = [5 3 2 1 0]; % same for second m-sequence
state_2 = [1 1 1 1 1];
m_seq_2 = m_seq_gen(coeff_2, state_2);

delay = 16; % Offset between the 2 m-sequences for the gold-sequence generation
g_seq_data =  g_seq_gen(m_seq_1, m_seq_2, delay); % Generate the gold sequence
g_seq_data_mapped = 1 - 2 * g_seq_data; %  Mapping "0s" to "1s" and "1s" to "-1s"

% Repeat for the jammer's pn-code
coeff_1 = [5 3 0];
state_1 = [1 1 1 1 1];
m_seq_1 = m_seq_gen(coeff_1, state_1);

coeff_2 = [5 4 2 1 0];
state_2 = [1 1 1 1 1];
m_seq_2 = m_seq_gen(coeff_2, state_2);

delay = 17;
g_seq_jammer = g_seq_gen(m_seq_1, m_seq_2, delay);
g_seq_jammer_mapped = 1 - 2 * g_seq_jammer;


setappdata(0, 'g_seq_data_mapped', g_seq_data_mapped);
setappdata(0, 'g_seq_jammer_mapped', g_seq_jammer_mapped);


% --- Outputs from this function are returned to the command line.
function varargout = DS_SSS_QPSK_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;

%CreateFcn functions are called when the object is initialised.
%Callback functions are called when the object are changed.


% ---------------------- INITIALISATION OF ALL UI OBJECTS -----------------------------

% Textbox for the input message
function inputMessage_edit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% Textbox for the jammer message
function jammer_edit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% Textbox for the output message
function outputMessage_edit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% Radio button for the Spread Spectrum option
function ss_check_CreateFcn(hObject, eventdata, handles)
set(hObject, 'Value', 0);

% Text box for the SNRin value
function SNRin_edit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% Radio button for the Noise option
function noise_check_CreateFcn(hObject, eventdata, handles)
set(hObject, 'Value', 0);

% Radio button for the Jammer option
function jammer_check_CreateFcn(hObject, eventdata, handles)
set(hObject, 'Value', 0);

% Figure for the constellation diagram plot
function constellation_CreateFcn(hObject, eventdata, handles)
title('\fontsize{16}\color{black}QPSK Constellation Diagram');
xlabel('\color{gray}Real Part');
ylabel('\color{gray}Imaginary Part');

% Textbox for the total bit errors
function total_bit_errors_edit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% Textbox for the bit error rate
function bit_error_rate_edit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% ---------------------START OF ANALYSIS---------------------------------
function analyse_button_Callback(hObject, eventdata, handles)

% SOURCE ENCODER
message = get(handles.inputMessage_edit, 'String'); %retrieve text message
message_bin = text2bin(message); %convert text to binary sequence
bit_number = length(message_bin);
message_bin_mapped = 1 - 2*message_bin; % maps "0s" to "1s" and "1s" to "-1s"

% DIGITAL MODULATOR
modulated_data = QPSK_modulator(message_bin_mapped, bit_number);
temp = [1 1 -1 1 -1 -1 1 -1];
decision_points = QPSK_modulator(temp, 8); %creates the QPSK decision points

%Same for the jammer message
jammer = get(handles.jammer_edit, 'String');
jammer_bin = text2bin(jammer);
jammer_bin_mapped = 1 - 2*jammer_bin;
modulated_jammer = 10*QPSK_modulator(jammer_bin_mapped, bit_number); %jammer has 10x more power

% SPREADER
ss_state = get(handles.ss_check, 'Value'); %check if system includes spread spectrum
g_seq_data_mapped = getappdata(0, 'g_seq_data_mapped');
g_seq_jammer_mapped = getappdata(0, 'g_seq_jammer_mapped');

if ss_state == 1 %apply spreading
    transmitted_data = g_seq_data_mapped' * modulated_data;
    transmitted_jammer = g_seq_jammer_mapped' * modulated_jammer;
else %do nothing
    transmitted_data = modulated_data;
    transmitted_jammer = modulated_jammer;
end


% CHANNEL
noise_state = get(handles.noise_check, 'Value'); %check if system includes noise
jammer_state = get(handles.jammer_check, 'Value'); %check if system includes jammer
SNRin_db = str2num(get(handles.SNRin_edit, 'String')); %retrieve SNRin value

%transmitted signal is either corrupted or not depending on input parameters set by the user
%awgn(x) adds white gaussian noise to x
if noise_state == 1 && jammer_state == 0
    signal = awgn(transmitted_data, SNRin_db);
elseif noise_state == 0 && jammer_state == 1
    signal = transmitted_data + transmitted_jammer;
elseif noise_state == 1 && jammer_state == 1
    signal = awgn(transmitted_data, SNRin_db) + transmitted_jammer;
else
    signal = transmitted_data;
end
setappdata(0, 'signal', signal);

% DESPREADER (only if spreaded in the first place)
if ss_state == 1
    received_signal = g_seq_data_mapped * signal / length(g_seq_data_mapped);
elseif ss_state == 0
    received_signal = signal;
end


% CONSTELLATION DIAGRAM PLOT
scatter(real(received_signal), imag(received_signal), 'o', 'blue');
hold on;
scatter(real(decision_points), imag(decision_points), 'x', 'red');
ylim = get(gca, 'YLim');
A = [0 cos(14*pi/40)];
B = [0 sin(14*pi/40)];
m = (B(2)-B(1))/(A(2)-A(1));
xlim = ylim/m;
hold on;
line(xlim, ylim);
hold on;
line(ylim, -xlim);
hold off
legend('received symbols','transmitted symbols', 'decision boundary');
title('\fontsize{16}\color{black}QPSK Constellation Diagram');
xlabel('\color{gray}Real Part');
ylabel('\color{gray}Imaginary Part');

% DIGITAL DEMODULATOR
demodulated_data = QPSK_demodulator(received_signal); %convert symbols to binary stream

% DECODER
output_message = bin2text(demodulated_data); %convert binary stream to text
set (handles.outputMessage_edit, 'String', output_message); %display text in output message textbox

total_correct_bits = sum( (demodulated_data-message_bin) == 0 ); %number of correct bits
total_bit_errors = bit_number - total_correct_bits; %number of wrong bits
ber = total_bit_errors/bit_number; %bit error rate
set(handles.total_bit_errors_edit, 'String', total_bit_errors);
set(handles.bit_error_rate_edit, 'String', ber);