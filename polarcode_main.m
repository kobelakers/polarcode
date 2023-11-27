%polarcode�����������
clear all
% clc
tic;%12.497872 seconds.
N=2048;%������س���
K=1024;%��Ϣ���س���
frame=50000;%֡��Ϊ1000
L=8;
crcLength=0;
% g=logical([1 1 0 0 0 0 1 1 0 0 1 0 0 1 1 0 0 1 1 1 1 1 0 1 1]);%CRCУ���õ������ɶ���ʽ
sigma=0.80;%GA�������
construct_origin_GA(N,sigma);
% construct_origin_GA(N,sigma);
%snr---sigma
%1-0.9129
%2-0.8136
%3-0.7251
%4-0.6463
%5-0.5760
constructed_code_file_name = sprintf('constructedCode\\PolarCode_block_length_%d_sigma_%.2f_method_origin_GA.txt',N,sigma);
indices = load(constructed_code_file_name);
pp=zeros(N,1);
pp(indices(1:K))=1;
p=logical(pp);
% p=logical([0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 1 0 1 1 1 0 0 0 1 0 1 1 1 0 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 1 0 1 1 1 0 0 0 0 0 0 0 1 0 0 0 1 0 1 1 1 0 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 1 0 0 0 1 1 1 1 1 0 0 0 0 0 0 1 1 0 1 1 1 1 1 1 1 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0 1 0 1 1 1 0 1 1 1 1 1 1 1 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 1 0 0 0 1 0 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 1 0 1 1 1 1 1 1 1 0 0 0 0 0 1 1 1 0 1 1 1 1 1 1 1 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 0 0 0 1 0 1 1 1 0 1 1 1 1 1 1 1 0 0 0 1 0 1 1 1 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 1 0 0 0 1 0 1 1 1 0 0 0 1 0 1 1 1 1 1 1 1 1 1 1 1 0 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1]);
%��Ϣ/�̶�����λ������
llr_file_name = sprintf('EepectedLLR_block_length_%d_sigma_%.2f_method_origin_GA.txt',N,sigma);
% llr_file_name = sprintf('annotherChannels_%d_sigma_%.2f_method_origin_GA.txt',N,sigma);
expectedLLR=load(llr_file_name);
%��������ͳ�Ƶ�ǰ�������ѳ��ֹ�����Ϣλ����
infoBitCount=zeros(N,1);
if p(1)
   infoBitCount(1) = 1;
end
for i = 2:N
   if p(i)
      infoBitCount(i) = infoBitCount(i-1) + 1;
   else
       infoBitCount(i) = infoBitCount(i-1);
   end
end
parityCheckLength=0;
% checkPoint=[136,244,353,448];   %1db
% checkPoint=[126,254,363,438];   %1db  �ж�
% checkPoint=[137,244,353,448];   %1.5db
% checkPoint=[126,254,363,438];   %1.5db   �ж�
% checkPoint=[141,254,353,448];   %2db   β��
% checkPoint=[129,254,363,438];   %2db   �ж�
checkPoint=[];   %2db   ���ж�
% checkPoint=[124,230,337,417];   %2db   ����
% checkPoint=[50,99,138,178,216,276,322,385];  %2.5db
% checkPoint=[129,254,363,438];   %2.5db   �ж�
% checkPoint=[143,279,353,448]; %3db
% checkPoint=[133,269,363,438]; %3db  �ж�
parityCheckLength=length(checkPoint);

%��������У�������



%����������Ϣ/�̶�����λ������
EbN0=2;%���������
lE=length(EbN0);
err_ber=zeros(1,lE);  %%����ʼ֮ǰû�����룬����ظ���
err_bler=zeros(1,lE);  %%��������
errorrate_ber=zeros(1,lE);%�������
errorrate_bler=zeros(1,lE);%�������
allPathCount=zeros(N,lE);
for m=1:lE           %gaile
    fprintf('\n Now running:%f  [%d of %d] \n\t Iteration-Counter: %53d',EbN0(m),m,length(EbN0),0);
    sigma=sqrt(N/(2*10^(EbN0(m)/10)*(K-crcLength)));%��˹������׼��
    for zs=1:frame
        u=genSrc(K-crcLength-parityCheckLength);%����������� 0.003087 seconds.
%         x=attachCRC24(u,g);%����CRCУ��λ 0.006702 seconds.
%         x=u;
%         x=attachParityCheck(u,checkPoint);%������żУ��
        x1=polarEnc(u,N,p);%�����ı�������,���0.05s
        x11=bpsk(x1,N);%���ͱ�������0.001226 seconds.
        y=awgn(x11,N,sigma);%����������Ľ��ձ������� 0.000822 seconds.
        %tic
        [uyima,pathCount]=polarDec(L,y,p,sigma,infoBitCount,expectedLLR,checkPoint);%��������У�һ������Ҫ10.221911 seconds
%         [uyima,pathCount]=polarDec_noCheck(L,y,p,sigma,infoBitCount,expectedLLR);
        allPathCount(:,m) = allPathCount(:,m) + pathCount;
        %toc
        errbits=length(find(uyima~=u));%��������к���Ϣ���в�ͬbit�ĳ���
        if errbits~=0
            errblock=1;
        else
            errblock=0;
        end
        err_ber(m)=errbits+err_ber(m);%err����ͳ�Ƶ�ǰ�Ĵ���bit�ܸ���
        err_bler(m)=errblock+err_bler(m);%ͳ��������
        if mod(zs,20)==0
            for iiiii=1:53
                fprintf('\b');
            end
            fprintf(' %7d   ---- %7d FEs, %7d BEs found so far',zs,err_bler(m),err_ber(m));
        end
    end
    errorrate_ber(m)=err_ber(m)./(length(u)*frame)%����������
    errorrate_bler(m)=err_bler(m)./frame%���������
end
allPathCount = allPathCount/frame;
toc
figure;semilogy(EbN0,errorrate_ber,'-ko');grid on;%��ͼ0.87s
legend('L=2');
title('BER performance');
xlabel('Eb/No');
ylabel('BER');
figure;semilogy(EbN0,errorrate_bler,'-bs');grid on;
legend('L=2');
title('BLER performance');
xlabel('Eb/No');
ylabel('BLER');
%toc;