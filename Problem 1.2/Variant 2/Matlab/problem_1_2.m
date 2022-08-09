close all
clear all
clc
format compact


S1 = [1   1   1   1;
      0  1/2  0   0;
      0   0   0   0];
  
S2 = [1   1   0   1;
      0  1/2  1   0;
      0   0   0   1];
  
  
  
for ii = 1:size(S1,2)
    disp(' ')
    disp('------------------------------------------------------')
    disp(['Iteration ' num2str(ii) ':'])
    s1 = S1(:,ii);  %s0, s1, s2
    s2 = S2(:,ii); %sa, sb, sc


    rxx_0 = sum(s1.^2);
    rxx_1 = s1(2)*s1(1)+s1(3)*s1(2);
    rxx_2 = s1(3)*s1(1);

    Rxx =  [rxx_0, rxx_1, rxx_2;
            rxx_1, rxx_0, rxx_1;
            rxx_2, rxx_1, rxx_0] %Sigma_u^2 is missing 


    p = [s1(1)*s2(1) +              s1(2)*(s2(1)/4+s2(2)) + s1(3)*(s2(2)/4+s2(3));
         s1(1)*(s2(1)/4+s2(2)) +    s1(2)*(s2(2)/4+s2(3)) + s1(3)*(s2(2)/4+s2(3));
         s1(1)*(s2(2)/4+s2(3)) +    s1(2)*s2(3)/4 + 0] %Sigma_u^2 is missing 


    c_opt = Rxx^(-1)*p
    
    %Sigma_u^2 is missing, but works just fine bc Sigma_U^2 = 1 for this
    %example
    syms Sigma_u_squared Sigma_w_squared
    Jmin_part_1 = ((s1(2) - s2(2))*(s1(1)/4 + (17*s1(2))/16 + s1(3)/4 - s2(1)/4 - (17*s2(2))/16 - s2(3)/4) + (s1(1) - s2(1))*((17*s1(1))/16 + s1(2)/4 - (17*s2(1))/16 - s2(2)/4) + (s1(3) - s2(3))*(s1(2)/4 + (17*s1(3))/16 - s2(2)/4 - (17*s2(3))/16));
    Jmin = Jmin_part_1 * Sigma_u_squared + sum(s2.^2) * Sigma_w_squared
    %Jmin is only correct if c_opt = h
    
    
    disp('------------------------------------------------------')
    
end