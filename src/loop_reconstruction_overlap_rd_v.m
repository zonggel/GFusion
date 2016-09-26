function [ Out ] = loop_reconstruction_overlap_rd_v( events, lambdas,configs,num_loop, f_smooth,f_sparse,f_pd,savelabel )
tic;
i = 1;

for icfg = 1:size(configs,1)
           mu_rd = configs(icfg,2);
           nlap = configs(icfg,3);
           rlap = configs(icfg, 1);
       
           perror = 0;
           smerror = 0;
           sperror = 0;
           pderror = 0;
           perrors = zeros(num_loop,1);
           
           smerrors = zeros(num_loop,1);
           smparams = zeros(num_loop,1);
           smerrors2 = zeros(num_loop,1);
           smparams2 = zeros(num_loop,1);
           smerrorsall = zeros(num_loop,length(lambdas));
           smrec = zeros(num_loop, length(events));
     
           sperrors = zeros(num_loop,1);
           spparams = zeros(num_loop,1);
           
           pderrors = zeros(num_loop,1);
           pdparams = zeros(num_loop,2);
           for ii = 1:num_loop                        
                        
                    reported_duration = mu_rd;
                    if reported_duration <= 0
                      reported_duration = 1;
                    end  
                    nindent = reported_duration - nlap;
                    num_all_possible_reports = floor((length(events) - reported_duration)/nindent) + 1;
                    Aall = zeros(num_all_possible_reports, length(events));

                    for irep = 1:num_all_possible_reports
                        Aall(irep,(1+(irep-1)*nindent):(1+(irep-1)*nindent+reported_duration-1)) = 1;    
                    end
                    ball = Aall*events;
                    A = Aall;
                    y = ball;
                      
                 % Out will stor the experimental results

                 if f_smooth == 1 
                    [reconstruction_events, reconstruction_error] = smooth_reconstruct(A, y,lambdas,events);
                    [minval, mini] = min(reconstruction_error);
                    smerror = smerror +   minval;
                    smerrorsall(ii,:) = reconstruction_error;
                    smrec(ii,:) = reconstruction_events(:,mini);
                    [smerrors(ii),smparams(ii)] = min(reconstruction_error);
                    [smerrors2(ii),smparams2(ii)] = max(reconstruction_error);
                 end

                 if f_sparse == 1
                    [~, reconstruction_error] = sparse_reconstruct(A, y,lambdas, events);
                    sperror = sperror + min(reconstruction_error);
                     [sperrors(ii),spparams(ii)] = min(reconstruction_error);
                 end

                 if f_pd == 1
                    [~, reconstruction_error, reconstruction_param] = sp_reconstruct(A, y,lambdas, events);
                    pderror = pderror + min(reconstruction_error(:));
                    [pderrors(ii),minid] =  min(reconstruction_error(:));
                    [~,mi2,mi3] = ind2sub(size(reconstruction_error),minid);
                    pdparams(ii,:) = reconstruction_param(:,mi2,mi3);
                 end

                 [~, reconstruction_error] = lsq_reconstruct(A, y, events);
                 perror = perror + min(reconstruction_error); 
                 perrors(ii) =  reconstruction_error;
              
           end  
           perror = perror/num_loop;
           pderror = pderror/num_loop;
           sperror = sperror/num_loop;
           smerror = smerror/num_loop;
           Out(i).smerror =  smerror;
           Out(i).sperror =  sperror;
           Out(i).perror =  perror;
           Out(i).pderror = pderror;
           Out(i).perrors = perrors;
           Out(i).smerrorsall = smerrorsall;
           Out(i).smerrors = smerrors;
           Out(i).smparams = smparams;
           Out(i).smerrors2 = smerrors2;
           Out(i).smparams2 = smparams2;
           Out(i).smrec = smrec;
           
           Out(i).sperrors = sperrors;
           Out(i).spparams = spparams;
           
           Out(i).pderrors = pderrors;
           Out(i).pdparams = pdparams;
           muvars = [ num_all_possible_reports, mu_rd, nlap,rlap];

           Out(i).muvars = muvars;
       
       
     
          i = i+1;
          %end
end


file_name = strcat('sim_rd_overlap_study',savelabel,num2str(now),'.mat');
save(file_name,'Out');
toc;
end

