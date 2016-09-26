function [ Out ] = reconstruction( events, lambdas,config_rep_num,config_rep_dur,f_smooth,f_sparse,f_sp,savelabel )
tic;
i = 1;

config_rns = size(config_rep_num,1);
config_rds = size(config_rep_dur,1);


for j_rn = 1:config_rns
     mu_rn = config_rep_num(j_rn,1);
     var_rn = config_rep_num(j_rn,2);
  for j_rd = 1:config_rds
       fprintf('looping %d %d\n',j_rn,j_rd);

       mu_rd = config_rep_dur(j_rd,1);
       var_rd = config_rep_dur(j_rd,2);

     % generate reports
     reports = collect_reports_norm(events, mu_rn, var_rn, mu_rd, var_rd);

     % generate characteristic linear system
     % corresponding to the reports
     [A,y]=rep_constraint_equations_full(reports,events); 

     % Out will store the experimental results
     Out(i).muvars = [ mu_rn, var_rn, mu_rd, var_rd];


     % use your smooth and lsq reconstruction functions to generate reconstructed events and reconstruction error
     if f_smooth == 1 
        [reconstracted_events, reconstruction_error] = smooth_reconstruct(A, y,lambdas,events);
        Out(i).smooth_reconstr = reconstracted_events;
        Out(i).smooth_error =  reconstruction_error;
     end
     
     if f_sparse == 1
        [reconstracted_events, reconstruction_error] = sparse_reconstruct(A, y,lambdas, events);
        Out(i).sparse_reconstr = reconstracted_events;
        Out(i).sparse_error =  reconstruction_error;
     end
     
     if f_sp == 1
        [reconstracted_events, reconstruction_error, reconstruction_param] = sp_reconstruct(A, y,lambdas, events);
        Out(i).sp_reconstr = reconstracted_events;
        Out(i).sp_error =  reconstruction_error;
        Out(i).sp_params = reconstruction_param;
     end
     [reconstracted_events, reconstruction_error] = lsq_reconstruct(A, y, events);

     Out(i).lsq_reconstr = reconstracted_events;
     Out(i).lsq_error =  reconstruction_error;
     
     i = i+1;
       %end
   end
end

file_name = strcat('Experiment',savelabel,num2str(now),'.mat');
save(file_name,'Out');
toc;
end

