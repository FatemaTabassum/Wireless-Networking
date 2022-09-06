clc
clear 
close all


% 
% FD_idx_ID = 1;  	// UE ID
% FD_idx_SECT = 2;	// don’t worry about it
% FD_idx_TS = 3;	// timestamp, measured in miliseconds
% FD_idx_PCI = 4;	// the ID of the associated eNB
% FD_idx_RSRP = 5;	// the channel strength indicator from the asscoated eNB
% FD_idx_RSRQ = 6;	// don’t worry about it
% FD_idx_Tadv = 7;	// the time advance measurement, where 1 represents 80 m
% FD_idx_PHR = 8;	// don’t worry about it
% FD_idx_UpSINR = 9; // don’t worry about it
% FD_idx_SceEuTxRxTD = 10; // don’t worry about it
% FD_idx_nPCI = 11;	// the ID of a neighboring eNB
% FD_idx_nRSRP = 12; // the channel strength indicator from the neighboring eNB
% FD_idx_nRSRQ = 13; // don’t worry about it

fileID = fopen('LTE_TESTDATA_1','r');
formatSpec = '%f %f %f %f %f %f %f %f %f %f %f %f %f';
sizefile = [13 Inf];
A = fscanf(fileID,formatSpec,sizefile);
fclose(fileID);
FD_idx_ID           = A(1,:);
FD_idx_SECT         = A(2,:);
FD_idx_TS           = A(3,:);
FD_idx_PCI          = A(4,:);
FD_idx_RSRP         = A(5,:);
FD_idx_RSRQ         = A(6,:);
FD_idx_Tadv         = A(7,:);
FD_idx_PHR          = A(8,:);
FD_idx_UpSINR       = A(9,:);
FD_idx_SceEuTxRxTD  = A(10,:);
FD_idx_nPCI         = A(11,:);
FD_idx_nRSRP        = A(12,:);
FD_idx_nRSRQ        = A(13,:);

[xx,xy] = unique(FD_idx_ID,'stable');
n_id = zeros(1,length(xy));
n_tadv = zeros(1,length(xy));

for i = 1:length(xy)
   n_id(i)   =  FD_idx_ID(xy(i));
   n_tadv(i) =  FD_idx_Tadv(xy(i));
end


Unique_Tadv = unique(n_tadv);

nUE = zeros(1,length(Unique_Tadv));
for i = 1:length(nUE)
    nUE(i) = length(find(n_tadv == Unique_Tadv(i)));
end
figure
plot(nUE);
xlim([0 60])
ylim([0 900])


