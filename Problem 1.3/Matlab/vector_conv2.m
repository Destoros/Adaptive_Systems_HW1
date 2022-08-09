 function y = vector_conv2(x, h)
% computes the convolution of x and the coefficients of h at time
% instance n for every n

 y = zeros(length(x),1);
 
 for n = 1:length(x)
	temp = conv(x,h(:,n)); 
    y(n) = temp(n);
 end
 
 end