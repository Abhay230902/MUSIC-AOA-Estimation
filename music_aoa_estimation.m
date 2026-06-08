clc;
clear;
close all;

%% Parameters

M = 64;                      % Number of antenna elements
K = 5;                       % Number of signal sources
fc = 1280e6;                 % Carrier frequency
c = physconst('LightSpeed');
lambda = c/fc;               % Wavelength
d = lambda/2;                % Antenna spacing

SNR = 20;                    % SNR in dB
snapshots = 1000;            % Number of snapshots

%% True Angles of Arrival

theta_true = [10 35 45 60 85];

%% Generate Steering Matrix

A = zeros(M,K);

for k = 1:K
    A(:,k) = exp(-1j*2*pi*(d/lambda)*(0:M-1)'...
              *sin(deg2rad(theta_true(k))));
end

%% Generate Source Signals

S = (randn(K,snapshots) + 1j*randn(K,snapshots))/sqrt(2);

%% Received Signal

X = A*S;

%% Add Noise

signal_power = mean(abs(X(:)).^2);

noise_power = signal_power/(10^(SNR/10));

noise = sqrt(noise_power/2) * ...
       (randn(M,snapshots)+1j*randn(M,snapshots));

X = X + noise;

%% Covariance Matrix

R = (X*X')/snapshots;

%% Eigen Decomposition

[V,D] = eig(R);

[eigenvalues,index] = sort(diag(D),'descend');

V = V(:,index);

%% Noise Subspace

En = V(:,K+1:end);

%% MUSIC Spectrum

angles = -90:0.2:90;

Pmusic = zeros(size(angles));

for i = 1:length(angles)

    a = exp(-1j*2*pi*(d/lambda)*(0:M-1)'...
        *sin(deg2rad(angles(i))));

    Pmusic(i) = 1/(a'*(En*En')*a);

end

Pmusic = abs(Pmusic);

Pmusic = Pmusic/max(Pmusic);

%% Peak Detection

[pks,locs] = findpeaks(Pmusic,...
    'SortStr','descend',...
    'NPeaks',K);

estimated_angles = sort(angles(locs));

disp('True AOAs:')
disp(theta_true)

disp('Estimated AOAs:')
disp(estimated_angles)

%% Plot

figure;
plot(angles,Pmusic,'LineWidth',2);
grid on;
xlabel('Angle of Arrival (degrees)');
ylabel('Normalized MUSIC Spectrum');
title('MUSIC Direction of Arrival Estimation');
hold on;
plot(estimated_angles,pks,'ro',...
    'MarkerSize',8,...
    'LineWidth',2);
Pmusic = 10*log10(Pmusic/max(Pmusic));

figure;
plot(angles,Pmusic,'LineWidth',2);
grid on;
xlabel('Angle of Arrival (degrees)');
ylabel('Normalized MUSIC Spectrum (dB)');
title('MUSIC DOA Estimation');
ylim([-60 0]);
