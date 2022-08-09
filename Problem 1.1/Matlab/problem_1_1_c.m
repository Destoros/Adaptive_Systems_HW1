close all
clear all
clc



syms a Sigma_w theta_0
rxx = @(k) a^2*exp(1i*theta_0*k) + Sigma_w^2*kroneckerDelta(sym(k));

for N = 1:4
    for ii = 1:N %row
        for jj = 1:N %col
           A(ii,jj) = rxx(jj-ii);        
        end 
    end
    disp(['N = ' num2str(N)])
    disp('det(A) = '); fprintf('\b');
    disp(det(A))
end 