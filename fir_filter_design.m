%% FIR Filter Design using the Z-Transform
% Designs and analyses a first-order Low-Pass Filter (LPF) and a
% first-order High-Pass Filter (HPF) directly from their Z-domain
% transfer functions, then plots the magnitude and phase response
% of each filter.
%
% LPF:  H(z) = (z + 1) / z   =>  y[n] = x[n] + x[n-1]
% HPF:  H(z) = (z - 1) / z   =>  y[n] = x[n] - x[n-1]

clc;
clear;
close all;

syms z;

%% Low-Pass Filter
X(z) = (z + 1) / z;

[n, d] = numden(X(z));
n_coeff = sym2poly(n);
d_coeff = sym2poly(d);

disp('Low-Pass Filter');
disp('Numerator coefficients:');
disp(n_coeff);
disp('Denominator coefficients:');
disp(d_coeff);

freqz(n_coeff, d_coeff);   % No output args assigned, so the plot is drawn
set(findall(gcf, 'Type', 'line'), 'LineWidth', 2);
title('Low Pass Filter');

%% High-Pass Filter
X(z) = (z - 1) / z;

[n, d] = numden(X(z));
n_coeff = sym2poly(n);
d_coeff = sym2poly(d);

disp('High-Pass Filter');
disp('Numerator coefficients:');
disp(n_coeff);
disp('Denominator coefficients:');
disp(d_coeff);

figure;
freqz(n_coeff, d_coeff);
set(findall(gcf, 'Type', 'line'), 'LineWidth', 2);
title('High Pass Filter');
