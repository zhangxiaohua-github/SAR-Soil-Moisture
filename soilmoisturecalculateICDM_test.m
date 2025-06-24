%%%��ȡ����������Ϣ%%%
[noUes,range] = geotiffread('G:\project\20200818\sentinel1_33_20190818_231941615_IW_SIW1_D_VV_cut_slc_list_pwr_geo_ql.tif'); %%rangeΪ������Ϣ
%%%��ȡ����������Ϣ%%%

%%%%�ļ���%%%%
% filePath = 'D:\BiyeData\sentinel1-PDtif-LuoTu';
filePath = 'G:\data\20180818\input';
dirFile = dir(filePath);
[DataNum,noUse] = size(dirFile);
DataLength = (DataNum-2); %��ȡ���ݵ�����
%%%%�ļ���%%%%

%���ȶ�ȡVH���ݣ�����һ��cell���洢VH����
% VH_tif = cell(DataLength,1);
% for i = 1:1:32
%     fileName = dirFile(i,1).name;
%     PathName = [filePath,'\',fileName];
%     VH_tif{i , 1} = imread(PathName);
% end
% 
RiQi = cell(DataLength,1);

%��ȡVV���ݣ�����һ��cell���洢VH����
VV_tif = cell(DataLength,1);
for i = 1:1:30
    fileName = dirFile(i,1).name;
    
    RiQi{i, 1} = fileName(1:1);
    
    PathName = [filePath,'\',fileName];
    VV_tif{i, 1} = imread(PathName);
end

%%%%������ʱ��ĺ���ɢ��ϵ�����ݴ洢��������ά�����У�ǰ������ͼ��ĳ��Ϳ���������ʱ��%%%%%%
[length,width] = size(VH_tif{1,1});
% VHTifMap = zeros(length,width,DataLength);   %%%�洢VH���ݵ���ά����
VVTifMap = zeros(length,width,DataLength);   %%%�洢VH���ݵ���ά����

for i = 1:1:DataLength
%     VHTifMap(:,:,i) = VH_tif{i,1};
    VVTifMap(:,:,i) = VV_tif{i,1};
end
%%%%������ʱ��ĺ���ɢ��ϵ�����ݴ洢��������ά�����У�ǰ������ͼ��ĳ��Ϳ���������ʱ��%%%%%%


%%%%%�ԴֲڶȽ���У�����ֲڶȹ�һ����%%%%%
VV_VHtifMap = zeros(length,width,DataLength);   %%%�洢VV-VH���ݵ���ά����
for i=1:1:length
    for j=1:1:width
        for k=1:1:DataLength
            VV_VHtifMap(i,j,k) = VVTifMap(i,j,k) - VHTifMap(i,j,k);
%             if(VV_VHtifMap(i,j,k) > 12)
%                 VV_VHtifMap(i,j,k) = 12;
%             elseif(VV_VHtifMap(i,j,k) < 6)
%                 VV_VHtifMap(i,j,k) = 6;
%             end
        end
    end
end

VVTifMapChange = zeros(length,width,DataLength);   %%%�洢�ֲڶ�У�����VV������ά����
for i=1:1:length
    for j=1:1:width
        for k=1:1:DataLength
%             VVTifMapChange(i,j,k) = VVTifMap(i,j,k) - 0.875 * (VV_VHtifMap(i,j,k) -6); %%%%����һ����6��Ŀǰ�õ������Թ�һ��
            VVTifMapChange(i,j,k) = VVTifMap(i,j,k) + 20.35 * log(VV_VHtifMap(i,j,k)) -36.45; %%%%����һ����6��Ŀǰ�õ������Թ�һ��
        end
    end
end
%%%%%�ԴֲڶȽ���У�����ֲڶȹ�һ����%%%%%


%%%����Mask�ļ�,30��20�ֱ��ʾۯ����������ͷ��ݸ�����%%%%
Mask = zeros(length,width);
for i=1:1:length
    for j=1:1:width
        if(noUes(i,j) == 30) 
            Mask(i,j) = 1;
        end
        if(noUes(i,j) == 20)
            Mask(i,j) = 2;
        end
    end
end
%%%����Mask�ļ�%%%%

%%%%%%%�ҳ�ÿ����ȡ��ˮ�������ص��ϵ���Сֵ�����ֵ�����ɺ�ˮ������ʱ�̺ͺ�ˮ����С��ʱ��%%%%%%%
MaxVV = zeros(length,width);
MinVV = zeros(length,width);
MaxVH = zeros(length,width);
MinVH = zeros(length,width);
MaxVVDate = zeros(length,width);
MinVVDate = zeros(length,width);

MaxVV_ = zeros(length,width);
MinVV_ = zeros(length,width);
MaxVVDate_ = zeros(length,width);
MinVVDate_ = zeros(length,width);

for i=1:1:length
    for j=1:1:width
        if(Mask(i,j) == 1)
            MaxVV(i,j) = 300;
            MinVV(i,j) = 300;
            MaxVVDate(i,j) = 300;
            MinVVDate(i,j) = 300;
            
            MaxVV_(i,j) = 300;
            MinVV_(i,j) = 300;
            MaxVVDate_(i,j) = 300;
            MinVVDate_(i,j) = 300;
        end
        if(Mask(i,j) == 2)
            MaxVV(i,j) = 200;
            MinVV(i,j) = 200;
            MaxVVDate(i,j) = 200;
            MinVVDate(i,j) = 200;
            
            MaxVV_(i,j) = 200;
            MinVV_(i,j) = 200;
            MaxVVDate_(i,j) = 200;
            MinVVDate_(i,j) = 200;
        end
        if Mask(i,j) == 0  %maskΪ0�����ز�����������
            [MaxVV(i,j) , MaxVVDate(i,j)] = max(VVTifMapChange(i,j,:));
            [MinVV(i,j) , MinVVDate(i,j)] = min(VVTifMapChange(i,j,:));
            
            [MaxVV_(i,j) , MaxVVDate_(i,j)] = max(VVTifMap(i,j,:));
            [MinVV_(i,j) , MinVVDate_(i,j)] = min(VVTifMap(i,j,:));
            
            MaxVH(i,j) = max(VHTifMap(i,j,:));
            MinVH(i,j) = min(VHTifMap(i,j,:));
        end
    end
end
%%%%%%%�ҳ�ÿ����ȡ��ˮ�������ص��ϵ���Сֵ�����ֵ�����ɺ�ˮ������ʱ�̺ͺ�ˮ����С��ʱ��%%%%%%%


% %%%���������ʪ�ο�ֵ%%%%%
% geotiffwrite('D:\BiyeData\sentinel1-ICDM\ԭʼ\MaxVV.tif',MaxVV,range);
% geotiffwrite('D:\BiyeData\sentinel1-ICDM\ԭʼ\MinVV.tif',MinVV,range);
% geotiffwrite('D:\BiyeData\sentinel1-ICDM\ԭʼ\MaxVH.tif',MaxVH,range);
% geotiffwrite('D:\BiyeData\sentinel1-ICDM\ԭʼ\MinVH.tif',MinVH,range);
% geotiffwrite('D:\BiyeData\sentinel1-ICDM\ԭʼ\MaxVVDate.tif',MaxVVDate,range);
% geotiffwrite('D:\BiyeData\sentinel1-ICDM\ԭʼ\MinVVDate.tif',MinVVDate,range);
% 
% geotiffwrite('D:\BiyeData\sentinel1-ICDM\ԭʼ\MaxVV_.tif',MaxVV_,range);
% geotiffwrite('D:\BiyeData\sentinel1-ICDM\ԭʼ\MinVV_.tif',MinVV_,range);
% geotiffwrite('D:\BiyeData\sentinel1-ICDM\ԭʼ\MaxVVDate_.tif',MaxVVDate_,range);
% geotiffwrite('D:\BiyeData\sentinel1-ICDM\ԭʼ\MinVVDate_.tif',MinVVDate_,range);
% %%%���������ʪ�ο�ֵ%%%%%

%%%%%%%����ÿ��ͼ���ϵĿ�̽������Ժ�ˮ��
%�ȸ���ˮ������ֵΪ-1�������������
VM = zeros(length,width,DataLength);
for i=1:1:length
    for j=1:1:width
        for k=1:1:DataLength
            VM(i,j,k) = -1;
        end
    end
end

for i=1:1:length
    for j=1:1:width
        if Mask(i,j) == 1
            VM(i,j,:) = 30;
        end
        if Mask(i,j) == 2;
            VM(i,j,:) = 20;
        end
        if Mask(i,j) == 0
            for k=1:1:DataLength
%                 VM(i,j,k) = (VVTifMapChange(i,j,k)-MinVV(i,j))/(MaxVV(i,j)-MinVV(i,j));   %%%%%ʹ��ICDM%%%%
                VM(i,j,k) = (VVTifMap(i,j,k)-MinVV_(i,j))/(MaxVV_(i,j)-MinVV_(i,j));   %%%%%ʹ��CDM%%%%
            end
        end
    end
end
%%%%%%%����ÿ��ͼ���ϵĿ�̽������Ժ�ˮ��

% %%%������Ժ�ˮ����ͨ��SMAP���������㣬���Լ���%%%
% VMreal = zeros(length,width,DataLength);
% for k = 1:1:DataLength
%     for i=1:1:466
%         for j=1:1:622%%��1
%             if(VM(i,j,k) == 30)
%                 VMreal(i,j,k) = 30;
%             end
%             if(VM(i,j,k) == 20)
%                 VMreal(i,j,k) = 20;
%             end
%             if(VM(i,j,k) ~= 20 && VM(i,j,k) ~= 30)
%                 VMreal(i,j,k) = VM(i,j,k) * 0.295 + 0.116;
%             end
%         end
%         
%         for j=623:1:1182%%��2
%             if(VM(i,j,k) == 30)
%                 VMreal(i,j,k) = 30;
%             end
%             if(VM(i,j,k) == 20)
%                 VMreal(i,j,k) = 20;
%             end
%             if(VM(i,j,k) ~= 20 && VM(i,j,k) ~= 30)
%                 VMreal(i,j,k) = VM(i,j,k) * 0.323 + 0.116;
%             end
%         end
%         
%         for j=1183:1:1742%%��3
%             if(VM(i,j,k) == 30)
%                 VMreal(i,j,k) = 30;
%             end
%             if(VM(i,j,k) == 20)
%                 VMreal(i,j,k) = 20;
%             end
%             if(VM(i,j,k) ~= 20 && VM(i,j,k) ~= 30)
%                 VMreal(i,j,k) = VM(i,j,k) * 0.358 + 0.102;
%             end
%         end
%         
%         for j=1742:1:2002%%
%             if(VM(i,j,k) == 30)
%                 VMreal(i,j,k) = 30;
%             end
%             if(VM(i,j,k) == 20)
%                 VMreal(i,j,k) = 20;
%             end
%             if(VM(i,j,k) ~= 20 && VM(i,j,k) ~= 30)
%                 VMreal(i,j,k) = VM(i,j,k) * 0.404 + 0.02;
%             end
%         end
%     end
%     
%     for i=467:1:958
%         for j=1:1:622%%��4,�˴��޸Ĺ�
%             if(VM(i,j,k) == 30)
%                 VMreal(i,j,k) = 30;
%             end
%             if(VM(i,j,k) == 20)
%                 VMreal(i,j,k) = 20;
%             end
%             if(VM(i,j,k) ~= 20 && VM(i,j,k) ~= 30)
%                 VMreal(i,j,k) = VM(i,j,k) * 0.344 + 0.08;
%             end
%         end
%         
%         for j=623:1:1182%%��5
%             if(VM(i,j,k) == 30)
%                 VMreal(i,j,k) = 30;
%             end
%             if(VM(i,j,k) == 20)
%                 VMreal(i,j,k) = 20;
%             end
%             if(VM(i,j,k) ~= 20 && VM(i,j,k) ~= 30)
%                 VMreal(i,j,k) = VM(i,j,k) * 0.44 + 0.02;
%             end
%         end
%         
%         for j=1183:1:1742%%��6
%             if(VM(i,j,k) == 30)
%                 VMreal(i,j,k) = 30;
%             end
%             if(VM(i,j,k) == 20)
%                 VMreal(i,j,k) = 20;
%             end
%             if(VM(i,j,k) ~= 20 && VM(i,j,k) ~= 30)
%                 VMreal(i,j,k) = VM(i,j,k) * 0.398 + 0.046;
%             end
%         end
%         
%         for j=1742:1:2002%%��7
%             if(VM(i,j,k) == 30)
%                 VMreal(i,j,k) = 30;
%             end
%             if(VM(i,j,k) == 20)
%                 VMreal(i,j,k) = 20;
%             end
%             if(VM(i,j,k) ~= 20 && VM(i,j,k) ~= 30)
%                 VMreal(i,j,k) = VM(i,j,k) * 0.442 + 0.029;
%             end
%         end
%     end
%     
%     
%     for i=959:1:1450
%         for j=1:1:622%%��8
%             if(VM(i,j,k) == 30)
%                 VMreal(i,j,k) = 30;
%             end
%             if(VM(i,j,k) == 20)
%                 VMreal(i,j,k) = 20;
%             end
%             if(VM(i,j,k) ~= 20 && VM(i,j,k) ~= 30)
%                 VMreal(i,j,k) = VM(i,j,k) * 0.41 + 0.02;
%             end
%         end
%         
%         for j=623:1:1182%%��9
%             if(VM(i,j,k) == 30)
%                 VMreal(i,j,k) = 30;
%             end
%             if(VM(i,j,k) == 20)
%                 VMreal(i,j,k) = 20;
%             end
%             if(VM(i,j,k) ~= 20 && VM(i,j,k) ~= 30)
%                 VMreal(i,j,k) = VM(i,j,k) * 0.44 + 0.02;
%             end
%         end
%         
%         for j=1183:1:1742%%��10
%             if(VM(i,j,k) == 30)
%                 VMreal(i,j,k) = 30;
%             end
%             if(VM(i,j,k) == 20)
%                 VMreal(i,j,k) = 20;
%             end
%             if(VM(i,j,k) ~= 20 && VM(i,j,k) ~= 30)
%                 VMreal(i,j,k) = VM(i,j,k) * 0.421 + 0.02;
%             end
%         end
%         
%         for j=1742:1:2002%%��11
%             if(VM(i,j,k) == 30)
%                 VMreal(i,j,k) = 30;
%             end
%             if(VM(i,j,k) == 20)
%                 VMreal(i,j,k) = 20;
%             end
%             if(VM(i,j,k) ~= 20 && VM(i,j,k) ~= 30)
%                 VMreal(i,j,k) = VM(i,j,k) * 0.448 + 0.02;
%             end
%         end
%     end
% end
% 
% 
% %%%�����о���������ƽ����ˮ��%%%%
% MvWholeMean = zeros(1,30);
% MvYouZhi = zeros(30,20000);
% for k = 1:1:30
%     countNum = 0;
%     x=1;
%     for i = 1:1:1450
%         for j = 1:1:2002
%             if(VMreal(i,j,k) ~= 20 && VMreal(i,j,k) ~= 30)
%                 MvYouZhi(k,x) = VMreal(i,j,k);
%                 x = x +1;
% %                 countNum = countNum + 1;
% %                 MvHe = MvHe +  VMreal(i,j,k);
%             end
%         end
%     end
% %     MvWholeMean(1,k) = MvHe/countNum;
% end
% 
% for i =1:1:30
%     MvWholeMean(1,i) = mean(MvYouZhi(i,1:1000:1000000));%ÿ��1000������ȡһ����Ϊ�˽��ͳ��������ʱ��%%
% end
% xlswrite('D:\BiyeData\sentinel1-ICDM\ICDM.xlsx',MvWholeMean);
% %%%�����о���������ƽ����ˮ��%%%%
% 
% %%%%%�洢��Щ��Ժ�ˮ������%%%%%%
% % geotiffwrite('D:\BiyeData\sentinel1-ICDM\RelMv\0109RelMv.tif',VM(:,:,1),range);
% % geotiffwrite('D:\BiyeData\sentinel1-ICDM\RelMv\0121RelMv.tif',VM(:,:,2),range);
% % geotiffwrite('D:\BiyeData\sentinel1-ICDM\RelMv\0202RelMv.tif',VM(:,:,3),range);
% % geotiffwrite('D:\BiyeData\sentinel1-ICDM\RelMv\0214RelMv.tif',VM(:,:,4),range);
% % geotiffwrite('D:\BiyeData\sentinel1-ICDM\RelMv\0226RelMv.tif',VM(:,:,5),range);
% % geotiffwrite('D:\BiyeData\sentinel1-ICDM\RelMv\0310RelMv.tif',VM(:,:,6),range);
% % geotiffwrite('D:\BiyeData\sentinel1-ICDM\RelMv\0322RelMv.tif',VM(:,:,7),range);
% % geotiffwrite('D:\BiyeData\sentinel1-ICDM\RelMv\0403RelMv.tif',VM(:,:,8),range);
% % geotiffwrite('D:\BiyeData\sentinel1-ICDM\RelMv\0415RelMv.tif',VM(:,:,9),range);
% % geotiffwrite('D:\BiyeData\sentinel1-ICDM\RelMv\0427RelMv.tif',VM(:,:,10),range);
% % geotiffwrite('D:\BiyeData\sentinel1-ICDM\RelMv\0509RelMv.tif',VM(:,:,11),range);
% % geotiffwrite('D:\BiyeData\sentinel1-ICDM\RelMv\0521RelMv.tif',VM(:,:,12),range);
% % geotiffwrite('D:\BiyeData\sentinel1-ICDM\RelMv\0602RelMv.tif',VM(:,:,13),range);
% % geotiffwrite('D:\BiyeData\sentinel1-ICDM\RelMv\0614RelMv.tif',VM(:,:,14),range);
% % geotiffwrite('D:\BiyeData\sentinel1-ICDM\RelMv\0626RelMv.tif',VM(:,:,15),range);
% % geotiffwrite('D:\BiyeData\sentinel1-ICDM\RelMv\0708RelMv.tif',VM(:,:,16),range);
% % geotiffwrite('D:\BiyeData\sentinel1-ICDM\RelMv\0720RelMv.tif',VM(:,:,17),range);
% % geotiffwrite('D:\BiyeData\sentinel1-ICDM\RelMv\0813RelMv.tif',VM(:,:,18),range);
% % geotiffwrite('D:\BiyeData\sentinel1-ICDM\RelMv\0825RelMv.tif',VM(:,:,19),range);
% % geotiffwrite('D:\BiyeData\sentinel1-ICDM\RelMv\0906RelMv.tif',VM(:,:,20),range);
% % geotiffwrite('D:\BiyeData\sentinel1-ICDM\RelMv\0918RelMv.tif',VM(:,:,21),range);
% % geotiffwrite('D:\BiyeData\sentinel1-ICDM\RelMv\0930RelMv.tif',VM(:,:,22),range);
% % geotiffwrite('D:\BiyeData\sentinel1-ICDM\RelMv\1024RelMv.tif',VM(:,:,23),range);
% % geotiffwrite('D:\BiyeData\sentinel1-ICDM\RelMv\1105RelMv.tif',VM(:,:,24),range);
% % geotiffwrite('D:\BiyeData\sentinel1-ICDM\RelMv\1117RelMv.tif',VM(:,:,25),range);
% % geotiffwrite('D:\BiyeData\sentinel1-ICDM\RelMv\1129RelMv.tif',VM(:,:,26),range);
% % geotiffwrite('D:\BiyeData\sentinel1-ICDM\RelMv\1211RelMv.tif',VM(:,:,27),range);
% % geotiffwrite('D:\BiyeData\sentinel1-ICDM\RelMv\1223RelMv.tif',VM(:,:,28),range);
% % geotiffwrite('D:\BiyeData\sentinel1-ICDM\RelMv\181228RelMv.tif',VM(:,:,29),range);
% % geotiffwrite('D:\BiyeData\sentinel1-ICDM\RelMv\200104RelMv.tif',VM(:,:,30),range);
% 
% 
% % geotiffwrite('D:\BiyeData\sentinel1-ICDM\realMv\0109Mv.tif',VMreal(:,:,1),range);
% % geotiffwrite('D:\BiyeData\sentinel1-ICDM\realMv\0121Mv.tif',VMreal(:,:,2),range);
% % geotiffwrite('D:\BiyeData\sentinel1-ICDM\realMv\0202Mv.tif',VMreal(:,:,3),range);
% % geotiffwrite('D:\BiyeData\sentinel1-ICDM\realMv\0214Mv.tif',VMreal(:,:,4),range);
% % geotiffwrite('D:\BiyeData\sentinel1-ICDM\realMv\0226Mv.tif',VMreal(:,:,5),range);
% % geotiffwrite('D:\BiyeData\sentinel1-ICDM\realMv\0310Mv.tif',VMreal(:,:,6),range);
% % geotiffwrite('D:\BiyeData\sentinel1-ICDM\realMv\0322Mv.tif',VMreal(:,:,7),range);
% % geotiffwrite('D:\BiyeData\sentinel1-ICDM\realMv\0403Mv.tif',VMreal(:,:,8),range);
% % geotiffwrite('D:\BiyeData\sentinel1-ICDM\realMv\0415Mv.tif',VMreal(:,:,9),range);
% % geotiffwrite('D:\BiyeData\sentinel1-ICDM\realMv\0427Mv.tif',VMreal(:,:,10),range);
% % geotiffwrite('D:\BiyeData\sentinel1-ICDM\realMv\0509Mv.tif',VMreal(:,:,11),range);
% % geotiffwrite('D:\BiyeData\sentinel1-ICDM\realMv\0521Mv.tif',VMreal(:,:,12),range);
% % geotiffwrite('D:\BiyeData\sentinel1-ICDM\realMv\0602Mv.tif',VMreal(:,:,13),range);
% % geotiffwrite('D:\BiyeData\sentinel1-ICDM\realMv\0614Mv.tif',VMreal(:,:,14),range);
% % geotiffwrite('D:\BiyeData\sentinel1-ICDM\realMv\0626Mv.tif',VMreal(:,:,15),range);
% % geotiffwrite('D:\BiyeData\sentinel1-ICDM\realMv\0708Mv.tif',VMreal(:,:,16),range);
% % geotiffwrite('D:\BiyeData\sentinel1-ICDM\realMv\0720Mv.tif',VMreal(:,:,17),range);
% % geotiffwrite('D:\BiyeData\sentinel1-ICDM\realMv\0813Mv.tif',VMreal(:,:,18),range);
% % geotiffwrite('D:\BiyeData\sentinel1-ICDM\realMv\0825Mv.tif',VMreal(:,:,19),range);
% % geotiffwrite('D:\BiyeData\sentinel1-ICDM\realMv\0906Mv.tif',VMreal(:,:,20),range);
% % geotiffwrite('D:\BiyeData\sentinel1-ICDM\realMv\0918Mv.tif',VMreal(:,:,21),range);
% % geotiffwrite('D:\BiyeData\sentinel1-ICDM\realMv\0930Mv.tif',VMreal(:,:,22),range);
% % geotiffwrite('D:\BiyeData\sentinel1-ICDM\realMv\1024Mv.tif',VMreal(:,:,23),range);
% % geotiffwrite('D:\BiyeData\sentinel1-ICDM\realMv\1105Mv.tif',VMreal(:,:,24),range);
% % geotiffwrite('D:\BiyeData\sentinel1-ICDM\realMv\1117Mv.tif',VMreal(:,:,25),range);
% % geotiffwrite('D:\BiyeData\sentinel1-ICDM\realMv\1129Mv.tif',VMreal(:,:,26),range);
% % geotiffwrite('D:\BiyeData\sentinel1-ICDM\realMv\1211Mv.tif',VMreal(:,:,27),range);
% % geotiffwrite('D:\BiyeData\sentinel1-ICDM\realMv\1223Mv.tif',VMreal(:,:,28),range);
% % geotiffwrite('D:\BiyeData\sentinel1-ICDM\realMv\181228Mv.tif',VMreal(:,:,29),range);
% % geotiffwrite('D:\BiyeData\sentinel1-ICDM\realMv\200104Mv.tif',VMreal(:,:,30),range);
% 
% % geotiffwrite('D:\BiyeData\sentinel1-ICDM\realMv1\0109Mv.tif',VMreal(:,:,1),range);
% % geotiffwrite('D:\BiyeData\sentinel1-ICDM\realMv1\0121Mv.tif',VMreal(:,:,2),range);
% % geotiffwrite('D:\BiyeData\sentinel1-ICDM\realMv1\0202Mv.tif',VMreal(:,:,3),range);
% % geotiffwrite('D:\BiyeData\sentinel1-ICDM\realMv1\0214Mv.tif',VMreal(:,:,4),range);
% % geotiffwrite('D:\BiyeData\sentinel1-ICDM\realMv1\0226Mv.tif',VMreal(:,:,5),range);
% % geotiffwrite('D:\BiyeData\sentinel1-ICDM\realMv1\0310Mv.tif',VMreal(:,:,6),range);
% % geotiffwrite('D:\BiyeData\sentinel1-ICDM\realMv1\0322Mv.tif',VMreal(:,:,7),range);
% % geotiffwrite('D:\BiyeData\sentinel1-ICDM\realMv1\0403Mv.tif',VMreal(:,:,8),range);
% % geotiffwrite('D:\BiyeData\sentinel1-ICDM\realMv1\0415Mv.tif',VMreal(:,:,9),range);
% % geotiffwrite('D:\BiyeData\sentinel1-ICDM\realMv1\0427Mv.tif',VMreal(:,:,10),range);
% % geotiffwrite('D:\BiyeData\sentinel1-ICDM\realMv1\0509Mv.tif',VMreal(:,:,11),range);
% % geotiffwrite('D:\BiyeData\sentinel1-ICDM\realMv1\0521Mv.tif',VMreal(:,:,12),range);
% % geotiffwrite('D:\BiyeData\sentinel1-ICDM\realMv1\0602Mv.tif',VMreal(:,:,13),range);
% % geotiffwrite('D:\BiyeData\sentinel1-ICDM\realMv1\0614Mv.tif',VMreal(:,:,14),range);
% % geotiffwrite('D:\BiyeData\sentinel1-ICDM\realMv1\0626Mv.tif',VMreal(:,:,15),range);
% % geotiffwrite('D:\BiyeData\sentinel1-ICDM\realMv1\0708Mv.tif',VMreal(:,:,16),range);
% % geotiffwrite('D:\BiyeData\sentinel1-ICDM\realMv1\0720Mv.tif',VMreal(:,:,17),range);
% % geotiffwrite('D:\BiyeData\sentinel1-ICDM\realMv1\0813Mv.tif',VMreal(:,:,18),range);
% % geotiffwrite('D:\BiyeData\sentinel1-ICDM\realMv1\0825Mv.tif',VMreal(:,:,19),range);
% % geotiffwrite('D:\BiyeData\sentinel1-ICDM\realMv1\0906Mv.tif',VMreal(:,:,20),range);
% % geotiffwrite('D:\BiyeData\sentinel1-ICDM\realMv1\0918Mv.tif',VMreal(:,:,21),range);
% % geotiffwrite('D:\BiyeData\sentinel1-ICDM\realMv1\0930Mv.tif',VMreal(:,:,22),range);
% % geotiffwrite('D:\BiyeData\sentinel1-ICDM\realMv1\1024Mv.tif',VMreal(:,:,23),range);
% % geotiffwrite('D:\BiyeData\sentinel1-ICDM\realMv1\1105Mv.tif',VMreal(:,:,24),range);
% % geotiffwrite('D:\BiyeData\sentinel1-ICDM\realMv1\1117Mv.tif',VMreal(:,:,25),range);
% % geotiffwrite('D:\BiyeData\sentinel1-ICDM\realMv1\1129Mv.tif',VMreal(:,:,26),range);
% % geotiffwrite('D:\BiyeData\sentinel1-ICDM\realMv1\1211Mv.tif',VMreal(:,:,27),range);
% % geotiffwrite('D:\BiyeData\sentinel1-ICDM\realMv1\1223Mv.tif',VMreal(:,:,28),range);
% % geotiffwrite('D:\BiyeData\sentinel1-ICDM\realMv1\181228Mv.tif',VMreal(:,:,29),range);
% % geotiffwrite('D:\BiyeData\sentinel1-ICDM\realMv1\200104Mv.tif',VMreal(:,:,30),range);
% % %%%%%�洢��Щ��Ժ�ˮ������%%%%%%
% % 
% % 
% % %%%%%%%%%��ÿ����ˮ����Ӧ��ֵ������ɫ
% % Out = zeros(length,width,DataLength,3);
% % for i=1:1:length
% %     for j=1:1:width
% %         for k=1:1:DataLength
% %             if VM(i,j,k) == 20
% %                R=255/255;G=255/255;B=255/255;                                   %��ɫ
% %                Out(i,j,k,1)=R;Out(i,j,k,2)=G;Out(i,j,k,3)=B;
% %            elseif VM(i,j,k) == 30
% %                R=100/255;G=100/255;B=100/255;                                       %�ֺ�ɫ
% %                Out(i,j,k,1)=R;Out(i,j,k,2)=G;Out(i,j,k,3)=B;   
% %             elseif VM(i,j,k) == 0
% %                R=151/255;G=2/255;B=9/255;                                       %�ֺ�ɫ
% %                Out(i,j,k,1)=R;Out(i,j,k,2)=G;Out(i,j,k,3)=B;   
% %             elseif VM(i,j,k) < 0.1
% %                R=243/255;G=0/255;B=9/255;                                       %���ɫ
% %                Out(i,j,k,1)=R;Out(i,j,k,2)=G;Out(i,j,k,3)=B;
% %             elseif VM(i,j,k) < 0.2
% %                R=255/255;G=44/255;B=3/255;                                      %�ʺ�ɫ
% %                Out(i,j,k,1)=R;Out(i,j,k,2)=G;Out(i,j,k,3)=B;
% %             elseif VM(i,j,k) < 0.3
% %                R=254/255;G=126/255;B=0;                                     %�ٺ�ɫ
% %                Out(i,j,k,1)=R;Out(i,j,k,2)=G;Out(i,j,k,3)=B;
% %             elseif VM(i,j,k) < 0.4
% %                R=255/255;G=232/255;B=0;                                     %��ɫ
% %                Out(i,j,k,1)=R;Out(i,j,k,2)=G;Out(i,j,k,3)=B;
% %             elseif VM(i,j,k) < 0.5
% %                R=180/255;G=255/255;B=66/255;                                    %����ɫ
% %                Out(i,j,k,1)=R;Out(i,j,k,2)=G;Out(i,j,k,3)=B;
% %             elseif VM(i,j,k) < 0.6
% %                R=114/255;G=254/255;B=130/255;                                   %����ɫ
% %                Out(i,j,k,1)=R;Out(i,j,k,2)=G;Out(i,j,k,3)=B;
% %             elseif VM(i,j,k) < 0.7
% %                R=7/255;G=255/255;B=233/255;                                     %����ɫ
% %                Out(i,j,k,1)=R;Out(i,j,k,2)=G;Out(i,j,k,3)=B;
% %             elseif VM(i,j,k) < 0.8
% %                R=0;G=195/255;B=231/255;                                     %����ɫ
% %                Out(i,j,k,1)=R;Out(i,j,k,2)=G;Out(i,j,k,3)=B;
% %             elseif VM(i,j,k) < 0.9
% %                R=0;G=73/255;B=255/255;                                      %��ɫ
% %                Out(i,j,k,1)=R;Out(i,j,k,2)=G;Out(i,j,k,3)=B;
% %             elseif VM(i,j,k) < 1
% %                R=1/255;G=1/255;B=250/255;                                       %����ɫ
% %                Out(i,j,k,1)=R;Out(i,j,k,2)=G;Out(i,j,k,3)=B;   
% %             elseif VM(i,j,k) == 1
% %                R=120/255;G=0;B=200/255;                                     %��ɫ                                       
% %                Out(i,j,k,1)=R;Out(i,j,k,2)=G;Out(i,j,k,3)=B;   
% %             end
% %         end
% %     end
% % end
% % 
% % %%�ڴ�����%%
% % clear VM;
% % 
% % %%�ڴ�����%%
% % %%%%%%%%%��ÿ����ˮ����Ӧ��ֵ������ɫ
% % 
% % 
% % %%%%��ʾ���Ժ�ˮ��ͼ��%%%%
% % RGBpic = cell(1,DataLength);
% % rgbImage = zeros(length,width,3);
% % for i=1:1:length
% %     for j=1:1:width
% %         for k=1:1:3
% %             for l = 1:1:DataLength
% %                 
% %                 rgbImage(i,j,k) = Out(i,j,l,k);
% %                 RGBpic{1,l} = rgbImage;
% %             end
% %         end
% %     end
% % end
% % 
% % %����Щ��ɫ����Ϣ���뵽�µľ�������
% % RGBpic1 = zeros(length,width,3);
% % RGBpic2 = zeros(length,width,3);
% % RGBpic3 = zeros(length,width,3);
% % RGBpic4 = zeros(length,width,3);
% % RGBpic5 = zeros(length,width,3);
% % RGBpic6 = zeros(length,width,3);
% % RGBpic7 = zeros(length,width,3);
% % RGBpic8 = zeros(length,width,3);
% % RGBpic9 = zeros(length,width,3);
% % RGBpic10 = zeros(length,width,3);
% % RGBpic11 = zeros(length,width,3);
% % RGBpic12 = zeros(length,width,3);
% % RGBpic13 = zeros(length,width,3);
% % RGBpic14 = zeros(length,width,3);
% % RGBpic15 = zeros(length,width,3);
% % RGBpic16 = zeros(length,width,3);
% % RGBpic17 = zeros(length,width,3);
% % RGBpic18 = zeros(length,width,3);
% % RGBpic19 = zeros(length,width,3);
% % RGBpic20 = zeros(length,width,3);
% % RGBpic21 = zeros(length,width,3);
% % RGBpic22 = zeros(length,width,3);
% % RGBpic23 = zeros(length,width,3);
% % RGBpic24 = zeros(length,width,3);
% % RGBpic25 = zeros(length,width,3);
% % RGBpic26 = zeros(length,width,3);
% % RGBpic27 = zeros(length,width,3);
% % RGBpic28 = zeros(length,width,3);
% % RGBpic29 = zeros(length,width,3);
% % RGBpic30 = zeros(length,width,3);
% % 
% % 
% % for i=1:1:length
% %     for j=1:1:width
% %         for k=1:1:3
% %             RGBpic1(i,j,k) =  Out(i,j,1,k);
% %             RGBpic2(i,j,k) =  Out(i,j,2,k);
% %             RGBpic3(i,j,k) =  Out(i,j,3,k);
% %             RGBpic4(i,j,k) =  Out(i,j,4,k);
% %             RGBpic5(i,j,k) =  Out(i,j,5,k);
% %             RGBpic6(i,j,k) =  Out(i,j,6,k);
% %             RGBpic7(i,j,k) =  Out(i,j,7,k);
% %             RGBpic8(i,j,k) =  Out(i,j,8,k);
% %             RGBpic9(i,j,k) =  Out(i,j,9,k);
% %             RGBpic10(i,j,k) =  Out(i,j,10,k);
% %             RGBpic11(i,j,k) =  Out(i,j,11,k);
% %             RGBpic12(i,j,k) =  Out(i,j,12,k);
% %             RGBpic13(i,j,k) =  Out(i,j,13,k);
% %             RGBpic14(i,j,k) =  Out(i,j,14,k);
% %             RGBpic15(i,j,k) =  Out(i,j,15,k);
% %             RGBpic16(i,j,k) =  Out(i,j,16,k);
% %             RGBpic17(i,j,k) =  Out(i,j,17,k); 
% %             RGBpic18(i,j,k) =  Out(i,j,18,k);
% %             RGBpic19(i,j,k) =  Out(i,j,19,k);
% %             RGBpic20(i,j,k) =  Out(i,j,20,k);
% %             RGBpic21(i,j,k) =  Out(i,j,21,k);
% %             RGBpic22(i,j,k) =  Out(i,j,22,k);
% %             RGBpic23(i,j,k) =  Out(i,j,23,k);
% %             RGBpic24(i,j,k) =  Out(i,j,24,k);
% %             RGBpic25(i,j,k) =  Out(i,j,25,k); 
% %             RGBpic26(i,j,k) =  Out(i,j,26,k);
% %             RGBpic27(i,j,k) =  Out(i,j,27,k);
% %             RGBpic28(i,j,k) =  Out(i,j,28,k);
% %             RGBpic29(i,j,k) =  Out(i,j,29,k);
% %             RGBpic30(i,j,k) =  Out(i,j,30,k);
% %             
% %         end
% %     end
% % end
% % 
% % subplot(6,5,1);imshow(RGBpic1);xlabel('0109');
% % subplot(6,5,2);imshow(RGBpic2);xlabel('0121');
% % subplot(6,5,3);imshow(RGBpic3);xlabel('0202');
% % subplot(6,5,4);imshow(RGBpic4);xlabel('0214');
% % subplot(6,5,5);imshow(RGBpic5);xlabel('0226');
% % subplot(6,5,6);imshow(RGBpic6);xlabel('0310');
% % subplot(6,5,7);imshow(RGBpic7);xlabel('0322');
% % subplot(6,5,8);imshow(RGBpic8);xlabel('0403');
% % subplot(6,5,9);imshow(RGBpic9);xlabel('0415');
% % subplot(6,5,10);imshow(RGBpic10);xlabel('0427');
% % subplot(6,5,11);imshow(RGBpic11);xlabel('0509');
% % subplot(6,5,12);imshow(RGBpic12);xlabel('0521');
% % subplot(6,5,13);imshow(RGBpic13);xlabel('0602');
% % subplot(6,5,14);imshow(RGBpic14);xlabel('0614');
% % subplot(6,5,15);imshow(RGBpic15);xlabel('0626');
% % subplot(6,5,16);imshow(RGBpic16);xlabel('0708');
% % subplot(6,5,17);imshow(RGBpic17);xlabel('0720');
% % subplot(6,5,18);imshow(RGBpic18);xlabel('0813');
% % subplot(6,5,19);imshow(RGBpic19);xlabel('0825');
% % subplot(6,5,20);imshow(RGBpic20);xlabel('0906');
% % subplot(6,5,21);imshow(RGBpic21);xlabel('0918');
% % subplot(6,5,22);imshow(RGBpic22);xlabel('0930');
% % subplot(6,5,23);imshow(RGBpic23);xlabel('1024');
% % subplot(6,5,24);imshow(RGBpic24);xlabel('1105');
% % subplot(6,5,25);imshow(RGBpic25);xlabel('1117');
% % subplot(6,5,26);imshow(RGBpic26);xlabel('1129');
% % subplot(6,5,27);imshow(RGBpic27);xlabel('1211');
% % subplot(6,5,28);imshow(RGBpic28);xlabel('1223');
% % subplot(6,5,29);imshow(RGBpic29);xlabel('181228');
% % subplot(6,5,30);imshow(RGBpic30);xlabel('200104');
% % %%%%��ʾ���Ժ�ˮ��ͼ��%%%%