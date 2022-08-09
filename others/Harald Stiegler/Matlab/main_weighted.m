%Adaptive Systems, Assignment 1, Task 1.4 b/c
%Harald Stiegler, 9330054
clear all;
close all;
clc;

%1.4.b/c
N=3;
sample_count=1000;
sample_count_zero_based=sample_count-1;
theta=3*pi/100;%modified from task 1.3
h_1=-1+zeros(1,sample_count);
h_2=2-0.97.^(0:sample_count_zero_based);
h_3=0.3*cos(theta.*(0:sample_count_zero_based));

h=[h_1;h_2;h_3];
x_axis=randn(1,sample_count);

figure;
plot(1:sample_count,h);
axis([1 sample_count -1.5 2.5]);
legend('h1[n]', 'h2[n]', 'h3[n]');
title('Coefficients h[n]');
xlabel('Time [n]');
ylabel('Absolute Coefficient values');
saveas(gcf,'coefficients_h','eps');

for task=1:2
    if (task==1)
        %No noise is added,w[n]=0
        sigma_w_sq=1.0;
        w=zeros(1,sample_count);
        noise_title="No noise";
    else
        %White gaussian noise is added, sigma_w_sq=0.02
        sigma_w_sq=0.02;
        w=sqrt(sigma_w_sq).*randn(1,sample_count);
        %var_w=var(w) %debug output
        noise_title=sprintf("White Gaussian Noise \\mu=0,\\sigma_w^2=%f", sigma_w_sq);
    end
    d_axis=[];
    for n=1-N+1:sample_count-N+1
        data_segment=get_segment(x_axis,N,n);%data_segment is sliding_window starting at time index 2-N
        h_segment=h(:,n+N-1);%copy appropriate h column
        d_tmp = transpose(h_segment)*data_segment;
        d_axis=[ d_axis d_tmp ];
    end
    d_axis=d_axis+w;

    %debug output
    %figure;
    %plot(1:length(d_axis),d_axis);
    %title('d');
    
    %left from task 1.3. c/d compare M=20,M=50
    %for M=20:30:50
    %task 1.4 perform lambda survey 1.1 - 1.6, which value fits best
    for (lambda_iter=1:6)
        M=50;
        N=3;
        c_axis_weighted=[];
        c_axis_ls=[];
        lambda_value=1.0+lambda_iter/10;%1.1 1.2 1.3... (values <1.0 do not make sense)
        for n=1-M+1:sample_count-M+1
            data_segment=flip(get_segment(x_axis,M,n));
            d_segment=flip(get_segment(d_axis,M,n));
            g=0:M-1;
            g=power(1.0/lambda_value,g);%g is plotted below
            
			%compute weighted and unweighted coefficients for comparison afterwards
            c_weighted=ls_filter_weighted(data_segment,d_segment,N,g);
            c_ls = ls_filter(data_segment, d_segment, N);
            
            c_axis_weighted=[c_axis_weighted c_weighted];%I do not know anything about efficiency of this construct, but I understand it (at least)
            c_axis_ls=[c_axis_ls c_ls];
        end 

		%plot g over time (weighting errors)
        figure;
        plot(1:length(g),g,'Color','blue');
        weight_title_string=sprintf("Weighting by \\lambda=%f",lambda_value);
        title(weight_title_string);
        xlabel('Sliding Window length [m]');
        ylabel('1.0/\lambda^m');
        filename=sprintf('weighting_lambda_%f',lambda_value);
        saveas(gcf,filename,'bmp');
        
		%plot wanted coefficients h, plot approximated c (unweighted (c_axis_ls) and weighted (c_axis_weighted) for comparison)
        figure;
        plot(1:length(h),h,'Color','red');
        hold on;
        plot(1:length(c_axis_ls),c_axis_ls,'Color','blue');
        hold on;
        plot(1:length(c_axis_weighted),c_axis_weighted,'Color','green');
        hold off;
        axis([1 sample_count -1.5 2.5]);
        legend('h0','h1','h2','c0_L_S', 'c1_L_S', 'c2_L_S', 'c0_w_L_S', 'c1_w_L_S','c2_w_L_S');
        title_string=sprintf('c_L_S vs c_w_L_S\n\\lambda=%f, M=%d, %s',lambda_value, M, noise_title);
        title(title_string);
        xlabel('Time [n]');
        ylabel('Absolute Coefficient Values');
        filename=sprintf("task14_ls_wLS_lambda_%f_M_%d_sigma_sq_%f",lambda_value,M,sigma_w_sq);
        saveas(gcf,filename,'bmp');
    end
end

%copied from main.m
function segment = get_segment(x,desired_seg_len,n)
    x=x(:);
    if n<1
       x_sliding_window=zeros(1,desired_seg_len);
       negative_time_length=-n+1;
       x_sliding_window(negative_time_length+1:desired_seg_len)=x(1:n+desired_seg_len-1);
       x_sliding_window=transpose(x_sliding_window);
    else
        x_sliding_window=x(n:n+desired_seg_len-1);
    end
    segment = flip(x_sliding_window);
end

