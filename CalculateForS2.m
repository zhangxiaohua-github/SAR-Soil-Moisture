% image = xlsread('E:\研二 下学期\6-14农科村实地测量\农科村数据 激光数据\19-06-14-1314\19-06-14-1314.csv','500000:1000000');
% image = xlsread('E:\研二 下学期\6-14农科村实地测量\农科村数据 激光数据\19-06-14-0506\19-06-14-0506_2.csv');  %点三
% image = xlsread('E:\研二 下学期\6-14农科村实地测量\农科村数据 激光数据\19-06-14-0708\19-06-14-0708_2.csv');  %点四
% image = xlsread('E:\研二 下学期\6-14农科村实地测量\农科村数据 激光数据\19-06-14-0910\19-06-14-0910_2.csv');  %点五
image = xlsread('E:\研二 下学期\6-14农科村实地测量\农科村数据 激光数据\19-06-14-1112\19-06-14-1112.csv');  %点六

imageLength = image(1,1);
sumOfZ = 0;
for i = 1:1:imageLength
    sumOfZ = sumOfZ + image(i+1,3);
end
meanZ = sumOfZ/imageLength;

sumOfZ2 = 0;
for i = 1:1:imageLength
    sumOfZ2 = sumOfZ2 + image(i+1,3) * image(i+1,3);
end

fenzi = sumOfZ2 - imageLength * meanZ * meanZ;
sReal = sqrt(fenzi/(imageLength - 1));