addpath('src');
addpath('data');

%specify your data here
load toy
events = toycount;
events(isnan(events)) = 0;
events = events(1:400);

%define lambda
lambdas = 10.^(-10:1:10);
alphas = 0.1:0.1:0.9;

%define rn/rd grid
config_rep_num = zeros(33,2);
config_rep_num(:,1) = 8:1:40;
config_rep_num(:,2) = 2;
config_rep_dur = zeros(33,2);
config_rep_dur(:,1) = 8:1:40;
config_rep_dur(:,2) = 2;
xdim = size(config_rep_num,1);
ydim = size(config_rep_dur,1);

%now reconstruction specify the method
f_smooth = 1;
f_sparse = 1;
f_sp = 1;

num_loop = 100;
Out = loop_reconstruction( events, lambdas, alphas,config_rep_num,config_rep_dur, num_loop,f_smooth,f_sparse,f_sp,'loop_nymeasle_' );

%function to generate 2-D plot
%params_2D( Out, lambdas, xdim, ydim );
%params_2D_sp( Out, events,lambdas, xdim, ydim )
