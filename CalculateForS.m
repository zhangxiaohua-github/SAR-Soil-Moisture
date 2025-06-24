%���ȶ�ȡ���ݣ�ʹ�õ�������������������ݽ��н��չʾ
% image = xlsread('E:\�ж� ��ѧ��\6-14ũ�ƴ�ʵ�ز���\ũ�ƴ����� ��������\19-06-14-0506\19-06-14-0506_2.csv');  %����
% image = xlsread('E:\�ж� ��ѧ��\6-14ũ�ƴ�ʵ�ز���\ũ�ƴ����� ��������\19-06-14-0708\19-06-14-0708_2.csv');  %����
% image = xlsread('E:\�ж� ��ѧ��\6-14ũ�ƴ�ʵ�ز���\ũ�ƴ����� ��������\19-06-14-0910\19-06-14-0910_2.csv');  %����
image = xlsread('E:\�ж� ��ѧ��\6-14ũ�ƴ�ʵ�ز���\ũ�ƴ����� ��������\19-06-14-1112\19-06-14-1112.csv');  %����

% sReal = 0.018;
% sReal = 0.0227;
% sReal = 0.0352;
sReal = 0.0207;    %%%�ֶ�����s�ġ���ֵ��
%%%%%����s����ֵ%%%%%
imageLength = image(1,1);


%��������һ��Ϊ��λ�洢��һ�������ά������
LineSize = 698;
StripeSize = image(1,1) / LineSize;

Stripe = zeros(LineSize , 3 , StripeSize);

for i = 1:1:StripeSize
    for j = 1:1:LineSize
        Stripe(: , 1:3 , i) = image((i-1) * LineSize + 2 : i * LineSize + 1 , 1:3 );
    end    
end

%��һ���������洢��Ҫ�Ľ������ȡ��Ϊx������£��õ���sֵ������xΪѡ��Ĳ�������ĸ�����sΪ��Щ��������ľ������߶ȣ�

WholeOut = zeros(300,20); %50��ʾ����ĸ�����1~50,10��ʾÿ���������ѡȡ10�����ȡ��
for i = 1:1:300           %�˲�ѭ����ʾѡȡ�������ĸ���
    %���ȹ�������i��������������У��Ծ������ʽ�洢
    Random = ceil(rand(20,i) * StripeSize);  %������������� 
    sumSize = LineSize * i;
    
    %����20�����ѡȡ������ľ������ߵ�
    for j = 1:1:20        %�˲�ѭ����ָ���ô�ѡȡ�Ľ��
        %ÿ�μ�����������ľ������߶�
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

%%%%%%%%�˲�����Ϊ�˶����ɵĲ���׼ȷ��ͼ������ʾ%%%%%%%%
line1 = zeros(300,1);
% line2 = zeros(300,1);
for i = 1:1:300
    line1(i,1) = sReal;
%     line2(i,1) = 0.02157;
end

%%%%%��ʾ��ͼ���ִ���%%%%%%%
plot(line1,'-.k','LineWidth',1.8);hold on;
plot(WholeOut,'.r');hold on;
plot(line1,'-.k','LineWidth',1.8);

grid on;
xlabel('��������','fontsize',16,'FontWeight','bold');
ylabel('�������߶�RMS(��)','fontsize',16,'FontWeight','bold');
set(gcf,'unit','centimeters','position',[1,2,20,14]); %���ƻ�ͼ����Ĵ�Сͳһ
set(gca,'xtick',0:50:300);  %����x��ķ�Χ     
set(gca,'FontSize',16);                               %�ı�������������С
axis([0,300,0,0.03]) ;
h = legend( '����ֵ��', '����ֵ');                       
set(h,'FontSize',16,'FontWeight','normal');



%%%%%��ʾ��ͼ���ִ���%%%%%%%
%%%%%%%�˲�����Ϊ�˶����ɵĲ���׼ȷ��ͼ������ʾ%%%%%%%%

% %%%%%%����ÿ�����������ľ�ȷ�ȣ�����ÿ������������ÿ�γ�������ƽ����%%%%%%%%%%%
erro = zeros(300,20);

for i = 1:1:300
    for j = 1:1:20
        erro(i,j) = (abs(WholeOut(i,j) - sReal)) / sReal;    %�˴���Ҫ����ÿ�����õ���s�����иı�,����ƽ�����       
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
% %%%%�˲�����ʾ���ڲ������������%%%%
% plot(erroMean,'or');hold on;
% plot(erroMax,'xb');hold on;
% plot(line3,'-k','LineWidth',1.8);hold on;
% plot(line4,':k','LineWidth',1.8);grid on;
% 
% grid on;
% xlabel('��������','fontsize',16,'FontWeight','bold');
% ylabel('�������߶����','fontsize',16,'FontWeight','bold');
% set(gcf,'unit','centimeters','position',[1,2,20,14]); %���ƻ�ͼ����Ĵ�Сͳһ
% set(gca,'xtick',0:50:300);  %����x��ķ�Χ     
% % axis([0,300,0,0.035]) ;
% set(gca,'FontSize',16);                               %�ı�������������С
% tuli = legend('ƽ��������','���������','10%�����','5%�����');
% set(tuli,'FontSize',16);

% % %%%%�˲�����ʾ���ڲ������������%%%%
% %%%%%%����ÿ�����������ľ�ȷ�ȣ�����ÿ������������ÿ�γ�������ƽ����%%%%%%%%%%%
