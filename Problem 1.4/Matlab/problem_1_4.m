close all
clear all
clc

%suppres: "Warning: Matrix is singular to working precision."
id = 'MATLAB:singularMatrix'; 
warning('off',id) 

%suppres: "Warning: Directory already exists."
id = 'MATLAB:MKDIR:DirectoryExists';
warning('off',id) 

mkdir 'Figures'

%--------------------------------------------------------------------------
% calculate h
theta = 3*pi/100; %change theta from problem 1.3
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
% weighted system identification
N = 3; %3 filter coefficients in h and c

x = randn(1,length(n)).'; %x[n] = 0 for n < 0 (or 1 in matlab)

d = vector_conv(x, h);

%create white gaussian noise and change variance
w = transpose(randn(1,length(n)))./(1/sqrt(0.02)); 

d = d + w;% add noise after filter h


for lambda = 1.05:0.3:2

    for M = [50]
        x_pad = [zeros(M-1,1); x]; %pad with M-1 zeros; x[n] = 0 for n < 0;
        d_pad = [zeros(M-1,1); d]; %and pad d too for the newly created values of x[n]

        c = zeros(N,length(n));
        for ii = n %ii is counts through the time n
            c(:,ii+1) = ls_filter_weighted(x_pad(ii+1:M+ii), d_pad(ii+1:M+ii), N, lambda);
        end


        text = ['Coefficients c[n] with white noise \sigma_w = ' num2str(round(var(w),2)) ' for M = ' num2str(M) ' and \lambda = ' num2str(lambda)];
        text_saveas = ['Coefficients_c_with_noise_M=' num2str(M) '_and_lambda=' strrep(num2str(lambda),'.','_')];


        figure
            plot(n,c)
            hold on
            plot(n,h, '--k')
            legend('c_1[n]','c_2[n]','c_3[n]', 'h_i[n]')  
            grid on
            title(text)
            xlabel('time n')
            ylim([-1.5, 2.5])  %due to some singularities, the first values
    %                           of c can get quite big -> ruins the plot -> 
    %                           limit it
            saveas(gcf,['Figures/' text_saveas] ,'epsc') %epsc to save the eps in colour


    end  %for M  

end %for lambda

%create a placeholder function to overwrite the saveas function
function saveas(~, ~, ~)
    disp('Figure not saved')
end


    