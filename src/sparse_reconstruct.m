function [recon_events, recon_error]=sparse_reconstruct(A, y,sparse_lambdas,events)
[sparsehat,~] = lasso(A,y,'lambda',sparse_lambdas);
recon_events = sparsehat;
recon_error = mean((recon_events - repmat(events,1,length(sparse_lambdas))).^2,1);
end