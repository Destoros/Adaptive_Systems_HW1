function c = ls_filter_weighted(x, d, N, lambda)
%computes the filter coefficients c for one time instance n, where
%corresponds to the last entry of x

% x is the input signal saved as col vector
% d is the reference signal saved as col vector
% N is the order of the filter i.e. the amount of coefficients in c

% Matrix X to compute the coefficients at time instance n
% X = [x[n-M+N],   x[n-M+N-1],  ..., x[n-M];
%      x[n-M+N+1], x[n-M+N],    ..., x[n-M+1];
%      ...                      ...,
%      x[n],       x[n-1]       ..., x[n-N+1] ]; 
      
% Make sure x and d are col vectors
% x = x(:);
% d = d(:);

if isrow(x) || isrow(d)
    error('vector x or vector d is not a column vector')
end

M = length(x); %segment length

X = zeros(M-N+1,N); %create placeholder for entries of X

for ii = 0:N-1 %for order N coefficients of c we need N cols
    X(:,ii+1) = x( (end-M+N)-ii:end-ii ); %end corresponds to current time n
end                                       %to include M-N+1 we have to substract -M+N


%compute the weighting matrix
% lambda = 1.5;
m = 0:-1:-(M-N);
g = lambda.^m;
G = diag(flip(g)); %flip because of form of matrix G (from g[n - k])

%compute coefficients with weighted input

c = (X.' * G * X)^-1 * X.' * G * d(end-M+N:end);

end