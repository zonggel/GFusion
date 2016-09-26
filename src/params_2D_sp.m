function params_2D_sp( Out, real_events,lambdas, xdim, ydim )
totalnum = length(Out);
maxarray = zeros(totalnum,1);
maxval = zeros(totalnum,1);
minarray = zeros(totalnum,1);
minval = zeros(totalnum,1);

maxarray21 = zeros(totalnum,1);
maxarray22 = zeros(totalnum,1);
maxval2 = zeros(totalnum,1);
minarray21 = zeros(totalnum,1);
minarray22 = zeros(totalnum,1);
minval2 = zeros(totalnum,1);

Xs = zeros(totalnum,1);
Ys = zeros(totalnum,1);
for i = 1:length(Out)
    tempout = Out(i);
    % cut the first 2 to void numerical underflow
    %tempout.smooth_error = tempout.smooth_error(3:end);
    [tempmin,minid] = min(tempout.smooth_error);
    [tempmax,maxid] = max(tempout.smooth_error); 
    maxarray(i) = lambdas(maxid);
    maxval(i) = tempmax;
    minarray(i) = lambdas(minid);
    minval(i) = tempmin;
    
    [tempmin2,minid2] = min(tempout.sp_error(:));
    [~,mi2,mi3] = ind2sub(size(tempout.sp_error),minid2);
    [tempmax2,maxid2] = max(tempout.sp_error(:)); 
    [~,ma2,ma3] = ind2sub(size(tempout.sp_error),maxid2);

    maxarray21(i) = tempout.sp_params(1,ma2,ma3);
    maxarray22(i) = tempout.sp_params(2,ma2,ma3);
    maxval2(i) = tempmax2;
    minarray21(i) = tempout.sp_params(1,mi2,mi3);
    minarray22(i) = tempout.sp_params(2,mi2,mi3);
    minval2(i) = tempmin2;
    
    Xs(i) = tempout.muvars(1);
    Ys(i) = tempout.muvars(3);
% the following code check the lambda-MSE shape
%     if Xs(i) == 100 && Ys(i)==400
%          figure;
%          semilogx(lambdas,tempout.smooth_error);
%      end
    if Xs(i) == 15 && Ys(i)==15
         figure;
         plot(real_events);
         hold on
         plot(tempout.sp_reconstr(:,mi2,mi3));
         hold on
         plot(tempout.smooth_reconstr(:,minid));
         hold on
         plot(tempout.smooth_reconstr(:,1));
         hold on
         plot(tempout.lsq_reconstr);
         legend('real','Periodicity','smooth(best)','smooth(extra small lambda)','peudo-inverse');
         title(sprintf('case rn=%d, rd= %d',Xs(i),Ys(i)));
     end
end
Xs = reshape(Xs,xdim,ydim);
Ys = reshape(Ys,xdim,ydim);


logmaxarray = log(maxarray);
logminarray = log(minarray);
maxval = reshape(maxval,xdim,ydim);
minval = reshape(minval,xdim,ydim);
logmaxarray = reshape(logmaxarray,xdim,ydim);
logminarray = reshape(logminarray,xdim,ydim);

figure;
subplot(1,2,1);
pcolor(Xs,Ys,maxval);
colorbar;
xlabel('RN');
ylabel('RD');
title('maximum MSE');
subplot(1,2,2);
pcolor(Xs,Ys,logmaxarray);
colorbar;
xlabel('RN');
ylabel('RD');
title('corresponding log(lambda)');


figure;
subplot(1,2,1);
pcolor(Xs,Ys,minval);
colorbar;
xlabel('RN');
ylabel('RD');
title('Smooth Minimum MSE');
subplot(1,2,2);
pcolor(Xs,Ys,logminarray);
colorbar;
xlabel('RN');
ylabel('RD');
title('corresponding log(lambda)');

%peroidicity constraint
tempmaxarray21 = maxarray21.*maxarray22;
tempminarray21 = minarray21.*minarray22;

%smooth constraint
tempmaxarray22 = maxarray21.*(ones(size(maxarray22))-maxarray22);
tempminarray22 = minarray21.*(ones(size(minarray22))-minarray22);

logmaxarray21 = log(tempmaxarray21);
logminarray21 = log(tempminarray21);
maxval2 = reshape(maxval2,xdim,ydim);
minval2 = reshape(minval2,xdim,ydim);
logmaxarray21 = reshape(logmaxarray21,xdim,ydim);
logminarray21 = reshape(logminarray21,xdim,ydim);

logmaxarray22 = log(tempmaxarray22);
logminarray22 = log(tempminarray22);
logmaxarray22 = reshape(logmaxarray22,xdim,ydim);
logminarray22 = reshape(logminarray22,xdim,ydim);

figure;
subplot(1,3,1);
pcolor(Xs,Ys,maxval2);
colorbar;
xlabel('RN');
ylabel('RD');
title('Peroidicity Maximum MSE');
subplot(1,3,2);
pcolor(Xs,Ys,logmaxarray21);
colorbar;
xlabel('RN');
ylabel('RD');
title('corresponding log(lambda1)');
subplot(1,3,3);
pcolor(Xs,Ys,logmaxarray22);
colorbar;
xlabel('RN');
ylabel('RD');
title('corresponding log(lambda2)');


figure;
subplot(1,3,1);
pcolor(Xs,Ys,minval2);
colorbar;
xlabel('RN');
ylabel('RD');
title('Peroidicity Minimum MSE');
subplot(1,3,2);
pcolor(Xs,Ys,logminarray21);
colorbar;
xlabel('RN');
ylabel('RD');
title('corresponding log(lambda1)');
subplot(1,3,3);
pcolor(Xs,Ys,logminarray22);
colorbar;
xlabel('RN');
ylabel('RD');
title('corresponding log(lambda2)');

mflag = double(minval2<minval);
figure;
pcolor(Xs,Ys,mflag);
colorbar;
xlabel('RN');
ylabel('RD');
title('Peroidicity Assumption Better');

end

