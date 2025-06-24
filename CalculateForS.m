%首先读取数据，使用第三个测量点的扇形数据进行结果展示
% image = xlsread('E:\研二 下学期\6-14农科村实地测量\农科村数据 激光数据\19-06-14-0506\19-06-14-0506_2.csv');  %点三
% image = xlsread('E:\研二 下学期\6-14农科村实地测量\农科村数据 激光数据\19-06-14-0708\19-06-14-0708_2.csv');  %点四
% image = xlsread('E:\研二 下学期\6-14农科村实地测量\农科村数据 激光数据\19-06-14-0910\19-06-14-0910_2.csv');  %点五
image = xlsread('E:\研二 下学期\6-14农科村实地测量\农科村数据 激光数据\19-06-14-1112\19-06-14-1112.csv');  %点六

% sReal = 0.018;
% sReal = 0.0227;
% sReal = 0.0352;
sReal = 0.0207;    %%%手动输入s的“真值”
%%%%%计算s的真值%%%%%
imageLength = image(1,1);


%将数据以一条为单位存储在一个大的三维矩阵中
LineSize = 698;
StripeSize = image(1,1) / LineSize;

Stripe = zeros(LineSize , 3 , StripeSize);

for i = 1:1:StripeSize
    for j = 1:1:LineSize
        Stripe(: , 1:3 , i) = image((i-1) * LineSize + 2 : i * LineSize + 1 , 1:3 );
    end    
end

%用一个矩阵来存储想要的结果（在取样为x的情况下，得到的s值，其中x为选择的测量剖面的个数，s为这些测量剖面的均方根高度）

WholeOut = zeros(300,20); %50表示剖面的个数从1~50,10表示每种剖面个数选取10次随机取样
for i = 1:1:300           %此层循环表示选取的条带的个数
    %首先构建包含i个整数的随机序列，以矩阵的形式存储
    Random = ceil(rand(20,i) * StripeSize);  %生成随机数矩阵 
    sumSize = LineSize * i;
    
    %计算20次随机选取的剖面的均方根高地
    for j = 1:1:20        %此层循环是指的用次选取的结果
        %每次计算所有剖面的均方跟高度
        sumZ = 0;
        for k = 1:1:i
            sumZ = sumZ + sum(Stripe(:,3,Random(j,k)));
        end
        z_mean = sumZ / sumSize;
        
        z_squareSum = 0;
        for k = 1:1:i
            for m = 1:1:LineSize
                z_squareSum = z_squareSum + Stripe(m,3,Random(j,k)) * Stripe(m,3,Random(j,k));
            end
        end
        
        s1 = z_squareSum/(sumSize)-z_mean*z_mean;
        s = sqrt(s1);
        
        WholeOut(i,j) = s;
    end
end

%%%%%%%%此部分是为了对生成的采样准确度图进行显示%%%%%%%%
line1 = zeros(300,1);
% line2 = zeros(300,1);
for i = 1:1:300
    line1(i,1) = sReal;
%     line2(i,1) = 0.02157;
end

%%%%%显示框图部分代码%%%%%%%
plot(line1,'-.k','LineWidth',1.8);hold on;
plot(WholeOut,'.r');hold on;
plot(line1,'-.k','LineWidth',1.8);

grid on;
xlabel('采样次数','fontsize',16,'FontWeight','bold');
ylabel('均方根高度RMS(米)','fontsize',16,'FontWeight','bold');
set(gcf,'unit','centimeters','position',[1,2,20,14]); %控制绘图区域的大小统一
set(gca,'xtick',0:50:300);  %设置x轴的范围     
set(gca,'FontSize',16);                               %改变坐标轴的字体大小
axis([0,300,0,0.03]) ;
h = legend( '“真值”', '计算值');                       
set(h,'FontSize',16,'FontWeight','normal');



%%%%%显示框图部分代码%%%%%%%
%%%%%%%此部分是为了对生成的采样准确度图进行显示%%%%%%%%

% %%%%%%计算每个采样个数的精确度（计算每个采样个数下每次出现误差的平均）%%%%%%%%%%%
erro = zeros(300,20);

for i = 1:1:300
    for j = 1:1:20
        erro(i,j) = (abs(WholeOut(i,j) - sReal)) / sReal;    %此处需要根据每个点测得的总s来进行改变,这是平均误差       
    end
end
erroMean = zeros(300,1);
erroMax = zeros(300,1);
for i = 1:1:300
    erroMean(i,1) = mean(erro(i,:));
    erroMax(i,1) = max(erro(i,:));
end

line3 = zeros(300,1);
line4 = zeros(300,1);
for i = 1:1:300
    line3(i,1) = 0.1;
    line4(i,1) = 0.05;
end
% 
% %%%%此部分显示关于采样次数的误差%%%%
% plot(erroMean,'or');hold on;
% plot(erroMax,'xb');hold on;
% plot(line3,'-k','LineWidth',1.8);hold on;
% plot(line4,':k','LineWidth',1.8);grid on;
% 
% grid on;
% xlabel('采样次数','fontsize',16,'FontWeight','bold');
% ylabel('均方根高度误差','fontsize',16,'FontWeight','bold');
% set(gcf,'unit','centimeters','position',[1,2,20,14]); %控制绘图区域的大小统一
% set(gca,'xtick',0:50:300);  %设置x轴的范围     
% % axis([0,300,0,0.035]) ;
% set(gca,'FontSize',16);                               %改变坐标轴的字体大小
% tuli = legend('平均相对误差','最大相对误差','10%误差线','5%误差线');
% set(tuli,'FontSize',16);

% % %%%%此部分显示关于采样次数的误差%%%%
% %%%%%%计算每个采样个数的精确度（计算每个采样个数下每次出现误差的平均）%%%%%%%%%%%
