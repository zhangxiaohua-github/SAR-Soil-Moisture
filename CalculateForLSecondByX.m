%%%%%%%%%%%%%%%%��δ�����Ϊ��̽Ѱ��һ���̶��Ĳ������ȣ�����γɵ�һ���������߶Σ�֮�£�L��ȡ�����ȵĹ�ϵ
%���ȶ�ȡ���ݣ�ʹ�õ�������������������ݽ��н��չʾ
% image = xlsread('E:\�ж� ��ѧ��\6-14ũ�ƴ�ʵ�ز���\ũ�ƴ����� ��������\19-06-14-0506\19-06-14-0506_2.csv');  %����
%image = xlsread('E:\�ж� ��ѧ��\6-14ũ�ƴ�ʵ�ز���\ũ�ƴ����� ��������\19-06-14-0708\19-06-14-0708_2.csv');  %����
image = xlsread('E:\�ж� ��ѧ��\6-14ũ�ƴ�ʵ�ز���\ũ�ƴ����� ��������\19-06-14-0910\19-06-14-0910_2.csv');  %����
% image = xlsread('E:\�ж� ��ѧ��\6-14ũ�ƴ�ʵ�ز���\ũ�ƴ����� ��������\19-06-14-2324\19-06-14-2324_2.csv');  %��12
% image = xlsread('E:\�ж� ��ѧ��\6-14ũ�ƴ�ʵ�ز���\ũ�ƴ����� ��������\19-06-14-1112\19-06-14-1112.csv');  %��6
% image = xlsread('E:\�ж� ��ѧ��\6-14ũ�ƴ�ʵ�ز���\ũ�ƴ����� ��������\19-06-14-1920\19-06-14-1920.csv');  %��10
% image = xlsread('E:\�ж� ��ѧ��\6-14ũ�ƴ�ʵ�ز���\ũ�ƴ����� ��������\19-06-14-2122\19-06-14-2122_3.csv');  %��11
% image = xlsread('E:\�ж� ��ѧ��\6-14ũ�ƴ�ʵ�ز���\ũ�ƴ����� ��������\19-06-14-2324\19-06-14-2324_2.csv');  %��13
%  imageLength1 = 730806;
imageLength1 = image(1,1);
% image = image(1:imageLength1 + 1 , :);
%��������һ��Ϊ��λ�洢��һ�������ά������ 
LineSize = 698;
%StripeSize = image(1,1) / LineSize;
StripeSize = imageLength1 / LineSize;
Stripe = zeros(LineSize , 3 , StripeSize);

for i = 1:1:StripeSize
    for j = 1:1:LineSize
        Stripe(: , 1:3 , i) = image((i-1) * LineSize + 2 : i * LineSize + 1 , 1:3 );
    end    
end

%%%%%%%%����Щ�㼯��Ū�ɵȼ���%%%%%%%

%�������趨ÿ���߶���200�����������x��Ϊ�ָ��߽��У�����һ������洢��y���ϵļ������
EqualSpaceStripe = zeros(200,3,StripeSize*2);

%��һ���������洢ÿ���ߵļ��ֵ
EachLength = zeros(StripeSize,1);
spaceOfEach = zeros(StripeSize,1);
SamplePointLoc = zeros(200, 1);  %�洢����λ�ü��

for i = 1:1:StripeSize
    EachLength(i,1) = abs(Stripe(1,1,i) - Stripe(LineSize,1,i)); %����ÿ���߶���X�����ϵĵĳ���
    spaceOfEach(i,1) = EachLength(i,1) / 200;
end
%��һ���������洢ÿ���ߵļ��ֵ

for i = 1:1:StripeSize
    CutLine = zeros(200,1);
    %����Cutһά����
    for j = 1:1:200
        CutLine(j,1) = Stripe(1,1,i) + (j-1) * spaceOfEach(i,1);                             %%%%%%%%%%%%%%�������Ǽ�������%%%%%%%%%%%%%%%
    end
    %����Cutһά����
    
    %Ѱ����ÿ�����������ĵ������
    for j = 1:1:200
        [minNum , SamplePointLoc(j,1) ] = min(abs(Stripe(:,1,i) - CutLine(j,1))); 
    end
    %Ѱ����ÿ�����������ĵ������
    
    for j = 1:1:200
        EqualSpaceStripe(j,1:3,i) = Stripe(SamplePointLoc(j,1),1:3,i);
    end
end

%%%%%������ȫ�෴��һ��ȼ������%%%%%%%
for i = StripeSize+1 : 2*StripeSize
    for j = 1:1:200
        EqualSpaceStripe(j,1:3,i) = EqualSpaceStripe(201-j,1:3,i-StripeSize);
    end
end
%%%%%������ȫ�෴��һ��ȼ������%%%%%%%
%%%%%%%%����Щ�㼯��Ū�ɵȼ���%%%%%%%

%%%%%%�������������Ե�ÿ�����ǳ�����50m������߶Σ���15��������������һ����
corrL = zeros(491,15);
Random = ceil(rand(50,15) * StripeSize*2);  %�����������,50��15��1��StripeSize�������
LZuHe = cell(1,15);
for i = 1:1:15
    for j = 1:1:50
        LZuHe{1,i} = [ LZuHe{1,i} ;  EqualSpaceStripe(:,:,Random(j,i))];
    end
