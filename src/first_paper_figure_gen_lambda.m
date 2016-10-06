function first_paper_figure_gen_lambda( events, lambdas, alphas,config_rep_num,config_rep_dur,num_loop, f_smooth,f_sparse,f_pd,savelabel )


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
       
           perrors = zeros(num_loop,1);
           
           smerrors = zeros(num_loop,1);
           smparams = zeros(num_loop,1);
           smerrors_all = zeros(num_loop,length(lambdas));
           
           sperrors = zeros(num_loop,1);
           spparams = zeros(num_loop,1);
           
           pderrors = zeros(num_loop,1);
           pdparams = zeros(num_loop,2);
           muvars = [ mu_rn, var_rn, mu_rd, var_rd];
           for ii = 1:num_loop
               
                         [A,y] = rep_gen(events, mu_rn, mu_rd);                        
                         % Out will stor the experimental results
                         
                         if f_smooth == 1 
                            [~, reconstruction_error] = smooth_reconstruct(A, y,lambdas,events);
                            smerrors_all(ii,:) = reconstruction_error;
                            [smerrors(ii),smparams(ii)] = min(reconstruction_error);
                         end

                         if f_sparse == 1
                            [~, reconstruction_error] = sparse_reconstruct(A, y,lambdas, events);
                             [sperrors(ii),spparams(ii)] = min(reconstruction_error);
                         end

                         if f_pd == 1
                            [~, reconstruction_error, reconstruction_param] = sp_reconstruct(A, y,lambdas, alphas, events);
                            [pderrors(ii),minid] =  min(reconstruction_error(:));
                            [~,mi2,mi3] = ind2sub(size(reconstruction_error),minid);
                            pdparams(ii,:) = reconstruction_param(:,mi2,mi3);
                         end
                         
                         [~, reconstruction_error] = lsq_reconstruct(A, y, events);
                         perrors(ii) =  reconstruction_error;

               
           end  

           Out(i).perrors = perrors;
           
           Out(i).smerrors = smerrors;
           Out(i).smerrors_all = smerrors_all;
           Out(i).smparams = smparams;
           
           Out(i).sperrors = sperrors;
           Out(i).spparams = spparams;
           
           Out(i).pderrors = pderrors;
           Out(i).pdparams = pdparams;
           Out(i).muvars = muvars;
       
       
     
     i = i+1;
       %end
   end
end



figure
for i = 1:length(Out)
    subplot(2,2,i)
    semilogx(lambdas, mean(Out(i).smerrors_all));
    hold on
    y1=get(gca,'ylim');
    plot([1  1],y1);
    xlabel('lambda')
    ylabel('MSE')
    legend('smoothness','lambda=1','Location','northwest');
    title(sprintf('rn=%d,rd=%d',Out(i).muvars(1),Out(i).muvars(3)))
end
end