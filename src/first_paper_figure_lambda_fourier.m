function first_paper_figure_lambda_fourier(events, lambdas, rn, rd)
rep = 100;
recs = zeros(length(lambdas),2);
for r = 1:rep
    [A,y]=rep_gen(events, rn, rd);
    [smoothhat,~] = smooth_reconstruct(A, y,lambdas,events);
    %nfq = round(length(events)/2);
    nfq = 20;
    nhalf = round(nfq/2);

    for i = 1:length(lambdas)
        tempfft = fft(smoothhat(:,i));
        recs(i,1) = recs(i,1)+sum(abs(tempfft(1:nhalf)).^2);
        recs(i,2) = recs(i,2)+sum(abs(tempfft((nhalf+1):nfq)).^2);        
    end
end
recs = recs/100;
figure;subplot(2,1,1)
semilogx(lambdas,recs(:,1));
title('Lower Frequency')
xlabel('lambda')
ylabel('amplitude')
subplot(2,1,2)
semilogx(lambdas,recs(:,2));
title('Upper Frequency')
xlabel('lambda')
ylabel('amplitude')

figure;
semilogx(lambdas,recs(:,1)+recs(:,2));
title('Energy in Fourier space')
xlabel('lambda')
ylabel('amplitude')

end