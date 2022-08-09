close all
clear all
clc
format loose


% syms h0 h1  h2
syms c0 c1 c2

syms u0 u1 u2 u3 u4

syms s1l1r s1l2r s1l3r 
syms s2l1r s2l2r s2l3r

syms w0 w1 w2

s_1 = [s1l1r; s1l2r; s1l3r];
s_2 = [s2l1r; s2l2r; s2l3r];

c = [c0; c1; c2];

w = [w0; w1; w2];

h = [1; 1/4; 0];




U = [u0, u1, u2;
     u1, u2, u3;
     u2, u3, u4];
 
 
 test = (s_2.'*U*h + s_2.'*w - c.'*U*s_1)^2
 
 
 
(s2l1r*u0 + (s2l1r*u1)/4 + s2l2r*u1 + (s2l2r*u2)/4 + s2l3r*u2 + (s2l3r*u3)/4 + s2l1r*w0 + s2l2r*w1 + s2l3r*w2 - s1l1r*(c0*u0 + c1*u1 + c2*u2) - s1l2r*(c0*u1 + c1*u2 + c2*u3) - s1l3r*(c0*u2 + c1*u3 + c2*u4))^2
 
 
 U*h*h.'*U
 
 
 A_div_Sigma_u_squared =  [ 1+ 1/16,    1/4,     0;
                            1/4,        1+ 1/16, 1/4;
                             0,          1/4,     1+ 1/16];
    
 one_part_Jmin_div_Sigma_u_squared = (s_2 - s_1).' * A_div_Sigma_u_squared * (s_2 - s_1); 
 
 text1 = char(one_part_Jmin_div_Sigma_u_squared); %text for first part
 
 text1 = strrep(text1, 'l', '(');
 text1_div_Sigma_u_squared = strrep(text1, 'r', ')') %this can be copied directly into the matlab file Analytical_1_2 and has the right format for the given coefficents s
 
 text2_div_Sigma_w_squared = 'sum(s2.^2)'
 