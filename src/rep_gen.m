function [Aeq,beq] = rep_gen(events, mu_rn, mu_rd)
%For each report generate consistency constraint equation based on events covered by that report. 
% Ie, each x variable corresponds to a time unit.
num_of_reports = mu_rn;
if num_of_reports <= 0 
   num_of_reports = 1;
end
reported_duration = mu_rd;
if reported_duration <= 0
  reported_duration = 1;
end  

num_all_possible_reports = length(events) - reported_duration + 1;
if num_all_possible_reports<num_of_reports
    fprintf('Fail to build the reports, asking for too many')
end

Aall = zeros(num_all_possible_reports, length(events));

for i = 1:num_all_possible_reports
    Aall(i,i:(i+reported_duration-1)) = 1;    
end
ball = Aall*events;
%save('note.mat','Aall','events','ball','reported_duration', 'num_of_reports','num_all_possible_reports')
selected = randsample(num_all_possible_reports,num_of_reports);
Aeq = Aall(selected,:);
beq = ball(selected);

end