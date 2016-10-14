function first_paper_figure_gen_case(events, lambdas,alphas, rn, rd)
    
ny_measles = events;
% optional, if you want:
%ny_measles=ny_measles - mean(ny_measles);
% removing the mean allows for even better approximation

fm=fft(ny_measles);
%mask = abs(fm) > max(abs(fm))/30;
mask = zeros(length(ny_measles),1);
num_kept = 9;
mask(1:num_kept) = 1;
mask(end+1-num_kept:end) = 1;
%mask = abs(fm) > max(abs(fm))/30;
smooth = ifft(mask.*fm);
% figure(1);
% plot(ny_measles);
% hold on;
% plot(real(smooth),'r');
% legend('exact','smooth approximation, after FT thresholding'); figure(2);
% stem(mask);
% title('frequencies kept')

%So you see, your signal is indeed very sparse in the Fourier domain.

%Suppose now you know where the approximate zeros of the FT are, i.e., %you know "mask". then do the following:

C = dftmtx(length(ny_measles));
C = C(mask==0,:);
[r,~]=size(C);

% random Gaussian measurement matrix for simplicity:
[A,y]=rep_gen(ny_measles, rn, rd);

%fft reconstruction
estimated_ny_measles = pinv([A; C])*[y; zeros(r,1)];
estimated_ny_measles = abs(estimated_ny_measles);

%smoothness reconstruction
[smoothhat,smootherror] = smooth_reconstruct(A, y,lambdas,ny_measles);
[~, mini] = min(smootherror);
smoothhat = smoothhat(:,mini);

%peroidicity reconstruction
[sphat,sperror,~]=sp_reconstruct(A, y,lambdas,alphas, ny_measles);
[~, mini] = min(sperror(:));
[~,mi2,mi3] = ind2sub(size(sperror),mini);
sphat = sphat(:,mi2,mi3);

% peudo-inverse
phat = pinv(A)*y;

figure;
hold off; clf;
plot(ny_measles);
hold on
plot(phat,'k')
hold on
plot(smoothhat,'r')
xlabel('Event ID')
ylabel('Count')
grid on
%hold on;
%plot(cov,zeros(length(cov)),'b+');
legend('Truth','Pseudo-Inverse','Smoothness');
title(sprintf('Case: N = %d, D = %d',rn,rd));


figure;
hold off; clf;
plot(ny_measles);
hold on
plot(phat,'k')
hold on
plot(smoothhat,'r')
hold on
plot(sphat,'m')
xlabel('Event ID')
ylabel('Count')
grid on
%hold on;
%plot(cov,zeros(length(cov)),'b+');
legend('Truth','Pseudo-Inverse','Smoothness','Peroidicity');
title(sprintf('Case: N = %d, D = %d',rn,rd));




figure;
hold off; clf;
plot(ny_measles);
hold on
%plot(phat,'k')
%hold on;
plot(estimated_ny_measles,'g');
hold on
plot(smoothhat,'r')
%hold on;
%plot(cov,zeros(length(cov)),'b+');
legend('Truth','Muffle','Smoothness');
xlabel('Event ID')
ylabel('Count')
grid on
%hold on;
%plot(cov,zeros(length(cov)),'b+');
title(sprintf('Case: N = %d, D = %d',rn,rd));



end

