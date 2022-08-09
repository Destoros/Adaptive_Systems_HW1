function y = vector_conv(x, h)
%calcultes the concolution sum defined in Adaptive System UE
%
%x has to be a column vector in form of
% x = x[0];  
%     x[1]; 
%      ...; 
%     x[n-1] 
% 
%where n is the time variable


%h has to be matrix in the form of
% h = h1[0], h1[1], ..., h1[n-1];
%     h2[0], h2[1], ..., h2[n-1];
%     h3[0], h3[1], ..., h3[n-1]


x = x(:); %make sure that x is a col vector


N = size(h,1);


t = 1;
n = 0:length(x)-1;
x_zero_pad = [zeros(N-1,1); x]; %puts zeros for time x[-1], x[-2], ... x[-N+1]

y = zeros(length(n),1);
for n_shift = n + N    
    x_tap_input = x_zero_pad(n_shift:-1:n_shift-N+1);
    y(t) = h(:,t)' * x_tap_input; % ' is hermitian transposed
    t = t+1;
end


end