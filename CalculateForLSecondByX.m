%%%%%%%%%%%%%%%%这段代码是为了探寻在一个固定的采样长度（组合形成的一条完整的线段）之下，L和取样长度的关系
%首先读取数据，使用第三个测量点的扇形数据进行结果展示
% image = xlsread('E:\研二 下学期\6-14农科村实地测量\农科村数据 激光数据\19-06-14-0506\19-06-14-0506_2.csv');  %点三
%image = xlsread('E:\研二 下学期\6-14农科村实地测量\农科村数据 激光数据\19-06-14-0708\19-06-14-0708_2.csv');  %点四
image = xlsread('E:\研二 下学期\6-14农科村实地测量\农科村数据 激光数据\19-06-14-0910\19-06-14-0910_2.csv');  %点五
% image = xlsread('E:\研二 下学期\6-14农科村实地测量\农科村数据 激光数据\19-06-14-2324\19-06-14-2324_2.csv');  %点12
% image = xlsread('E:\研二 下学期\6-14农科村实地测量\农科村数据 激光数据\19-06-14-1112\19-06-14-1112.csv');  %点6
% image = xlsread('E:\研二 下学期\6-14农科村实地测量\农科村数据 激光数据\19-06-14-1920\19-06-14-1920.csv');  %点10
% image = xlsread('E:\研二 下学期\6-14农科村实地测量\农科村数据 激光数据\19-06-14-2122\19-06-14-2122_3.csv');  %点11
% image = xlsread('E:\研二 下学期\6-14农科村实地测量\农科村数据 激光数据\19-06-14-2324\19-06-14-2324_2.csv');  %点13
%  imageLength1 = 730806;
imageLength1 = image(1,1);
% image = image(1:imageLength1 + 1 , :);
%将数据以一条为单位存储在一个大的三维矩阵中 
LineSize = 698;
%StripeSize = image(1,1) / LineSize;
StripeSize = imageLength1 / LineSize;
Stripe = zeros(LineSize , 3 , StripeSize);

for i = 1:1:StripeSize
    for j = 1:1:LineSize
        Stripe(: , 1:3 , i) = image((i-1) * LineSize + 2 : i * LineSize + 1 , 1:3 );
    end    
end

%%%%%%%%将这些点集都弄成等间距的%%%%%%%

%我们先设定每条线都分200个点出来，以x轴为分割线进行，先用一个矩阵存储在y轴上的间隔距离
EqualSpaceStripe = zeros(200,3,StripeSize*2);

%用一个矩阵来存储每条线的间隔值
EachLength = zeros(StripeSize,1);
spaceOfEach = zeros(StripeSize,1);
SamplePointLoc = zeros(200, 1);  %存储合适位置间隔

for i = 1:1:StripeSize
    EachLength(i,1) = abs(Stripe(1,1,i) - Stripe(LineSize,1,i)); %计算每条线段在X分量上的的长度
    spaceOfEach(i,1) = EachLength(i,1) / 200;
end
%用一个矩阵来存储每条线的间隔值

for i = 1:1:StripeSize
    CutLine = zeros(200,1);
    %构造Cut一维矩阵
    for j = 1:1:200
        CutLine(j,1) = Stripe(1,1,i) + (j-1) * spaceOfEach(i,1);                             %%%%%%%%%%%%%%由是增是减来决定%%%%%%%%%%%%%%%
    end
    %构造Cut一维矩阵
    
    %寻找离每个间隔处最近的点的坐标
    for j = 1:1:200
        [minNum , SamplePointLoc(j,1) ] = min(abs(Stripe(:,1,i) - CutLine(j,1))); 
    end
    %寻找离每个间隔处最近的点的坐标
    
    for j = 1:1:200
        EqualSpaceStripe(j,1:3,i) = Stripe(SamplePointLoc(j,1),1:3,i);
    end
end

%%%%%加入完全相反的一组等间距数据%%%%%%%
for i = StripeSize+1 : 2*StripeSize
    for j = 1:1:200
        EqualSpaceStripe(j,1:3,i) = EqualSpaceStripe(201-j,1:3,i-StripeSize);
    end
end
%%%%%加入完全相反的一组等间距数据%%%%%%%
%%%%%%%%将这些点集都弄成等间距的%%%%%%%

%%%%%%首先用来做测试的每条线是长度在50m的组合线段，找15条线用来描述这一规律
corrL = zeros(491,15);
Random = ceil(rand(50,15) * StripeSize*2);  %生成随机矩阵,50×15个1到StripeSize的随机数
LZuHe = cell(1,15);
for i = 1:1:15
    for j = 1:1:50
        LZuHe{1,i} = [ LZuHe{1,i} ;  EqualSpaceStripe(:,:,Random(j,i))];
    end
end

