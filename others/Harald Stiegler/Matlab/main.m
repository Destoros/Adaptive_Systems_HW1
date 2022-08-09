%Adaptive Systems, Assignment 1, Task 1.3
%Harald Stiegler, 9330054
clear all;
close all;
clc;


%example from lecture, simple test
N=2;
d=[-3 -5 0];
x=[-1 -1 1];
ls_filter(x,d,N);

%Task 1.3, for both b and c
N=3;
sample_count=1000;
sample_count_zero_based=sample_count-1;
theta=3*pi/sample_count;
h_1=-1+zeros(1,sample_count);
h_2=2-0.97.^(0:sample_count_zero_based);
h_3=0.3*cos(theta.*(0:sample_count_zero_based));

h=[h_1;h_2;h_3];
x_axis=randn(1,sample_count);

%plot impulse response of "unknown" system, this impulse response (consisting of 3 coeffs) will be approximated by adaptive filter afterwards
figure;
plot(1:sample_count,h);
axis([1 sample_count -1.5 2.5]);
legend('h1[n]', 'h2[n]', 'h3[n]');
title('Coefficients h[n]');
xlabel('Time [n]');
ylabel('Absolute Coefficient values');
saveas(gcf,'coefficients_h','bmp');

for task=1:2
    if (task==1)
        %scenario: no additional noise (task 1.3.b)
        sigma_w_sq=1.0;
        w=zeros(1,sample_count);
        noise_title="No noise";
    else
        %scenario: with white noise (task 1.3.c)
        sigma_w_sq=0.02;
        w=sqrt(sigma_w_sq).*randn(1,sample_count);
        var_w=var(w);%debug
        noise_title=sprintf("White Gaussian Noise \\mu=0,\\sigma_w^2=%f", sigma_w_sq);
    end
    d_axis=[];%initialize empty vector
    for n=1-N+1:sample_count-N+1
        data_segment=get_segment(x_axis,N,n);%data_segment is sliding_window
        h_segment=h(:,n+N-1);%copy appropriate h column
        d_tmp=transpose(h_segment)*data_segment;
        d_axis=[ d_axis d_tmp ];%append to d_axis
    end
    d_axis=d_axis+w;%add noise if present (relevant for task 1.3.c)

%task 1.3.c, compare coefficients for different M=20,50. Loop runs twice, once M=20, once M=50
    for M=20:30:50
        N=3;
        c_axis=[];
        for n=1-M+1:sample_count-M+1
            data_segment=flip(get_segment(x_axis,M,n));
            d_segment=flip(get_segment(d_axis,M,n));
            c_segment=ls_filter(data_segment,d_segment,N);
            c_axis=[c_axis c_segment];
        end 

        figure;
        plot(1:length(c_axis),c_axis);
        axis([1 sample_count -1.5 2.5]);
        legend('c0[n]', 'c1[n]', 'c2[n]');
        title_string=sprintf('Coefficients c[n], M=%d, %s',M, noise_title);
        title(title_string);
        xlabel('Time [n]');
        ylabel('Absolute Coefficient Values');
        filename=sprintf("task13_c_M_%d_sigma=%f",M,sigma_w_sq);
        saveas(gcf,filename,'bmp');
    end
end

%extract specified data for desired index n (n is a time index on an axis). Used for extracting x and d for some time index n out of their time axes.
%function caller is responsible for correct n value, last element of sliding must not go beyond last element of x (n+desired_seg_len-1<length(x)!)
function segment = get_segment(x,desired_seg_len,n)
    x=x(:);
    if n<1
		%sliding window only overlaps with time axis data, special case
        x_sliding_window=zeros(1,desired_seg_len);
        negative_time_length=-n+1;
        x_sliding_window(negative_time_length+1:desired_seg_len)=x(1:n+desired_seg_len-1);
        x_sliding_window=transpose(x_sliding_window);
    else
		%sliding window totally 'within' time axis data
        x_sliding_window=x(n:n+desired_seg_len-1);
    end
    segment = flip(x_sliding_window);
end

