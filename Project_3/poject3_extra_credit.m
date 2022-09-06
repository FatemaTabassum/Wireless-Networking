clc; clearvars; close all;

% READ FILES
infile = 'pkt7';
fileID = fopen(infile,'r');
formatSpec = '%f %f';
sizeA = [2 Inf];
A = fscanf(fileID,formatSpec,sizeA);
fclose(fileID);
A = A';
real_part = A(:,1);
img_part = A(:,2);
len = length(real_part);


infile = 'STS_WAVE';
fileID = fopen(infile,'r');
formatSpec = '%f %f';
sizeA = [2 Inf];
A = fscanf(fileID,formatSpec,sizeA);
fclose(fileID);
A = A';
sts_real_part = A(:,1);
sts_img_part = A(:,2);
sts_len = length(sts_real_part);


%%% a vector - representing in complex  form
L = 32;
z = real_part + 1i*img_part;                                   
sts_z = sts_real_part + 1i*sts_img_part;

[rr, lags] = xcorr(z, sts_z);
size(rr);
abs_rr = abs(rr);
plot(lags, abs_rr)

diff = -1;
threshold = 40000000;
% diff_threshold = 20000000;
cnt = 0;
lag_zero = 0;
Fs = 40000000;

for k = 1:1:length(lags)
    if(lags(k) == 0)
        lag_zero = k;
        break;
    end
end

lag_array = [];
abs_rr_up = [];
for ix = lag_zero+1:1:length(lags)
    lag_array = [lag_array; lags(ix)];
    abs_rr_up = [abs_rr_up; abs_rr(ix)];
end

for ix = 1:1:length(lag_array)
    last_ind = 0;
    if(abs_rr_up(ix) >= threshold)
        
%         check for 10 peaks
%         First find the highest peak
        maxx = -1;
        maxx_ind = -1;
        for im = ix:1:ix + L
            if(maxx <= abs_rr_up(im))
                maxx = max(maxx,abs_rr_up(im));
                maxx_ind = im;
            end
        end
        lp = maxx_ind + 10*L; %need to check
        cnt = 0;
        L = 32;
        for iy = maxx_ind:L:lp
            iy;
            temp = abs_rr_up(iy);
            if(temp >= threshold)
                cnt = cnt +  1;
                last_ind = iy;
            end
        end
        if(cnt == 10)
            disp(lag_array(maxx_ind) + L * 10);
%             time_delay = lag_array(maxx_ind)/Fs
%             first_sample_t = time_delay * Fs
        end
        break;
    end
end


