%Adaptive Systems, Assignment 1, Task 1.3
%Harald Stiegler, 9330054

function c = ls_filter(x,d,N)
x=x(:);%enforce x to be a column
d=d(:);%enforce d to be a column
if (N<0)
    error('ls_filter: param N < 0!');
end
if (length(d)~=length(x))
    error('ls_filter: length(x)=%d,length(d)=%d! x,d must be of equal length!',length(x),length(d));
end
M=length(x);
X=zeros(M,0);%create empty matrix of size Mx0
shifted_x=x;%initialize for first loop run
for (i=1:N)
    X=[X shifted_x];%%append column
    shifted_x=zeros(size(x));%shifting scalars in column vector x downwards by one, append 0 on top, semantics: initialize data elements (x) in past by 0
    shifted_x(i+1:end)=x(1:end-i);%sorry for being a Matlab newbie, I think there will be a much nicer way to get data shifted
end

X_transp=transpose(X);
X_pseudo_inverse=inv(X_transp*X);
c= X_pseudo_inverse*X_transp*d; %optimal c coefficients for LS-criterion derived from all available samples in X
size(c);%debug output
size(d);%debug output
end

