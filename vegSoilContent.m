 ndvi0204 = imread('D:\BiyeData\sentinel2-PDtif\0204.tif');
ndvi0206 = imread('D:\BiyeData\sentinel2-PDtif\0206.tif');
ndvi0311 = imread('D:\BiyeData\sentinel2-PDtif\0311.tif');
ndvi0407 = imread('D:\BiyeData\sentinel2-PDtif\0407.tif');
ndvi0425 = imread('D:\BiyeData\sentinel2-PDtif\0425.tif');
ndvi0701 = imread('D:\BiyeData\sentinel2-PDtif\0701.tif');
ndvi0815 = imread('D:\BiyeData\sentinel2-PDtif\0815.tif');
ndvi1208 = imread('D:\BiyeData\sentinel2-PDtif\1208.tif');
ndvi181216 = imread('D:\BiyeData\sentinel2-PDtif\181216.tif');
ndvi200107 = imread('D:\BiyeData\sentinel2-PDtif\200107.tif');
maskOut = imread('C:\Users\hasee\Documents\MATLAB\maskNDVI.tif');

% [pic,Range] = geotiffread('D:\BiyeData\sentinel2-PDtif\0815.tif');

cut0204 = ndvi0204(2:1450,2:2001);
cut0206 = ndvi0206(1:1449,2:2001);
cut0311 = ndvi0311(2:1450,2:2001);
cut0407 = ndvi0407(2:1450,2:2001);
cut0425 = ndvi0425(2:1450,2:2001);
cut0701 = ndvi0701(1:1449,1:2000);
cut0815 = ndvi0815(1:1449,2:2001);
cut1208 = ndvi1208(3:1451,2:2001);
cut181216 = ndvi181216(2:1450,2:2001);
cut200107 = ndvi200107(1:1449,2:2001);
cutMask = maskOut(1:1449,2:2001);


%%%%计算单个图像的Mveg%%%%
cutImage = cut1208;    %%%%%当前操作的图像
imageMveg = zeros(1449,2000);
for i = 1:1:1449
    for j = 1:1:2000
        if(cutImage(i,j) == 20)
            imageMveg(i,j) = -2; %代表为掩膜区域
        end
        if(cutImage(i,j) ~= 20)            
            if(cutMask(i,j) == 1)
                imageMveg(i,j) = -1; %代表为城市河流等去除区域
            end
            if(cutMask(i,j) ~= 1)
                           
                if(cutImage(i,j) <= 0.17 && cutMask(i,j) ~= 1)
                    imageMveg(i,j) = 0; %代表此区域的Mveg为00
                end
                if( (0.17 < cutImage(i,j) ) && (cutImage(i,j)<= 0.5) )
                    imageMveg(i,j) = 1.913*cutImage(i,j)^2 - 0.3215*cutImage(i,j);
                end
                if( cutImage(i,j) > 0.5 )
                    imageMveg(i,j) = 4.2857*cutImage(i,j) - 1.82715;
                end
            end
        end
    end
end
%%%%计算单个图像的Mveg%%%%

%%%%显示Mveg的RGB图像%%%%
ShowMveg = zeros(1449,2000,3);
RedMin = 210;RedMax = 0;RedWidth = abs(RedMin - RedMax);
GreenMin = 220;GreenMax = 150;GreenWidth = abs(GreenMin - GreenMax);
BlueMin = 30;Blue = 80;GreenWidth = abs(GreenMin - GreenMax);
for i = 1:1:1449
    for j = 1:1:2000
        if(imageMveg(i,j) == -2)
             R=255/255;G=255/255;B=255/255;                                   %白色
             ShowMveg(i,j,1)=R;ShowMveg(i,j,2)=G;ShowMveg(i,j,3)=B;
        elseif(imageMveg(i,j) == -1)
             R=150/255;G=20/255;B=170/255;                                    %紫色，代表房屋
             ShowMveg(i,j,1)=R;ShowMveg(i,j,2)=G;ShowMveg(i,j,3)=B;
%          elseif(imageMveg0204(i,j) == 0)
%              R=166/255;G=90/255;B=0/255;                                    %棕色
%              ShowMveg0204(i,j,1)=R;ShowMveg0204(i,j,2)=G;ShowMveg0204(i,j,3)=B;
             
         elseif(imageMveg(i,j) < 0.2 && imageMveg(i,j) >= 0)
             R=210/255;G=220/255;B=35/255;                                    
             ShowMveg(i,j,1)=R;ShowMveg(i,j,2)=G;ShowMveg(i,j,3)=B;
             
         elseif(imageMveg(i,j) < 0.4 && imageMveg(i,j) > 0.2)
             R=187/255;G=212/255;B=40/255;                                    
             ShowMveg(i,j,1)=R;ShowMveg(i,j,2)=G;ShowMveg(i,j,3)=B;
             
         elseif(imageMveg(i,j) < 0.6 && imageMveg(i,j) > 0.4)
             R=164/255;G=204/255;B=45/255;                                    
             ShowMveg(i,j,1)=R;ShowMveg(i,j,2)=G;ShowMveg(i,j,3)=B;
             
         elseif(imageMveg(i,j) < 0.8 && imageMveg(i,j) > 0.6)
             R=141/255;G=196/255;B=50/255;                                    
             ShowMveg(i,j,1)=R;ShowMveg(i,j,2)=G;ShowMveg(i,j,3)=B;
             
         elseif(imageMveg(i,j) < 1 && imageMveg(i,j) > 0.8)
             R=118/255;G=188/255;B=55/255;                                    
             ShowMveg(i,j,1)=R;ShowMveg(i,j,2)=G;ShowMveg(i,j,3)=B;
             
         elseif(imageMveg(i,j) < 1.2 && imageMveg(i,j) > 1)
             R=95/255;G=180/255;B=60/255;                                    
             ShowMveg(i,j,1)=R;ShowMveg(i,j,2)=G;ShowMveg(i,j,3)=B;
             
         elseif(imageMveg(i,j) < 1.4 && imageMveg(i,j) > 1.2)
             R=72/255;G=172/255;B=65/255;                                    
             ShowMveg(i,j,1)=R;ShowMveg(i,j,2)=G;ShowMveg(i,j,3)=B;
             
         elseif(imageMveg(i,j) < 1.6 && imageMveg(i,j) > 1.4)
             R=49/255;G=164/255;B=70/255;                                    
             ShowMveg(i,j,1)=R;ShowMveg(i,j,2)=G;ShowMveg(i,j,3)=B;
         elseif(imageMveg(i,j) < 1.8 && imageMveg(i,j) > 1.6)
             R=26/255;G=156/255;B=75/255;                                    
             ShowMveg(i,j,1)=R;ShowMveg(i,j,2)=G;ShowMveg(i,j,3)=B;    
         elseif(imageMveg(i,j) < 2.1 && imageMveg(i,j) > 1.8)
             R=3/255;G=148/255;B=80/255;                                    
             ShowMveg(i,j,1)=R;ShowMveg(i,j,2)=G;ShowMveg(i,j,3)=B;    
        end
    end
