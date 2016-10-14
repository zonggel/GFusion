function first_paper_figure_gen_scalarbility(events, lambdas, rd)
    
ny_measles = events;
nloop = 100;
% random Gaussian measurement matrix for simplicity:

% rns = 400:200:2000;
% times1 = zeros(length(rns),1);
% 
%smoothness reconstruction
% for j = 1:length(rns)
%     rn = rns(j);
%     [A,y]=rep_gen(ny_measles, rn, rd);
%     t = cputime;
%     for i = 1:nloop
%         opt_smooth(A,y,lambdas);
%     end
%     times1(j) = (cputime - t)/nloop;
% end

rn = 20;
nticks = 400:200:2000;
times2 = zeros(length(nticks),1);
for j = 1:length(nticks)
    [A,y]=rep_gen(ny_measles(1:nticks(j)), rn, rd);
    t = cputime;
    for i = 1:nloop
        opt_smooth(A,y,lambdas);
    end
    times2(j) = (cputime - t)/nloop;
end

X = [ones(length(nticks),1) nticks'];
b = X\times2;


% figure;
% plot(rns,times1)
% title('Scalability with Report Number')
% xlabel('Report Number')
% ylabel('CPU time')
figure;
scatter(nticks,times2)
hold on
yCalc2 = X*b;
plot(nticks,yCalc2,'--')
xlabel('Total Time Ticks')
ylabel('CPU time')
title('Scalability with Total Time Ticks')

end

