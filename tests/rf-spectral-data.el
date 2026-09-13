;;; rf-spectral-data.el --- CIE and ICNIRP spectral tables -*- lexical-binding: t -*-

;; Copyright (C) 2026  Szymon Wilczek

;; Author: Szymon Wilczek <swilczek.lx@gmail.com>
;; URL: https://github.com/szymonwilczek/au-themes

;; This file is not part of GNU Emacs.

;; This file is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.
;;
;; This file is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with this file.  If not, see <https://www.gnu.org/licenses/>.

;;; Commentary:
;;
;; Verbatim 5 nm samples (no interpolation) of the following primary data sets:
;;
;;  - CIE 1931 2-degree colour-matching functions (CIE 015:2018),
;;    CIE datatable DOI: 10.25039/CIE.DS.xvudnb9b
;;    https://files.cie.co.at/CIE_xyz_1931_2deg.csv
;;  - CIE 1951 scotopic luminous efficiency function V'(lambda),
;;    CIE datatable DOI: 10.25039/CIE.DS.gr6w4b5g
;;    https://files.cie.co.at/CIE_sle_scotopic.csv
;;  - CIE S 026/E:2018 melanopic action spectrum (alpha-opic, column 5),
;;    CIE datatable DOI: 10.25039/CIE.DS.vqqhzp5a
;;    https://files.cie.co.at/CIE_a-opic_action_spectra.csv
;;  - CIE standard illuminant D65 relative SPD (ISO/CIE 11664-2),
;;    CIE datatable DOI: 10.25039/CIE.DS.hjfjmt59
;;    https://files.cie.co.at/CIE_std_illum_D65.csv
;;  - ICNIRP (2013) Guidelines on limits of exposure to incoherent visible and
;;    infrared radiation, Health Phys. 105(1):74-96, Table 2, blue-light hazard
;;    function B(lambda) (identical to IEC 62471:2006 / CIE S 009:2002),
;;    DOI: 10.1097/HP.0b013e318289a611
;;
;; Index i corresponds to lambda = 380 + 5 i nm, i = 0..80.

;;; Code:

(defconst rf-spectral-lambda-min 380.0 "First tabulated wavelength (nm).")
(defconst rf-spectral-lambda-step 5.0 "Sampling interval (nm).")
(defconst rf-spectral-samples 81 "Number of tabulated wavelengths.")

(defconst rf-cie1931-xbar
  [0.001368 0.002236 0.004243 0.00765 0.01431 0.02319
            0.04351 0.07763 0.13438 0.21477 0.2839 0.3285
            0.34828 0.34806 0.3362 0.3187 0.2908 0.2511
            0.19536 0.1421 0.09564 0.05795001 0.03201 0.0147
            0.0049 0.0024 0.0093 0.0291 0.06327 0.1096
            0.1655 0.2257499 0.2904 0.3597 0.4334499 0.5120501
            0.5945 0.6784 0.7621 0.8425 0.9163 0.9786
            1.0263 1.0567 1.0622 1.0456 1.0026 0.9384
            0.8544499 0.7514 0.6424 0.5419 0.4479 0.3608
            0.2835 0.2187 0.1649 0.1212 0.0874 0.0636
            0.04677 0.0329 0.0227 0.01584 0.01135916 0.008110916
            0.005790346 0.004109457 0.002899327 0.00204919 0.001439971 0.0009999493
            0.0006900786 0.0004760213 0.0003323011 0.0002348261 0.0001661505 0.000117413
            8.307527e-05 5.870652e-05 4.150994e-05]
  "CIE 1931 2-degree colour-matching function x-bar(lambda).")

(defconst rf-cie1931-ybar
  [3.9e-05 6.4e-05 0.00012 0.000217 0.000396 0.00064
           0.00121 0.00218 0.004 0.0073 0.0116 0.01684
           0.023 0.0298 0.038 0.048 0.06 0.0739
           0.09098 0.1126 0.13902 0.1693 0.20802 0.2586
           0.323 0.4073 0.503 0.6082 0.71 0.7932
           0.862 0.9148501 0.954 0.9803 0.9949501 1.0
           0.995 0.9786 0.952 0.9154 0.87 0.8163
           0.757 0.6949 0.631 0.5668 0.503 0.4412
           0.381 0.321 0.265 0.217 0.175 0.1382
           0.107 0.0816 0.061 0.04458 0.032 0.0232
           0.017 0.01192 0.00821 0.005723 0.004102 0.002929
           0.002091 0.001484 0.001047 0.00074 0.00052 0.0003611
           0.0002492 0.0001719 0.00012 8.48e-05 6e-05 4.24e-05
           3e-05 2.12e-05 1.499e-05]
  "CIE 1931 2-degree colour-matching function y-bar(lambda) = V(lambda).")

(defconst rf-cie1931-zbar
  [0.006450001 0.01054999 0.02005001 0.03621 0.06785001 0.1102
               0.2074 0.3713 0.6456 1.0390501 1.3856 1.62296
               1.74706 1.7826 1.77211 1.7441 1.6692 1.5281
               1.28764 1.0419 0.8129501 0.6162 0.46518 0.3533
               0.272 0.2123 0.1582 0.1117 0.07824999 0.05725001
               0.04216 0.02984 0.0203 0.0134 0.008749999 0.005749999
               0.0039 0.002749999 0.0021 0.0018 0.001650001 0.0014
               0.0011 0.001 0.0008 0.0006 0.00034 0.00024
               0.00019 0.0001 4.999999e-05 3e-05 2e-05 1e-05
               0.0 0.0 0.0 0.0 0.0 0.0
               0.0 0.0 0.0 0.0 0.0 0.0
               0.0 0.0 0.0 0.0 0.0 0.0
               0.0 0.0 0.0 0.0 0.0 0.0
               0.0 0.0 0.0]
  "CIE 1931 2-degree colour-matching function z-bar(lambda).")

