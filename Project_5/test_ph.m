clc;
fileID1 = fopen('LoRa_trace_1','r');
fileID2 = fopen('base_chirp_SF_8');
formatSpec = '%f';

input_f = fscanf(fileID1, formatSpec);
input_f2 = fscanf(fileID2, formatSpec);

data = reshape(input_f, 2, length(input_f)/2);
data = transpose(data);
base_chirp = reshape(input_f2, 2, length(input_f2)/2);
base_chirp = transpose(base_chirp);

data = complex(data(1:end,1), data(1:end,2));
base_chirp = complex(base_chirp(1:end,1), base_chirp(1:end,2));

SF = 8;
CFO = -1.57;

packet_start = 217626;
symbol_size = 256*8;
packet_end = packet_start + (12.25+28)*256*8-1;

packet = data(packet_start: packet_end);
temp = CFO*2*pi/256;
t = 0:temp:CFO*2*pi;
sinewave = sin(CFO*t);

sinewave = sinewave(1:end-1);
sinewave = transpose(sinewave);
new_sin = [];
for i=1:1:322
    new_sin = [new_sin; sinewave];
end


new_packet = packet.*new_sin;
packet = new_packet(symbol_size*12.25: end);

result = [];
for i=1:symbol_size:length(packet)-symbol_size
    Y = packet(i:8:i+symbol_size-1);
    Z = Y.*conj(base_chirp);
    to_fft = fft(Z);
    [M, I] = max(abs(to_fft));
    result = [result, I];
end
disp(result);
test_arr = [29 49 253 113 57 61 13 49 100 49 37 22 61 226 191 240 173 85 151 28 170 122 132 206 83 214 79 245];
diff = abs(result - test_arr);