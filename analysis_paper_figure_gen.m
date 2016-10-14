% analysis plot for practationer's guide
% lambda is fixed here, with 1 for smoothness, half-half for periodicity
addpath('src');
addpath('data');
load out
lambdas = 1;
alphas = 0.5;
% you may want to change alpha in sp_reconstruct function

load toy
events = toycount;
events(isnan(events)) = 0;
events = events(1:400);
%define rn/rd grid
config_rep_num = zeros(36,2);
config_rep_num(:,1) = 10:2:80;
config_rep_num(:,2) = 2;
config_rep_dur = zeros(36,2);
config_rep_dur(:,1) = 10:2:80;
config_rep_dur(:,2) = 2;
xdim = size(config_rep_num,1);
ydim = size(config_rep_dur,1);

%now reconstruction specify the method
f_smooth = 1;
f_sparse = 0;
f_sp = 1;
num_loop = 100;
% Out = loop_reconstruction( events, lambdas, alphas,config_rep_num,config_rep_dur, num_loop,f_smooth,f_sparse,f_sp,'loop_nymeasle_' );

%function to generate 2-D plot/smoothing + periodic
%params_2D_sp( Out,events, lambdas, xdim, ydim );
first_paper_figure_gen_group(Out, lambdas);
rn = 20;
rd = 20;
first_paper_figure_gen_case(events, lambdas,alphas, rn, rd);

% f_sp = 0;
% lambdas = 10.^(-10:1:10);
% config_rep_num = zeros(2,2);
% config_rep_num(:,1) = [40,80];
% config_rep_dur = zeros(2,2);
% config_rep_dur(:,1) =  [40,80];
% first_paper_figure_gen_lambda(events, lambdas, alphas,config_rep_num,config_rep_dur, num_loop,f_smooth,f_sparse,f_sp,'loop_nymeasle_');


% lambdas = 10.^(-10:1:10);
% first_paper_figure_lambda_fourier(events, lambdas, rn, rd);

addpath('src');
addpath('data');

lambdas = 1;
alphas = 0.5;
% you may want to change alpha in sp_reconstruct function

load toyfull
events = toycount;
events(isnan(events)) = 0;
rd = 200;
first_paper_figure_gen_scalarbility(events, lambdas, rd);

