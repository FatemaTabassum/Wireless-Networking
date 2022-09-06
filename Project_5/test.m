clc
clear 
close all


sub_carriers = [2     6    10    14    18    22    26    30    34    38    42    46    50    54    58    62];
%%%%reading raw data from file and separating to real and imaginary
fileID = fopen('ofdm_samples1','r');
formatSpec = '%f%f\r\n';
A = fscanf(fileID,formatSpec);
fclose(fileID);
l = length(A)/2;
real = zeros(1,l);
imag = zeros(1,l);
j = 1;
for i = 1:2:2*l
    real(j) = A(i);
    imag(j) = A(i+1);
    j = j+1;
end
received_samples = complex(real,imag);

IN_Sample = received_samples(1:64);
ffT_sample = fft(IN_Sample);
sub_fft = zeros(1,16);
for i = 1:1:16
    sub_fft(i) = ffT_sample(sub_carriers(i));
end
figure
plot(abs(received_samples))
title("received samples")

figure
plot(abs(sub_fft))
title("CSI")
xlim([1 16]);
ylim([0 2.5]);