(defconst rf-cie1951-vprime
  [0.000589 0.001108 0.002209 0.00453 0.00929 0.01852
            0.03484 0.0604 0.0966 0.1436 0.1998 0.2625
            0.3281 0.3931 0.455 0.513 0.567 0.62
            0.676 0.734 0.793 0.851 0.904 0.949
            0.982 0.998 0.997 0.975 0.935 0.88
            0.811 0.733 0.65 0.564 0.481 0.402
            0.3288 0.2639 0.2076 0.1602 0.1212 0.0899
            0.0655 0.0469 0.03315 0.02312 0.01593 0.01088
            0.00737 0.00497 0.003335 0.002235 0.001497 0.001005
            0.000677 0.000459 0.0003129 0.0002146 0.000148 0.0001026
            7.15e-05 5.01e-05 3.533e-05 2.501e-05 1.78e-05 1.273e-05
            9.14e-06 6.6e-06 4.78e-06 3.482e-06 2.546e-06 1.87e-06
            1.379e-06 1.022e-06 7.6e-07 5.67e-07 4.25e-07 3.196e-07
            2.413e-07 1.829e-07 1.39e-07]
  "CIE 1951 scotopic luminous efficiency function V'(lambda).")

(defconst rf-cie-s026-melanopic
  [0.000918165 0.00166724 0.00309442 0.00588035 0.0114277 0.0228112
               0.046155 0.0794766 0.137237 0.187096 0.253865 0.320679
               0.401587 0.474002 0.553715 0.629654 0.708049 0.785216
               0.860291 0.917734 0.965605 0.990621 1.0 0.992022
               0.965952 0.922299 0.862888 0.785233 0.699628 0.609422
               0.519309 0.432533 0.351707 0.279135 0.215722 0.162056
               0.118526 0.0843457 0.0587013 0.0400089 0.0268747 0.0178624
               0.0117901 0.0077343 0.00506686 0.00331766 0.00217698 0.00143314
               0.000947313 0.000627648 0.000417955 0.000279801 0.000188341 0.000127337
               8.65751e-05 5.91914e-05 4.06945e-05 2.8132e-05 1.95535e-05 1.3648e-05
               9.57637e-06 6.75425e-06 4.78804e-06 3.40841e-06 2.43819e-06 1.75252e-06
               1.2656e-06 9.18078e-07 6.68991e-07 4.89531e-07 3.59766e-07 2.65493e-07
               1.9674e-07 1.4637e-07 1.09332e-07 8.19587e-08 6.16749e-08 4.65916e-08
               3.53272e-08 2.68803e-08 2.05258e-08]
  "CIE S 026:2018 melanopic action spectrum s_mel(lambda), peak 1.0 at 490 nm.")

(defconst rf-icnirp-blue-light-hazard
  [0.01 0.0125 0.025 0.050 0.100 0.200
        0.400 0.800 0.900 0.950 0.980 1.000
        1.000 0.970 0.940 0.900 0.800 0.700
        0.620 0.550 0.450 0.400 0.220 0.160
        0.100 0.079 0.063 0.050 0.040 0.032
        0.025 0.020 0.016 0.013 0.010 0.008
        0.006 0.005 0.004 0.003 0.002 0.002
        0.001 0.001 0.001 0.001 0.001 0.001
        0.001 0.001 0.001 0.001 0.001 0.001
        0.001 0.001 0.001 0.001 0.001 0.001
        0.001 0.001 0.001 0.001 0.001 0.0
        0.0 0.0 0.0 0.0 0.0 0.0
        0.0 0.0 0.0 0.0 0.0 0.0
        0.0 0.0 0.0]
  "ICNIRP (2013) Table 2 / IEC 62471:2006 blue-light hazard function B(lambda).
Values for 600-700 nm are 0.001; the function is not defined (0) above 700 nm.")

(defconst rf-cie-d65-spd
  [49.9755 52.3118 54.6482 68.7015 82.7549 87.1204
           91.486 92.4589 93.4318 90.057 86.6823 95.7736
           104.865 110.936 117.008 117.41 117.812 116.336
           114.861 115.392 115.923 112.367 108.811 109.082
           109.354 108.578 107.802 106.296 104.79 106.239
           107.689 106.047 104.405 104.225 104.046 102.023
           100.0 98.1671 96.3342 96.0611 95.788 92.2368
           88.6856 89.3459 90.0062 89.8026 89.5991 88.6489
           87.6987 85.4936 83.2886 83.4939 83.6992 81.863
           80.0268 80.1207 80.2146 81.2462 82.2778 80.281
           78.2842 74.0027 69.7213 70.6652 71.6091 72.979
           74.349 67.9765 61.604 65.7448 69.8856 72.4863
           75.087 69.3398 63.5927 55.0054 46.4182 56.6118
           66.8054 65.0941 63.3828]
  "CIE standard illuminant D65 relative spectral power distribution (S(560) = 100).")

(provide 'rf-spectral-data)
;;; rf-spectral-data.el ends here
