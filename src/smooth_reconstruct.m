function [recon_events, recon_error]=smooth_reconstruct(A, y,smooth_lambdas,events)
smoothhat = zeros(length(events),length(smooth_lambdas));
for i=1:length(smooth_lambdas)
    lambda_s = smooth_lambdas(i);
    smoothhat(:,i) = opt_smooth(A,y,lambda_s);
end
recon_events = smoothhat;
recon_error = mean((recon_events - repmat(events,1,length(smooth_lambdas))).^2,1);
end