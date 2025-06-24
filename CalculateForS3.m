image = xlsread('E:\�ж� ��ѧ��\6-14ũ�ƴ�ʵ�ز���\ũ�ƴ����� ��������\19-06-14-0708\19-06-14-0708_2.csv');  %��4
imageLength1 = image(1,1);
LineSize = 698;

%%%%%%�ֳ�һ�����Ķ�ά����%%%%%%%%%%%%%%
%StripeSize = image(1,1) / LineSize;
StripeSize = imageLength1 / LineSize;

Stripe = zeros(LineSize , 3 , StripeSize);

for i = 1:1:StripeSize
    for j = 1:1:LineSize
        Stripe(: , 1:3 , i) = image((i-1) * LineSize + 2 : i * LineSize + 1 , 1:3 );
    end    
end
%%%%%%�ֳ�һ�����Ķ�ά����%%%%%%%%%%%%%%
sResult = zeros(1,StripeSize);
%%%%%%�������߶ȵļ���%%%%%%%%%%%
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
%%%%%%�������߶ȵļ���%%%%%%%%%%%

%%%%����չʾ��ͬƽ���s��ֵ%%%%
sMax = max(sResult);
sMin = min(sResult);
for i = 1:1:StripeSize
    X(1,i) = i;
end
plot(X,sResult,'.-b');
tuli = legend('�������߶�');
set(tuli,'FontSize',16);
grid on;
xlabel('��ά�������','fontsize',16,'FontWeight','bold');
ylabel('�������߶�/m','fontsize',16,'FontWeight','bold');
title('ͬһ�ر�ͬ������ά����ľ�����','fontsize',16,'FontWeight','bold');
set(gcf,'unit','centimeters','position',[1,2,24,12]); %���ƻ�ͼ����Ĵ�Сͳһ
set(gca,'xtick',0:200:1047);  %����x��ķ�Χ       
axis([0,1047,0.01,0.03]) ;
% cell={'mv=0.1','mv=0.15','mv=0.2','mv=0.25','mv=0.3','mv=0.35','mv=0.4'};
% columnlegend(2, cell, 'location','southeast');