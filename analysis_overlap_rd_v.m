addpath('src');
addpath('data');
%specify your data here
load toy
events = toycount;
events(isnan(events)) = 0;
events = events(1:400);

%define lambda
lambdas = 10.^(-10:1:10);
celld = 1:1:100;
cello = 0.0:0.1:0.9;
nd = length(celld);
no = length(cello);
configs = zeros(no*nd,3);
for i = 1:nd
    configs((no*(i-1)+1):no*i,1) = cello;
    configs((no*(i-1)+1):no*i,2) = celld(i);
    tempoverlap = round(cello* celld(i));
    tempoverlap(tempoverlap==celld(i)) = celld(i)-1;
    configs((no*(i-1)+1):no*i,3) = tempoverlap;
end

%now reconstruction specify the method
f_smooth = 1;
f_sparse = 0;
f_sp = 0;
num_loop = 1;
[ Out ] = loop_reconstruction_overlap_rd_v( events, lambdas,configs,num_loop,f_smooth,f_sparse,f_sp,'loop_nymeasle_');
xdim = no;
ydim = nd;


totalnum = length(Out);
minvalp = zeros(totalnum,1);

minarraysm = zeros(totalnum,1);
minvalsm = zeros(totalnum,1);
maxarraysm = zeros(totalnum,1);
maxvalsm = zeros(totalnum,1);

Xs = zeros(totalnum,1);
Ys = zeros(totalnum,1);
Zs = zeros(totalnum,1);

for i = 1:length(Out)
    tempout = Out(i);       
    minvalp(i) = mean(tempout.perrors(:));
    minvalsm(i) = mean(tempout.smerrors(:));
    maxvalsm(i) = mean(tempout.smerrors2(:));
    smparams = lambdas(tempout.smparams(:));
    minarraysm(i) = 10^(mean(log10(smparams)));
    smparams2 = lambdas(tempout.smparams2(:));
    maxarraysm(i) = 10^(mean(log10(smparams2)));
   
    Xs(i) = tempout.muvars(2);
    Ys(i) = tempout.muvars(4);
    Zs(i) = tempout.muvars(1);
end


Xs = reshape(Xs,xdim,ydim);
Ys = reshape(Ys,xdim,ydim);
Zs = reshape(Zs,xdim,ydim);

minvalp = reshape(minvalp,xdim,ydim);
minvalsm = reshape(minvalsm,xdim,ydim);
maxvalsm = reshape(maxvalsm,xdim,ydim);

logminarraysm = log10(minarraysm);
logmaxarraysm = log10(maxarraysm);

logminarraysm = reshape(logminarraysm,xdim,ydim);
logmaxarraysm = reshape(logmaxarraysm,xdim,ydim);

figure;
pcolor(Xs,Ys,minvalp);
colorbar;
xlabel('RN');
ylabel('RD');
title('Peudo-Inverse')

figure;
subplot(2,1,1);
pcolor(Xs,Ys,minvalsm);
colorbar;
xlabel('RD');
ylabel('Overlap Ratio');
title('Smooth Minimum MSE');
subplot(2,1,2);
pcolor(Xs,Ys,Zs);
colorbar;
xlabel('RD');
ylabel('Overlap Ratio');
title('Corresponding Report Number');

