%polarcode仿真的主程序
clear all
% clc
tic;%12.497872 seconds.
N=2048;%编码比特长度
K=1024;%信息比特长度
frame=50000;%帧数为1000
L=8;
crcLength=0;
% g=logical([1 1 0 0 0 0 1 1 0 0 1 0 0 1 1 0 0 1 1 1 1 1 0 1 1]);%CRC校验用到的生成多项式
sigma=0.80;%GA构造参数
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
%信息/固定比特位置配置
llr_file_name = sprintf('EepectedLLR_block_length_%d_sigma_%.2f_method_origin_GA.txt',N,sigma);
% llr_file_name = sprintf('annotherChannels_%d_sigma_%.2f_method_origin_GA.txt',N,sigma);
expectedLLR=load(llr_file_name);
%定义数组统计当前索引下已出现过的信息位数量
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
% checkPoint=[126,254,363,438];   %1db  中段
% checkPoint=[137,244,353,448];   %1.5db
% checkPoint=[126,254,363,438];   %1.5db   中段
% checkPoint=[141,254,353,448];   %2db   尾段
% checkPoint=[129,254,363,438];   %2db   中段
checkPoint=[];   %2db   新中段
% checkPoint=[124,230,337,417];   %2db   初段
% checkPoint=[50,99,138,178,216,276,322,385];  %2.5db
% checkPoint=[129,254,363,438];   %2.5db   中段
% checkPoint=[143,279,353,448]; %3db
% checkPoint=[133,269,363,438]; %3db  中段
parityCheckLength=length(checkPoint);

%输出编码后校验点索引



%大赛所用信息/固定比特位置配置
EbN0=2;%仿真信噪比
lE=length(EbN0);
err_ber=zeros(1,lE);  %%程序开始之前没有误码，误比特个数
err_bler=zeros(1,lE);  %%误码块个数
errorrate_ber=zeros(1,lE);%误比特率
errorrate_bler=zeros(1,lE);%误码块率
allPathCount=zeros(N,lE);
for m=1:lE           %gaile
    fprintf('\n Now running:%f  [%d of %d] \n\t Iteration-Counter: %53d',EbN0(m),m,length(EbN0),0);
    sigma=sqrt(N/(2*10^(EbN0(m)/10)*(K-crcLength)));%高斯噪声标准差
    for zs=1:frame
        u=genSrc(K-crcLength-parityCheckLength);%生成随机序列 0.003087 seconds.
%         x=attachCRC24(u,g);%加入CRC校验位 0.006702 seconds.
%         x=u;
%         x=attachParityCheck(u,checkPoint);%加入奇偶校验
        x1=polarEnc(u,N,p);%编码后的比特序列,大概0.05s
        x11=bpsk(x1,N);%发送比特序列0.001226 seconds.
        y=awgn(x11,N,sigma);%加入噪声后的接收比特序列 0.000822 seconds.
        %tic
        [uyima,pathCount]=polarDec(L,y,p,sigma,infoBitCount,expectedLLR,checkPoint);%译码后序列，一次译码要10.221911 seconds
%         [uyima,pathCount]=polarDec_noCheck(L,y,p,sigma,infoBitCount,expectedLLR);
        allPathCount(:,m) = allPathCount(:,m) + pathCount;
        %toc
        errbits=length(find(uyima~=u));%译码后序列和信息序列不同bit的长度
        if errbits~=0
            errblock=1;
        else
            errblock=0;
        end
        err_ber(m)=errbits+err_ber(m);%err用于统计当前的错误bit总个数
        err_bler(m)=errblock+err_bler(m);%统计误块个数
        if mod(zs,20)==0
            for iiiii=1:53
                fprintf('\b');
            end
            fprintf(' %7d   ---- %7d FEs, %7d BEs found so far',zs,err_bler(m),err_ber(m));
        end
    end
    errorrate_ber(m)=err_ber(m)./(length(u)*frame)%计算误码率
    errorrate_bler(m)=err_bler(m)./frame%计算误块率
end
allPathCount = allPathCount/frame;
toc
figure;semilogy(EbN0,errorrate_ber,'-ko');grid on;%画图0.87s
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