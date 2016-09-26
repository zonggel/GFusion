addpath('src');
addpath('data');

%specify your data here
load toy
events = toycount;
events(isnan(events)) = 0;
events = events(1:400);

%define lambda
lambdas = 10.^(-10:1:10);

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
Out = reconstruction( events, lambdas,config_rep_num,config_rep_dur,f_smooth,f_sparse,f_sp,'_nymeasle_' );



%function to generate 2-D plot/smoothing (the default)
%params_2D( Out, lambdas, xdim, ydim );
%function to generate 2-D plot/smoothing + periodic
params_2D_sp( Out,events, lambdas, xdim, ydim );

%function to generate 2-D plot
%params_2D( Out, lambdas, xdim, ydim );
%params_2D_sp( Out, events,lambdas, xdim, ydim )
