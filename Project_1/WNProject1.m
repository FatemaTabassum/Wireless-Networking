clear 
close all
clc

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% PROJECT - PART 1 %%%%%%%%%%%%%%%%%%%%%

% READ FILES
fileID = fopen('proj1_test_1.txt','r');
formatSpec = '%f %f';
sizeA = [2 Inf];
A = fscanf(fileID,formatSpec,sizeA);
fclose(fileID);
A = A';
real = A(:,1);
img = A(:,2);
zz =1;
real = real(zz:end);
img = img(zz:end);


sz = length(real);
% sz=1000;
strt = 1;

real = real(strt:sz + strt - 1);
img = img(strt:sz + strt - 1);


% COMPLEX FORMS
z = real + 1i*img; % a vecotr - representing in complex  form
r = abs(z); % a vector - finding the magnitude
theta = angle(z); % a vector - finding the phase


% DEFINE RUNTIME VARIABLES AND CONSTANTS
d_phase = 0.0;
d_freq = 0.0;
d_beta = 0.005;
d_alpha = 0.5;
decision_array = zeros(1,sz);
decision_count = 0;
SR1 = zeros(1, sz);
SI1 = zeros(1, sz);



if (real(1) >= 0)
    decision = 1;
else
    decision = -1;
end
decision_count = decision_count + 1;
decision_array(decision_count) = decision;

phase_error = find_phase_error(real(1), img(1), decision);
d_freq = d_freq + d_beta * phase_error;
d_phase = d_phase + d_freq + d_alpha * phase_error;
[SR1(1),SI1(1)] = rotate(real(1), img(1), d_phase);

for ix = 2:1:sz
    
    [SR1(ix), SI1(ix)]  = rotate(real(ix), img(ix), d_phase);
    
    zcomplex = SR1(ix) + 1i*SI1(ix);
    rr = abs(zcomplex);
    theta_prime = angle(zcomplex);
    theta_prime = rad2deg(theta_prime);
    
    if (SR1(ix) >= 0)
        decision = 1;
    else
        decision = -1;
    end
    decision_count = decision_count + 1;
    decision_array(decision_count) = decision;
    
    phase_error = find_phase_error(SR1(ix), SI1(ix), decision);
    d_freq = d_freq + d_beta * phase_error;
    d_phase = d_phase + d_freq + d_alpha * phase_error;
    
end
%WRITE REAL PARTS TO A FILE
writematrix(SR1','costasoutR.txt');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% PROJECT - PART 2 %%%%%%%%%%%%%%%%%%%%%

%mmdecision array generation
M_array = zeros(1,round(sz/10));
M_count = 1;
ix = 2;
z = 0;
%M_array(1) = SR1(ix);
while true
    u = ((decision_array(ix-1) - decision_array(ix+1))*SR1(ix)) - ((SR1(ix-1) - SR1(ix+1))*decision_array(ix));
    z = round(z + 10 + (0.1)*u);
    M_array(M_count) = SR1(z);
    M_count = M_count + 1;
    if(M_count == length(M_array))
        break;
    end
    ix = z;
end

MM_array = zeros(1,length(M_array));

for ix = 1:length(MM_array)
    if(M_array(ix) > 0)
        MM_array(ix) = 1;
    else
         MM_array(ix) = 0;
    end
end
%WRITE MMDECISIONS  TO A FILE
writematrix(MM_array','mmdecisions.txt');
plot(M_array');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% PROJECT - PART 3 %%%%%%%%%%%%%%%%%%%%%

%Original bits extraction
MMO_array = zeros(1,length(M_array));
for ix = 2:1:length(MMO_array)
    if(MM_array(ix) ~= MM_array(ix-1))
        MMO_array(ix) = 1;
    end
end

%Finding the target packet
%0xA4F2 --> 1010010011110010
tgt_pkt = ([1,0,1,0,0,1,0,0,1,1,1,1,0,0,1,0]);
pkt_sz = length(tgt_pkt);
pkt_loc = [];
for ix = 1:1:length(MM_array) - pkt_sz
    score= 0;
    iz = 1;
    for iy = ix:1:ix+pkt_sz-1
        if(MMO_array(iy) == tgt_pkt(iz))
            score = score+1;
        end
        iz = iz+1;
    end
    if(score ==pkt_sz)
        if(length(pkt_loc) == 0)
            pkt_loc = ix;
        else
            pkt_loc = [pkt_loc ix];
        end
    end
end

disp(pkt_loc');


% % PLOT THE RESULT
custom_plot(SR1(1:1000), SI1(1:1000));
%custom_plot(MM_array);

% 







            %%%%%%%%%%%%%%%%% ALL THE CUSTOM FUNCTIONS %%%%%%%%%%%%%%%%%


% ROTATE THE POINTS BY d_phase
function [x_prime, y_prime] = rotate(x, y, theta)
    % theta in radian 
    theta_in_rad = (theta/180)*pi;
    x_prime = (x*cos(theta_in_rad)) - (y*sin(theta_in_rad));
    y_prime = (x*sin(theta_in_rad)) + (y*cos(theta_in_rad));
end


% FIND THE PHASE ERROR
function phase_error = find_phase_error(x_prime, y_prime, decision)
    theta_hold = 0;
    i_hold = 1;
    if (decision == 1)
        if (y_prime >= 0)    
            for ix = 0:1:180
                [r,i] = rotate(x_prime,y_prime,-ix);
                if(abs(i) < i_hold)
                    i_hold = abs(i);
                    theta_hold = ix;
                end
            end
            phase_error = -theta_hold;
            
        elseif (y_prime < 0)
            for ix = 0:1:180
                [r,i] = rotate(x_prime,y_prime,ix);
                if(abs(i) < i_hold)
                    i_hold = abs(i);
                    theta_hold = ix;
                end
            end
            phase_error = theta_hold;
        end
        
    else
        
        if (y_prime >= 0)    
            for ix = 0:1:180
                [r,i] = rotate(x_prime,y_prime,ix);
                if(abs(i) < i_hold)
                    i_hold = abs(i);
                    theta_hold = ix;
                end
            end
            phase_error = theta_hold;
            
        elseif (y_prime < 0)
            for ix = 0:1:180
                [r,i] = rotate(x_prime,y_prime,-ix);
                if(abs(i) < i_hold)
                    i_hold = abs(i);
                    theta_hold = ix;
                end
            end
            phase_error = -theta_hold;
        end
            
    end
end




% PLOT REAL AND IMAGINARY
function custom_plot(x, y)
    figure
    n_plots = 4;
    subplot(n_plots,1,1)
    plot(x);
    ylim([-1.2 1.2])
    subplot(n_plots,1,2)
    p = plot(y);
    p.Color = 'r';
    ylim([-1.2 1.2]);

end




