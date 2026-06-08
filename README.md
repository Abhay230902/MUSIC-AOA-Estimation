## Overview

This project implements the MUSIC (Multiple Signal Classification)
algorithm for Angle of Arrival (AoA) estimation using a Uniform Linear Array (ULA).

The algorithm:

- Simulates multiple RF sources
- Constructs the covariance matrix
- Performs eigenvalue decomposition
- Separates signal and noise subspaces
- Estimates AoAs using the MUSIC spectrum

## Parameters

| Parameter | Value |
|-----------|---------|
| Antenna Elements | 64 |
| Sources | 5 |
| Frequency | 1280 MHz |
| SNR | 20 dB |
| Array Spacing | λ/2 |

## Estimated AoAs

- 10°
- 35°
- 45°
- 60°
- 85°

## Result

![MUSIC Spectrum](results/music_spectrum.png)

## Future Work

- ESPRIT
- MVDR Beamformer
- MIMO Radar
- SDR Implementation
- GNU Radio Integration

## Author

Abhay Sathyanarayana Rao

M.Sc Embedded Systems

Technische Universität Chemnitz
