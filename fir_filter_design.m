%% FIR Filter Design using the Z-Transform
% Designs and analyses two first-order FIR filters starting directly
% from their Z-domain transfer functions:
%
%   Low-Pass  : H(z) = (z + 1) / z   ->  y[n] = x[n] + x[n-1]
%   High-Pass : H(z) = (z - 1) / z   ->  y[n] = x[n] - x[n-1]
%
% For each filter, the transfer function is expanded into numerator /
% denominator coefficients (numden + sym2poly), and the magnitude /
% phase response is plotted using freqz. Figures are saved to
% images/ so the README stays in sync with the code.

clc;
clear;
close all;

if ~exist('images', 'dir')
    mkdir('images');
end

syms z;

analyze_filter((z + 1) / z, 'Low Pass Filter',  'images/low_pass_filter_response.png');
analyze_filter((z - 1) / z, 'High Pass Filter', 'images/high_pass_filter_response.png');


function analyze_filter(Hz, plot_title, save_path)
% ANALYZE_FILTER  Extract coefficients from a symbolic transfer
% function H(z), print them, and plot + save the frequency response.
%
%   Hz         - symbolic expression for H(z)
%   plot_title - title used on the generated figure
%   save_path  - where to save the figure as a PNG

    [num, den] = numden(Hz);
    num_coeff = sym2poly(num);
    den_coeff = sym2poly(den);

    fprintf('%s\n', plot_title);
    disp('Numerator coefficients:');
    disp(num_coeff);
    disp('Denominator coefficients:');
    disp(den_coeff);

    figure('Name', plot_title);
    freqz(num_coeff, den_coeff);
    set(findall(gcf, 'Type', 'line'), 'LineWidth', 2);
    title(plot_title);

    exportgraphics(gcf, save_path);
end
