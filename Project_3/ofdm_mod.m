
N = 64;
cplen = 16;
smbllen = cplen + N;
data_subc_idx = [2:4:N-1];
data_smbl_num = 5;
SNR = 30; % NOTE: in dB 
SNR_mul = 1/sqrt(power(10,SNR/10));
 
train_val = [  -1     1    -1     1    -1     1    -1    -1    -1     1     1     1    -1     1     1    -1];
data_val = [];
for h=1:data_smbl_num
    data_val = [data_val; sign(rand(1,length(data_subc_idx))-0.5)];
end
 
tomodval = [train_val; data_val];
modsymbol = [];
for symidx=1:size(tomodval)
    toifft = zeros(1,N);
    toifft(data_subc_idx) = tomodval(symidx,:);
    afterifft = ifft(toifft);
    thissymbol = [afterifft(end-cplen+1:end),afterifft];
    modsymbol = [modsymbol,thissymbol];
end
 
chcfg.DelayProfile = 'ETU';
chcfg.NRxAnts = 1;
chcfg.DopplerFreq = 5; % orig: 5
chcfg.MIMOCorrelation = 'Low';
chcfg.Seed = 1;
chcfg.InitPhase = 'Random';
chcfg.ModelType = 'GMEDS';
chcfg.NTerms = 16;
chcfg.NormalizeTxAnts = 'On';
chcfg.NormalizePathGains = 'On';
chcfg.SamplingRate = 1000000; 
chcfg.InitTime = 0;
chcfg.Seed = ceil(rand(1)*1000000); 
 
cleansig = lteFadingChannel(chcfg, transpose(modsymbol)); cleansig = transpose(cleansig);
noise = (randn(1,length(cleansig)) + 1i*randn(1,length(cleansig)))/sqrt(2)*SNR_mul;
outp = cleansig + noise;

 







