image = xlsread('E:\研二 下学期\6-14农科村实地测量\农科村数据 激光数据\19-06-14-0708\19-06-14-0708_2.csv');  %点4
imageLength1 = image(1,1);
LineSize = 698;

%%%%%%分成一个个的二维剖面%%%%%%%%%%%%%%
%StripeSize = image(1,1) / LineSize;
StripeSize = imageLength1 / LineSize;

Stripe = zeros(LineSize , 3 , StripeSize);

for i = 1:1:StripeSize
    for j = 1:1:LineSize
        Stripe(: , 1:3 , i) = image((i-1) * LineSize + 2 : i * LineSize + 1 , 1:3 );
    end    
end
%%%%%%分成一个个的二维剖面%%%%%%%%%%%%%%
sResult = zeros(1,StripeSize);
%%%%%%均方根高度的计算%%%%%%%%%%%
for i = 1:1:StripeSize
    sumOfZ = 0;
    for j = 1:1:LineSize
        sumOfZ = sumOfZ + Stripe(j,3,i);
    end
    meanZ = sumOfZ/LineSize;

    sumOfZ2 = 0;
    for j = 1:1:LineSize
        sumOfZ2 = sumOfZ2 + Stripe(j,3,i) * Stripe(j,3,i);
    end

    fenzi = sumOfZ2 - LineSize * meanZ * meanZ;
    s = sqrt(fenzi/(LineSize - 1));
    sResult(1,i) = s;
end
%%%%%%均方根高度的计算%%%%%%%%%%%

%%%%用来展示不同平面的s的值%%%%
sMax = max(sResult);
sMin = min(sResult);
for i = 1:1:StripeSize
    X(1,i) = i;
end
plot(X,sResult,'.-b');
tuli = legend('均方根高度');
set(tuli,'FontSize',16);
grid on;
xlabel('二维剖面序号','fontsize',16,'FontWeight','bold');
ylabel('均方根高度/m','fontsize',16,'FontWeight','bold');
title('同一地表不同采样二维剖面的均方根','fontsize',16,'FontWeight','bold');
set(gcf,'unit','centimeters','position',[1,2,24,12]); %控制绘图区域的大小统一
set(gca,'xtick',0:200:1047);  %设置x轴的范围       
axis([0,1047,0.01,0.03]) ;
% cell={'mv=0.1','mv=0.15','mv=0.2','mv=0.25','mv=0.3','mv=0.35','mv=0.4'};
% columnlegend(2, cell, 'location','southeast');