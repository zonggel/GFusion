function first_paper_figure_gen( Out, events,lambdas)
Nevents = length(events);
P = 52;
xline = Nevents/50*Nevents/P;

totalnum = length(Out);
minvalp = zeros(totalnum,1);


minvalpd = zeros(totalnum,1);

minarraysm = zeros(totalnum,1);
minvalsm = zeros(totalnum,1);
maxarraysm = zeros(totalnum,1);
maxvalsm = zeros(totalnum,1);
minvalsp = zeros(totalnum,1);

Xs = zeros(totalnum,1);
Ys = zeros(totalnum,1);

Aentry = zeros(totalnum,1);

for i = 1:length(Out)
    tempout = Out(i);       
    minvalp(i) = mean(tempout.perrors(:));
    minvalpd(i) = mean(tempout.pderrors(:));
    minvalsm(i) = mean(tempout.smerrors(:));
    maxvalsm(i) = mean(tempout.smerrors2(:));
    minvalsp(i) = mean(tempout.sperrors(:));
    
    smparams = lambdas(tempout.smparams(:));
    minarraysm(i) = 10^(mean(log10(smparams)));
    smparams2 = lambdas(tempout.smparams2(:));
    maxarraysm(i) = 10^(mean(log10(smparams2)));
   
    Xs(i) = tempout.muvars(1);
    Ys(i) = tempout.muvars(3);
    Aentry(i) = 400/Xs(i)/Ys(i);

end
xdim = length(unique(Xs));
ydim = length(unique(Ys));

Xs = reshape(Xs,ydim,xdim);
Ys = reshape(Ys,ydim,xdim);
rns = Xs(1,:);
rds = Ys(:,1);

minvalp = reshape(minvalp,ydim,xdim);
minvalsm = reshape(minvalsm,ydim,xdim);
minvalpd = reshape(minvalpd,ydim,xdim);
minvalsp = reshape(minvalsp,ydim,xdim);



figure;
pcolor(Xs,Ys,minvalp);
colorbar;
xlabel('RN');
ylabel('RD');
title('Peudo-Inverse')


figure;
pcolor(Xs,Ys,minvalsm);
colorbar;
xlabel('RN');
ylabel('RD');
title('Smooth MSE');

figure;
pcolor(Xs,Ys,minvalsm);
colorbar;
xlabel('RN');
ylabel('RD');
title('Smooth/Peudo-Inverse MSE');

figure;
plot(rns,minvalp(1,:),'b--',rns,minvalp(round((1+ydim)/2),:),'b+',rns,minvalp(end,:),'b*');
hold on
plot(rns,minvalsp(1,:),'r--',rns,minvalsp(round((1+ydim)/2),:),'r+',rns,minvalsp(end,:),'r*');
hold on
plot(rns,minvalsm(1,:),'g--',rns,minvalsm(round((1+ydim)/2),:),'g+',rns,minvalsm(end,:),'g*');
hold on
plot(rns,minvalpd(1,:),'c--',rns,minvalpd(round((1+xdim)/2),:),'c+',rns,minvalpd(end,:),'c*');
legend(sprintf('Pseudo-Inverse:RD=%d',rds(1)),sprintf('Pseudo-Inverse:RD=%d',rds(round((1+ydim)/2))),sprintf('Pseudo-Inverse:RD=%d',rds(end)),...
    sprintf('Sparsity:RD=%d',rds(1)),sprintf('Sparsity:RD=%d',rds(round((1+ydim)/2))),sprintf('Sparsity:RD=%d',rds(end)),...
    sprintf('Smoothness:RD=%d',rds(1)),sprintf('Smoothness:RD=%d',rds(round((1+ydim)/2))),sprintf('Smoothness:RD=%d',rds(end)),...
    sprintf('Periodicity:RD=%d',rds(1)),sprintf('Periodicity:RD=%d',rds(round((1+ydim)/2))),sprintf('Periodicity:RD=%d',rds(end)))
%hold on
%y1=get(gca,'ylim');
%plot([xline  xline],y1);
xlabel('RN')
ylabel('Minimal MSE')

% figure;
% plot(rns,minvalp(1,:),'b--',rns,minvalp(17,:),'b+',rns,minvalp(33,:),'b*');
% hold on
% plot(rns,minvalsp(1,:),'r--',rns,minvalsp(17,:),'r+',rns,minvalsp(33,:),'r*');
% hold on
% plot(rns,minvalsm(1,:),'g--',rns,minvalsm(17,:),'g+',rns,minvalsm(33,:),'g*');
% hold on
% plot(rns,minvalpd(1,:),'c--',rns,minvalpd(17,:),'c+',rns,minvalpd(33,:),'c*');
% legend('Pseudo-Inverse:RD=8','Pseudo-Inverse:RD=24','Pseudo-Inverse:RD=40', 'Sparsity:RD=8', 'Sparsity:RD=24', 'Sparsity:RD=40','Smoothness:RD=8','Smoothness:RD=24','Smoothness:RD=40','Periodicity:RD=8','Periodicity:RD=24','Periodicity:RD=40')
% xlabel('RN')
% ylabel('Minimal MSE')

figure;
plot(rds',minvalp(:,1),'b--',rds',minvalp(:,round((1+xdim)/2)),'b+',rds',minvalp(:,end),'b*');
hold on
%plot(rds,minvalsp(:,1),'r--',rds,minvalsp(:,round((1+xdim)/2)),'r+',rds,minvalsp(:,end),'r*');
%hold on
%sprintf('Sparsity:RN=%d',rns(1)),sprintf('Sparsity:RN=%d',rns(round((1+xdim)/2))),sprintf('Sparsity:RN=%d',rns(end))...
plot(rds,minvalsm(:,1),'g--',rds,minvalsm(:,round((1+xdim)/2)),'g+',rds,minvalsm(:,end),'g*');
hold on
plot(rds,minvalpd(:,1),'c--',rds,minvalpd(:,round((1+xdim)/2)),'c+',rds,minvalpd(:,end),'c*');
legend(sprintf('Pseudo-Inverse:RN=%d',rns(1)),sprintf('Pseudo-Inverse:RN=%d',rns(round((1+xdim)/2))),sprintf('Pseudo-Inverse:RN=%d',rns(end)),...
    sprintf('Smoothness:RN=%d',rns(1)),sprintf('Smoothness:RN=%d',rns(round((1+xdim)/2))),sprintf('Smoothness:RN=%d',rns(end)),...
    sprintf('Periodicity:RN=%d',rns(1)),sprintf('Periodicity:RN=%d',rns(round((1+xdim)/2))),sprintf('Periodicity:RN=%d',rns(end)));

xlabel('RD')
ylabel('Minimal MSE')


end

