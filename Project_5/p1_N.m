clc
clear 
close all


fileID = fopen('LoRa_trace_1','r');
start_loc = 217626;
cfo = -1.57 ;
Fs = 2000000;
Ts = 1/Fs;

Packet_length = start_loc+(12.25+28)*256*8-1;
formatSpec = '%f\r\n';
A = fscanf(fileID,formatSpec);
fclose(fileID);

A = A(start_loc:start_loc+Packet_length);
l = length(A);
t = 1/Fs:1/Fs:l/Fs;

sine_val = sin(2*pi*cfo*t)';

B = A.*sine_val;
figure;
plot(A);
title("signal raw")

