# SAR-Soil-Moisture
Soil moisture inversion from Sentinel-1 data processed with the Water Cloud Model.

CalculateForS.m is used to compute the relationship between sampling frequency and S-value calculations. 
CalculateForS2.m and CalculateForS3.m both serve to estimate the ground truth of S-values through distinct methodologies. 
CalculateForLSecondByX.m handles the computation of lateral scan data across the entire scanning region。 
CalculateForLSecondByY.m processes longitudinal scan data for the same purpose. 
SoilMoistureCalculateWithICDM.m implements an improved change detection method (ICDM) for soil moisture estimation. 
vegSoilContent.m calculates vegetation-soil water content interactions. 
SARWithoutMveg.m corrects SAR data by mitigating vegetation effects.
