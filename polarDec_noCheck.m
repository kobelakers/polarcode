function [x,pathCount] = polarDec_noCheck(L,y,p,sigma,infoBitCount,expectedLLR)
%功能是完成接收序列译码
%输入L是路径搜索宽度，y是接收序列长度为N，p是位置矩阵，指示信息比特和固定比特的位置,sigma为信道高斯噪声的标准差
%输出x是译码得到的信息比特序列
N=length(y);
Flag=log2(L); %   %%%%%%%%%%%%%      %Flag用于指示L条路径的选取方法的切换flag<=Flag全选，大于则取较大的L个
u_matrix=zeros(L,N+2);  %该矩阵是一个（L*(N+1)）的二维矩阵，u_matrix的每一行的前N列存放一串保留路径对应的码字，u_matrix(:,N+1)则对应着候选路径的度量值,N+2位存放候选路径中可靠点的数量
reserve_all=path_matrix(L);
flag=0;                          %表示当前还没有遇到第一个信息位
PM_temp=zeros(2*L,3);             %存放2L个码字串的判断位置，用于选出L个码字串的临时矩阵,第1列存0/1，第二列存PM，第三列存是否可靠
PM_temp(1:2:2*L,1)=ones(L,1);   %把第一列奇数行的值设为1
LLR_matrix=2.*y./sigma^2;
uk=zeros(L,512);
pathCount = zeros(L,1);
% expectedLLR=50;
threshold=0;
%branch_time=[0 0 0 0];             %分支计时
allcut=0;
ci=1; %表示第几个校验点
lastCheckPoint=0;
for i=1:N
    i;
    if p(i)==0
        if i==1         %耗时0.0044
            uu=[];
            u=0;
            %LLR_matrix=matrix_1;
            LLR=likelihood_rate_c(N,i,uu,LLR_matrix);%%%%%%%%%%%
            PM_former=0;
            for j=1:L
                u_matrix(j,N+1)=path_metric(i,u,PM_former,LLR,p);
                u_matrix(j,N+2)=0;
            end
            pathCount(i)=1;
        else                 %耗时0.012*512
            u=0;
            for j=1:L
                j;
                uu=u_matrix(j,1:i-1);
                %LLR_matrix=matrix_1;
                LLR=likelihood_rate_c(N,i,uu,LLR_matrix);%Elapsed time is 0.0004 seconds.L=32
                PM_former=u_matrix(j,N+1);
                u_matrix(j,N+1)=path_metric( i,u,PM_former,LLR,p );%Elapsed time is 0.000005 seconds.
            end
            pathCount(i)=pathCount(i-1);
        end
    else
        flag=flag+1;
        if flag<=Flag %此时要保留所有路径 并算概率  %耗时 0.0462s
            u_matrix(:,i)=reserve_all(:,flag);
            for j=1:L
                j;
                uu=u_matrix(j,1:i-1);
                u=u_matrix(j,i);
                %LLR_matrix=matrix_1;
                PM_former=u_matrix(j,N+1);
                if PM_former>-inf
                    LLR=likelihood_rate_c(N,i,uu,LLR_matrix);
                    if isReliable(LLR,expectedLLR(i))==1
                        if (1-2*u) ~= sign(LLR)
                            u_matrix(j,N+1)=-inf;
                        end
                    else
                        u_matrix(j,N+1)=path_metric( i,u,PM_former,LLR,p );
                    end
                else
                    u_matrix(j,N+1)=-inf;
                end
                if isReliable(LLR,expectedLLR(i))==1
                    u_matrix(j,N+2)=u_matrix(j,N+2)+1;
                end
            end
            activePath = 0;
            for ii = 1 : L
                if u_matrix(ii,N+1) > -inf
                    activePath = activePath + 1;
                end
            end
            pathCount(i)=activePath/(2^(Flag-flag));
            %             pathCount(i)=pathCount(i-1)*2;
        else                                    %耗时4.7241s
            for j=1:L
                j;
                uu=u_matrix(j,1:i-1);
                %LLR_matrix=matrix_1;
                PM_former=u_matrix(j,N+1);
                if PM_former>-inf
                    LLR=likelihood_rate_c(N,i,uu,LLR_matrix);%%%%%%%%%%%%%%%%%%%
                    if isReliable(LLR,expectedLLR(i))==1
                        if sign(LLR)==-1  %直接判定为1
                            PM_temp(2*j-1,2)=path_metric(i,1,PM_former,LLR,p);   %PM_temp矩阵奇数行存判定比特为1的路径测量值
                            PM_temp(2*j,2)=-inf;%0剪掉
                        else
                            PM_temp(2*j-1,2)=-inf;%1剪掉
                            PM_temp(2*j,2)=path_metric(i,0,PM_former,LLR,p);%PM_temp矩阵偶数行存判定比特为0的路径测量值
                        end
                    else
                        PM_temp(2*j-1,2)=path_metric(i,1,PM_former,LLR,p);   %PM_temp矩阵奇数行存判定比特为1的路径测量值
                        PM_temp(2*j,2)=path_metric(i,0,PM_former,LLR,p);%PM_temp矩阵偶数行存判定比特为0的路径测量值
                    end
                else
                    PM_temp(2*j-1,2)=-inf;   %PM_temp矩阵奇数行存判定比特为1的路径测量值
                    PM_temp(2*j,2)=-inf;%PM_temp矩阵偶数行存判定比特为0的路径测量值
                end
                
                PM_temp(2*j-1,3)=0;
                PM_temp(2*j,3)=0;
                if isReliable(LLR,expectedLLR(i))==1
                    if sign(LLR)==1
                        PM_temp(2*j,3)=1;%判定为0可靠
                    else
                        PM_temp(2*j-1,3)=1;%判定为1可靠
                    end
                end
            end
            [a,b]=sort(PM_temp(:,2),'descend');
            
            temp=zeros(L,i+2);%zeros(0,i+1)
            for k=1:L                                            %这个循坏用于从2L个概率值中选取较大的L个
                if  mod(b(k),2)==1                               %奇数表示最后一位是1，tempcode的i+1位是该路径的pm
                    reliableCount = u_matrix((b(k)+1)/2,N+2) + PM_temp(b(k),3);
                    temp(k,:)=[u_matrix((b(k)+1)/2,1:i-1),1,a(k),reliableCount]; %找出排序后对应u_matrix里的的第几行码子
                else                                              %偶数表示最后一位是0 ，tempcode的i+1位是该路径的pm
                    reliableCount = u_matrix(b(k)/2,N+2) + PM_temp(b(k),3);
                    temp(k,:)=[u_matrix(b(k)/2,1:i-1),0,a(k),reliableCount];
                end
            end
            u_matrix(:,1:i)=temp(:,1:i);
            u_matrix(:,N+1)=temp(:,i+1);
            u_matrix(:,N+2)=temp(:,i+2);
            %阈值统计剪枝
            temp_best=u_matrix(1,N+1);
            %             for ii = 1:L
            % %                curRate = u_matrix(ii,N+2)/infoBitCount(i);
            % %                if curRate < threshold && infoBitCount(i)>150
            % %                    u_matrix(ii,N+1) = -inf;
            % %                end
            %                if u_matrix(ii,N+1)<max(u_matrix(:,N+1))-10
            %                    u_matrix(ii,N+1) = -inf;
            %                end
            %             end
            
            %此处统计当前索引下存活路径的数量
            activePath = 0;
            for ii = 1 : L
                if u_matrix(ii,N+1) > -inf
                    activePath = activePath + 1;
                end
            end
            %全部被剪枝的话，保留最大
            if activePath==0
                u_matrix(1,N+1)=temp_best;
                activePath=1;
                allcut=allcut+1;
            end
            pathCount(i)=activePath;
        end
    end
end
[~,index]=sort(u_matrix(:,N+1),'descend');
% tmp=zeros(1,L);
% for ii=1:L
%     tmp(ii)=u_matrix(ii,N+2);
% end
% tmp
u_matrix(1,1:N)=u_matrix(index(1),1:N);
j=1;
for i=1:N                  %把信息位K位从译码序列中提取出来
    if p(i)==1
        uk(:,j)=u_matrix(:,i);
        j=j+1;
    end
end
K=length(uk);
x = uk(1,1:K);
% if L>1
%     for ii=L:-1:1
%         err=crcCheck24a(uk(ii,:)) ;
%         if err==0
%             x=uk(ii,1:K-24);
%         else
%             x=uk(1,1:K-24);
%         end
%     end
% else
%     x = uk(1,1:K-24);
% end