end

imshow(ShowMveg);
% imshow(cutMask);
             
maxMveg = max(max(imageMveg));




%%%%通过NDVI的值来生成城市区域的Mask文件%%%%
for i = 1:1:1449
    for j = 1:1:2000
        Cut(i,j,1) = cut0204(i,j);
        Cut(i,j,2) = cut0206(i,j);
        Cut(i,j,3) = cut0311(i,j);
        Cut(i,j,4) = cut0407(i,j);
        Cut(i,j,5) = cut0425(i,j);
        Cut(i,j,6) = cut0701(i,j);
        Cut(i,j,7) = cut0815(i,j);
        Cut(i,j,8) = cut1208(i,j);
        Cut(i,j,9) = cut181216(i,j);
        Cut(i,j,10) = cut200107(i,j);
    end
end

mask = zeros(1449,2000);
for i = 1:1:1449
    for j = 1:1:2000
        if(cut0204(i,j) == 20 || cut0206(i,j) == 20 || cut0311(i,j) == 20 || cut0407(i,j) == 20 || cut0425(i,j) == 20 || cut0701(i,j) == 20 ||  cut0815(i,j) == 20 || cut1208(i,j) == 20 || cut181216(i,j) == 20 || cut200107(i,j) ==20)
            mask(i,j) = 2;
        end
        if(cut0204(i,j) < 0.5 && cut0206(i,j) < 0.5 && cut0311(i,j) < 0.5 && cut0407(i,j) < 0.5 && cut0425(i,j) < 0.5 && cut0701(i,j) < 0.5 && cut0815(i,j) < 0.5 && cut1208(i,j) < 0.5 && cut181216(i,j) < 0.5 && cut200107(i,j) < 0.5)
            mask(i,j) = 1;
        end
    end
endmaskRGB = zeros(1449,2000,3);


for i = 1:1:1449
    for j = 1:1:2000
        if(mask(i,j) == 0)
             R=0/255;G=150/255;B=0/255;                                   %灰色
             maskRGB(i,j,1)=R;maskRGB(i,j,2)=G;maskRGB(i,j,3)=B;
        elseif(mask(i,j) == 2)
            R=255/255;G=255/255;B=255/255;                                   %灰色
             maskRGB(i,j,1)=R;maskRGB(i,j,2)=G;maskRGB(i,j,3)=B;
        elseif(mask(i,j) == 1)
            R=150/255;G=0/255;B=0/255;                                   %灰色
             maskRGB(i,j,1)=R;maskRGB(i,j,2)=G;maskRGB(i,j,3)=B;
        end
    end
end


mask = zeros(1449,2000);
for i = 1:1:1449
    for j = 1:1:2000
        if(cut0815(i,j)<0.5)
            mask(i,j) = 1;
        end
        if(cut0815(i,j) == 20)
            mask(i,j) = 2;
        end
    end
end

maskRGB = zeros(1449,2000,3);
for i = 1:1:1449
    for j = 1:1:2000
        if(mask(i,j) == 0)
             R=0/255;G=150/255;B=0/255;                                   %灰色
             maskRGB(i,j,1)=R;maskRGB(i,j,2)=G;maskRGB(i,j,3)=B;
        elseif(mask(i,j) == 2)
            R=255/255;G=255/255;B=255/255;                                   %灰色
             maskRGB(i,j,1)=R;maskRGB(i,j,2)=G;maskRGB(i,j,3)=B;
        elseif(mask(i,j) == 1)
            R=150/255;G=0/255;B=0/255;                                   %灰色
             maskRGB(i,j,1)=R;maskRGB(i,j,2)=G;maskRGB(i,j,3)=B;
        end
    end
end            
imshow(maskRGB);
maskRGBout = zeros(1450,2002);
for i = 1:1:1450
    maskRGBout(i,1) = 2;
    maskRGBout(i,2002) = 2;
end
for i = 1:1:2002
    maskRGBout(1450,i) = 2;
end
for i = 1:1:1449
    for j = 1:1:2000
        maskRGBout(i,j+1) = mask(i,j);
    end
end


geotiffwrite('maskNDVI.tif',maskRGBout,Range);
%%%%通过NDVI的值来生成城市区域的Mask文件%%%%

