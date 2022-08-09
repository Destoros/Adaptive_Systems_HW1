close all
clear all
clc

%suppres: "Warning: Matrix is singular to working precision."
id = 'MATLAB:singularMatrix'; 
warning('off',id) 

%suppres: "Warning: Directory already exists."
id = 'MATLAB:MKDIR:DirectoryExists';
warning('off',id) 

mkdir 'Figures' %create Figures folder



%--------------------------------------------------------------------------
% a)
N = 2;
d = [-3; -5; 0]; %values from example 1.1
x = [-1; -1; 1];




k = N-1; %Pad with N - 1 zeroes for the values of x[-1], x[-2], ... x[-N+1]
x_pad = [zeros(k,1); x];
d_pad = [zeros(k,1); d]; 


c = ls_filter(x_pad, d_pad, N)

%"Probe"
d_hat = conv(x,c);
d_hat = d_hat(1:length(x)) %delete the values which assume that 
%                           x[n] = 0 for n > length(x)



%--------------------------------------------------------------------------
% b)
theta = 3*pi/1000;
n = 0:999;

h = [-1*ones(1,length(n)); 2-0.97.^n; 0.3*cos(theta*n)];    
%h = h1[0], h1[1], ..., h1[n];
%    h2[0], h2[1], ..., h2[n];
%    h3[0], h3[1], ..., h3[n];


figure
    plot(n,h)
    legend('h_1[n]','h_2[n]','h_3[n]')  
    grid on
    ylim([-1.5 2.5])
    title('Coefficients h[n]')
    xlabel('time n')
    
    saveas(gcf,'Figures/Coefficients_h', 'epsc')
    
%--------------------------------------------------------------------------
% c) and d)
N = 3; %3 filter coefficients in h and c

x = randn(1,length(n)).'; %x[n] = 0 for n < 0 (or 1 in matlab)

d = vector_conv(x, h);
% d_test = vector_conv2(x, h)
% e_test = d - d_test
counter = 1;
for jj = 1:2
    
    if jj == 1
        w = 0;
    else
        %create white gaussian noise and change variance
        w = transpose(randn(1,length(n)))./(1/sqrt(0.02)); 
    end

    d = d + w;% add noise after filter h


    for M = [20, 50]
        x_pad = [zeros(M-1,1); x]; %pad with M-1 zeros; x[n] = 0 for n < 0;
        d_pad = [zeros(M-1,1); d]; %and pad d too for the newly created values of x[n]

        c = zeros(N,length(n));
        for ii = n %ii is counts through the time n
            c(:,ii+1) = ls_filter(x_pad(ii+1:M+ii), d_pad(ii+1:M+ii), N);
        end


        if w == 0
            text = ['Coefficients c[n] w/o noise for M = ' num2str(M)];
            text_saveas = ['Coefficients_c_without_noise_M=' num2str(M)];
        else
            text = ['Coefficients c[n] with white noise \sigma_w = ' num2str(round(var(w),2)) ' for M = ' num2str(M)];
            text_saveas = ['Coefficients_c_with_noise_M=' num2str(M)];
        end

        figure
            plot(n,c)
            hold on
            plot(n,h,'--k')
            legend('c_1[n]','c_2[n]','c_3[n]','h_i[n]')  
            grid on
            title(text)
            xlabel('time n')
            ylim([-1.5, 2.5]) %due to some singularities, the first values
%                              of c can get quite big -> ruins the plot -> 
%                              limit it
            saveas(gcf,['Figures/' text_saveas] ,'epsc') %epsc to save the eps in colour

        c_plot(:,:,counter) = c;
        counter = counter + 1;
    end  %for M  
    
end %for jj

kk = 1;
X = [1; 1; 1; 1; 1]* n;
Y = [0; -1; -2; -3; -4]*ones(1,length(n));

for kk = 1:3
Z = [h(kk,:); c_plot(kk,:,1); c_plot(kk,:,2); c_plot(kk,:,3); c_plot(kk,:,4)];
%c_plot(kk,:,1) has the coefficients for M = 20, w = 0;
%c_plot(kk,:,2) has the coefficients for M = 50, w = 0;
%c_plot(kk,:,3) has the coefficients for M = 20, w ~= 0;
%c_plot(kk,:,4) has the coefficients for M = 50, w ~= 0;

 text_saveas = ['waterfall_coefficients_' num2str(kk)];

figure
    waterfall(X,Y,Z)
    zlim([-1.5, 2.5])
    xlabel('n')
    zlabel(['coefficients h_' num2str(kk) ' and c_' num2str(kk)])
    ylabel('h | M = 20 & w = 0 |  M = 50 & w = 0 |  M = 20 & w ~= 0 |  M = 50 & w  ~= 0;')
    saveas(gcf,['Figures/' text_saveas] ,'epsc') %epsc to save the eps in colour
end    


%create a placeholder function to overwrite the saveas function
function saveas(~, ~, ~)
    disp('Figure not saved')
end


%seen from plots: 
%w[n] = 0:
%theres only little difference between M = 20 and M = 50 and 
%the values of c correspond quite well to the values of h, 
%altough the plot is a bit shifted(increses with segment 
%length M). The first values of c are also not quite the same 
%as h, due to the assumption that x[n] = 0, for n < 0 and the 
%first c[n] gets computed with only one entry which is not 0;
%
%w[n] ~= 0:
%between M = 20 and M = 50 is a lot of difference now. Probably 
%due to the higher amount of samples, the noise cancels out 
%(and would fully cancel for M -> infty(because white noise), 
%but then the adaptiveness of system would get lost -> c[n] would 
%get constant if every x[n] is taken into account)

    