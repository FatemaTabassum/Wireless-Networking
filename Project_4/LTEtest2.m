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


Tadv1_RSRP = [];
Tadv2_RSRP = [];
Tadv3_RSRP = [];

Tadv1_UE = [];
Tadv2_UE = [];
Tadv3_UE = [];
for i = 1:length(FD_idx_RSRP)
    if((FD_idx_Tadv(i) == 1) && (FD_idx_RSRP(i) ~= 0))
        if(length(Tadv1_RSRP) == 0)
            Tadv1_RSRP = FD_idx_RSRP(i);
            Tadv1_UE   = FD_idx_ID(i);
        else
            Tadv1_RSRP = [Tadv1_RSRP FD_idx_RSRP(i)];
            Tadv1_UE   = [Tadv1_UE FD_idx_ID(i)];
        end
    end
    
    if((FD_idx_Tadv(i) == 2) && (FD_idx_RSRP(i) ~= 0))
        if(length(Tadv2_RSRP) == 0)
            Tadv2_RSRP = FD_idx_RSRP(i);
            Tadv2_UE   = FD_idx_ID(i);
        else
            Tadv2_RSRP = [Tadv2_RSRP FD_idx_RSRP(i)];
            Tadv2_UE   = [Tadv2_UE FD_idx_ID(i)];
        end
    end
    
    if((FD_idx_Tadv(i) == 3) && (FD_idx_RSRP(i) ~= 0))
        if(length(Tadv3_RSRP) == 0)
            Tadv3_RSRP = FD_idx_RSRP(i);
            Tadv3_UE   = FD_idx_ID(i);
        else
            Tadv3_RSRP = [Tadv3_RSRP FD_idx_RSRP(i)];
            Tadv3_UE   = [Tadv3_UE FD_idx_ID(i)];
        end
    end
end


RSRP_1 = get_avg_rsrp(Tadv1_UE,Tadv1_RSRP);
RSRP_2 = get_avg_rsrp(Tadv2_UE,Tadv2_RSRP);
RSRP_3 = get_avg_rsrp(Tadv3_UE,Tadv3_RSRP);


[f1,x1] = ecdf(RSRP_1);
[f2,x2] = ecdf(RSRP_2);
[f3,x3] = ecdf(RSRP_3);

plot(x1,f1,x2,f2,x3,f3)

function fx = get_avg_rsrp(ue,rsrp)
    [x,y] = unique(ue,'stable');
    if(length(x) == length(rsrp))
        fx = rsrp;
    else
        fx = zeros(1,length(x));
        for i = 1:length(x)
            lx = 1;
            for j = 1:length(ue)
                if(ue(j) == x(i))
                    fx(i) = rsrp(j) + fx(i);
                    lx = lx + 1;
                end
            end
            fx(i) = fx(i)/lx;
        end    
    end
end




