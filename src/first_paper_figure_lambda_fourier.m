function first_paper_figure_lambda_fourier(events, lambdas, rn, rd)
[A,y]=rep_gen(events, rn, rd);
[smoothhat,~] = smooth_reconstruct(A, y,lambdas,events);
figure
plot(abs(fft(smoothhat(:,1))))
figure
plot(abs(fft(smoothhat(:,11))))
figure
plot(abs(fft(smoothhat(:,end))))
figure
plot(abs(fft(events)))

end