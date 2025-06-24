SAR181228VH = imread('D:\BiyeData\sentinel1-PDtif\181228VH.tif');
[SAR181228VV,range] = geotiffread('D:\BiyeData\sentinel1-PDtif\181228VV.tif');

% SAR1117VH = imread('D:\BiyeData\sentinel1-PDtif\1117VH.tif');
% SAR1117VV = imread('D:\BiyeData\sentinel1-PDtif\1117VV.tif');
% 
% SAR1129VH = imread('D:\BiyeData\sentinel1-PDtif\1129VH.tif');
% SAR1129VV = imread('D:\BiyeData\sentinel1-PDtif\1129VV.tif');
% 
% SAR1211VH = imread('D:\BiyeData\sentinel1-PDtif\1211VH.tif');
% SAR1211VV = imread('D:\BiyeData\sentinel1-PDtif\1211VV.tif');
% 
% SAR1223VH = imread('D:\BiyeData\sentinel1-PDtif\1223VH.tif');
% SAR1223VV = imread('D:\BiyeData\sentinel1-PDtif\1223VV.tif');

% SAR0930VH = imread('D:\BiyeData\sentinel1-PDtif\0930VH.tif');
% SAR0930VV = imread('D:\BiyeData\sentinel1-PDtif\0930VV.tif');
% 
% SAR1012VH = imread('D:\BiyeData\sentinel1-PDtif\1012VH.tif');
% SAR1012VV = imread('D:\BiyeData\sentinel1-PDtif\1012VV.tif');
% 
% SAR1024VH = imread('D:\BiyeData\sentinel1-PDtif\1024VH.tif');
% SAR1024VV = imread('D:\BiyeData\sentinel1-PDtif\1024VV.tif');

ndvi181216 = imread('D:\BiyeData\sentinel2-PDtif\181216.tif');

maskOpt = imread('C:\Users\hasee\Documents\MATLAB\maskNDVI.tif');
maskSAR = imread('C:\Users\hasee\Documents\MATLAB\maskSAR.tif');
%%%计算Mveg%%%
ndvi = ndvi181216;
[lengthOri,widthOri] =size(ndvi);
Mveg = zeros(lengthOri,widthOri);
for i = 1:1:lengthOri
    for j = 1:1:widthOri
        if(ndvi(i,j) == 20)
            Mveg(i,j) = -2;
        end
        if(ndvi(i,j) ~= 20)
            if(ndvi(i,j) <= 0.17 )
                    Mveg(i,j) = 0; %代表此区域的Mveg为00
            end
            if( (0.17 < ndvi(i,j) ) && (ndvi(i,j)<= 0.5) )
                Mveg(i,j) = 1.913*ndvi(i,j)^2 - 0.3215*ndvi(i,j);
            end
            if( ndvi(i,j) > 0.5 )
                Mveg(i,j) = 4.2857*ndvi(i,j) - 1.82715;
            end
        end
    end
end

theta = 39;
Theta = (theta./180).*pi;

SARdataVH = SAR181228VH;
SARdataVV = SAR181228VV;

SARoutVH = zeros(1450,2002);
SARoutVV = zeros(1450,2002);
for i = 1:1:1449
%     for j = 1:1:1
%         SARoutVH(i,j) = SARdataVH(i,j);
%         SARoutVV(i,j) = SARdataVV(i,j);
%     end
    for j = 1:1:2002
        if SARdataVV(i,j) == 20
            SARoutVV(i,j) = 20;
            SARoutVH(i,j) = 20;
        end
        if SARdataVV(i,j) ~= 20
            if maskOpt(i,j) == 1
                SARoutVV(i,j) = 30; 
                SARoutVH(i,j) = 30;
            end
            if maskSAR(i,j) == 1
                SARoutVV(i,j) = 30; 
                SARoutVH(i,j) = 30;
            end
            if (maskOpt(i,j) ~= 1 && maskSAR(i,j) ~= 1)
                SARoutVV(i,j) = ( SARdataVV(i,j) - 0.0012*Mveg(i+1,j)*cos(Theta)*(1-exp(-2*0.091*Mveg(i+1,j)/cos(Theta))) )/exp(-2*0.091*Mveg(i+1,j)/cos(Theta));
                SARoutVH(i,j) = ( SARdataVH(i,j) - 0.0012*Mveg(i+1,j)*cos(Theta)*(1-exp(-2*0.091*Mveg(i+1,j)/cos(Theta))) )/exp(-2*0.091*Mveg(i+1,j)/cos(Theta));
            end
        end
    end   
end
for i = 1450:1:1450
    for j = 1:1:2002
        SARoutVV(i,j) = SARdataVV(i,j);
        SARoutVH(i,j) = SARdataVH(i,j);
    end
end
geotiffwrite('D:\BiyeData\sentinel1-PDtif-LuoTu\181228VH.tif',SARoutVH,range);
geotiffwrite('D:\BiyeData\sentinel1-PDtif-LuoTu\181228VV.tif',SARoutVV,range);