end

for i = 1:1:15
    Lcount = LZuHe{1,i};
    for l = 200:20:10000    %�����ʾȡ�����߶εĳ���
        LcountLength = l;
        avrZ = sum(Lcount(1:l,3))/LcountLength;
        FenMu = 0;
        %�����ĸ
        for m = 1:1:LcountLength
            FenMu = FenMu + (Lcount(m,3) - avrZ)^2;
        end
        %������Ӻ�
        corr = zeros(1,LcountLength);
        for k = 0:1:LcountLength - 1;
            FenZiHe = 0;
            for p = 1:1:LcountLength - k
                FenZiHe = FenZiHe + (Lcount(p,3) - avrZ) * (Lcount(p + k,3) - avrZ);
            end
            corr(1,k+1) = FenZiHe/FenMu;
            %�˲�����corrС��0.3ʱ�Ͳ��ټ��㣬Ϊ���Ǽ�С�����ĸ��Ӷ�
            if (corr(1,k+1) < 0.3)
                break;
            end
            %�˲�����corrС��0.3ʱ�Ͳ��ټ��㣬Ϊ���Ǽ�С�����ĸ��Ӷ�
        end
        
        for x = 1:1:LcountLength
            if((corr(1,x) >= exp(-1)) &&  (corr(1,x+1) <= exp(-1)))
                minLocation = x;
                break;
            end
        end
        %[minNum,minLocation] = min(abs(corr - minuent));
        corrL((l-180)/20,i) = sqrt((Lcount(2,1) - Lcount(minLocation,1))^2 + (Lcount(2,2) - Lcount(minLocation,2))^2) + 0.005 * (corr(1,minLocation) - exp(-1))/(corr(1,minLocation) - corr(1,minLocation+1)) ;%�����س��ȵļ�����Ϊ���ںܶ�һ���ļ������������𣬺����ⲿ���൱�ڼ������1/e���׿���ʲôλ��
    end
end

LLength = mean(corrL(491,:));     %���������߶ε�L����ʾL����ֵ

%����ƽ������س���%
LAvr = zeros(491,1);
for i = 1:1:491
    LAvr(i,1) = mean(corrL(i,:));
end




%%%%X��������Ϊ�˸ı������Ϊ����
X = zeros(1,491);
for i = 1:1:491
    X(1,i) = 0.9 + i*0.1;
end
%%%%X��������Ϊ�˸ı������Ϊ����

%lineL����س��ȵ�ֱ��
lineL = zeros(1,50);
for i = 1:1:50
    lineL(1,i) = LLength;
end
%lineL����س��ȵ�ֱ��

% %%%%%%%%%%%%%%%�ⲿ���ǹ���L��������ȹ�ϵ�Ļ�ͼ%%%%%%%%%%%%%%%
LText = num2str(LLength);
firstText = 'ƽ��L = ';
WholeText = [firstText , LText];
plot(X,LAvr,'k','LineWidth',3);hold on;
for i = 1:1:15
    plot(X , corrL(:,i) );hold on;
end
plot(X,LAvr,'k','LineWidth',3);hold on;
% plot(lineL,'-.k','LineWidth',1.8);hold on;
xlabel('�������ȣ��ף�','fontsize',16,'FontWeight','bold');
ylabel('��س��ȣ��ף�','fontsize',16,'FontWeight','bold');
set(gcf,'unit','centimeters','position',[1,2,20,14]); %���ƻ�ͼ����Ĵ�Сͳһ
set(gca,'FontSize',16);                               %�ı�������������С
h = legend( '����ֵ��');                       
set(h,'FontSize',16,'FontWeight','normal');
% text(30,0.34, WholeText ,'FontSize',16);
% %%%%%%%%%%%%%%%�ⲿ���ǹ���L��������ȹ�ϵ�Ļ�ͼ%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%����corrL����ֵL�����%%%%%%%%%%%%%%%
erro = zeros(491,15);
for i = 1:1:491
    for j = 1:1:15
        erro(i,j) = (abs(corrL(i,j) - LLength)) / LLength;    %�˴���Ҫ����ÿ�����õ���s�����иı�,����ƽ�����       
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
%%%%�˲�����ʾ���ڲ������������%%%%
% plot(X,erroMean,'or');hold on;
% plot(X,erroMax,'xb');hold on;
% plot(line3,'-k','LineWidth',1.8);hold on;
% plot(line4,':k','LineWidth',1.8);grid on;
% xlabel('�������ȣ��ף�','fontsize',16,'FontWeight','bold');
% ylabel('��س������','fontsize',16,'FontWeight','bold');
% set(gcf,'unit','centimeters','position',[1,2,20,14]); %���ƻ�ͼ����Ĵ�Сͳһ
% set(gca,'FontSize',16);                               %�ı�������������С
% tuli = legend('ƽ�����','������','10%���','5%���');
% set(tuli,'FontSize',16);

%%%%%%%%%%%%%%����corrL����ֵL�����%%%%%%%%%%%%%%%