for i = 1:1:15
    Lcount = LZuHe{1,i};
    for l = 200:20:10000    %这个表示取样的线段的长度
        LcountLength = l;
        avrZ = sum(Lcount(1:l,3))/LcountLength;
        FenMu = 0;
        %计算分母
        for m = 1:1:LcountLength
            FenMu = FenMu + (Lcount(m,3) - avrZ)^2;
        end
        %计算分子和
        corr = zeros(1,LcountLength);
        for k = 0:1:LcountLength - 1;
            FenZiHe = 0;
            for p = 1:1:LcountLength - k
                FenZiHe = FenZiHe + (Lcount(p,3) - avrZ) * (Lcount(p + k,3) - avrZ);
            end
            corr(1,k+1) = FenZiHe/FenMu;
            %此步骤在corr小于0.3时就不再计算，为的是减小函数的复杂度
            if (corr(1,k+1) < 0.3)
                break;
            end
            %此步骤在corr小于0.3时就不再计算，为的是减小函数的复杂度
        end
        
        for x = 1:1:LcountLength
            if((corr(1,x) >= exp(-1)) &&  (corr(1,x+1) <= exp(-1)))
                minLocation = x;
                break;
            end
        end
        %[minNum,minLocation] = min(abs(corr - minuent));
        corrL((l-180)/20,i) = sqrt((Lcount(2,1) - Lcount(minLocation,1))^2 + (Lcount(2,2) - Lcount(minLocation,2))^2) + 0.005 * (corr(1,minLocation) - exp(-1))/(corr(1,minLocation) - corr(1,minLocation+1)) ;%这个相关长度的计算是为了在很多一样的计算结果中引入差别，后面这部分相当于计算这个1/e到底卡在什么位置
    end
end

LLength = mean(corrL(491,:));     %用最长的组合线段的L来表示L的真值

%计算平均的相关长度%
LAvr = zeros(491,1);
for i = 1:1:491
    LAvr(i,1) = mean(corrL(i,:));
end




%%%%X的引入是为了改变横坐标为长度
X = zeros(1,491);
for i = 1:1:491
    X(1,i) = 0.9 + i*0.1;
end
%%%%X的引入是为了改变横坐标为长度

%lineL是相关长度的直线
lineL = zeros(1,50);
for i = 1:1:50
    lineL(1,i) = LLength;
end
%lineL是相关长度的直线

% %%%%%%%%%%%%%%%这部分是关于L与采样长度关系的绘图%%%%%%%%%%%%%%%
LText = num2str(LLength);
firstText = '平面L = ';
WholeText = [firstText , LText];
plot(X,LAvr,'k','LineWidth',3);hold on;
for i = 1:1:15
    plot(X , corrL(:,i) );hold on;
end
plot(X,LAvr,'k','LineWidth',3);hold on;
% plot(lineL,'-.k','LineWidth',1.8);hold on;
xlabel('采样长度（米）','fontsize',16,'FontWeight','bold');
ylabel('相关长度（米）','fontsize',16,'FontWeight','bold');
set(gcf,'unit','centimeters','position',[1,2,20,14]); %控制绘图区域的大小统一
set(gca,'FontSize',16);                               %改变坐标轴的字体大小
h = legend( '“均值”');                       
set(h,'FontSize',16,'FontWeight','normal');
% text(30,0.34, WholeText ,'FontSize',16);
% %%%%%%%%%%%%%%%这部分是关于L与采样长度关系的绘图%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%计算corrL与真值L的误差%%%%%%%%%%%%%%%
erro = zeros(491,15);
for i = 1:1:491
    for j = 1:1:15
        erro(i,j) = (abs(corrL(i,j) - LLength)) / LLength;    %此处需要根据每个点测得的总s来进行改变,这是平均误差       
    end
end
erroMean = zeros(491,1);
erroMax = zeros(491,1);
for i = 1:1:491
    erroMean(i,1) = mean(erro(i,:));
    erroMax(i,1) = max(erro(i,:));
end
line3 = zeros(50,1);
line4 = zeros(50,1);
for i = 1:1:50
    line3(i,1) = 0.1;
    line4(i,1) = 0.05;
end
%%%%此部分显示关于采样次数的误差%%%%
% plot(X,erroMean,'or');hold on;
% plot(X,erroMax,'xb');hold on;
% plot(line3,'-k','LineWidth',1.8);hold on;
% plot(line4,':k','LineWidth',1.8);grid on;
% xlabel('采样长度（米）','fontsize',16,'FontWeight','bold');
% ylabel('相关长度误差','fontsize',16,'FontWeight','bold');
% set(gcf,'unit','centimeters','position',[1,2,20,14]); %控制绘图区域的大小统一
% set(gca,'FontSize',16);                               %改变坐标轴的字体大小
% tuli = legend('平均误差','最大误差','10%误差','5%误差');
% set(tuli,'FontSize',16);

%%%%%%%%%%%%%%计算corrL与真值L的误差%%%%%%%%%%%%%%%