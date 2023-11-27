function [x,pathCount] = polarDecCRC8(L,y,p,sigma,infoBitCount,expectedLLR,checkPoint)
%功能是完成接收序列译码
%输入L是路径搜索宽度，y是接收序列长度为N，p是位置矩阵，指示信息比特和固定比特的位置,sigma为信道高斯噪声的标准差
%输出x是译码得到的信息比特序列
N=2048;
Flag=log2(L); %   %%%%%%%%%%%%%      %Flag用于指示L条路径的选取方法的切换flag<=Flag全选，大于则取较大的L个
u_matrix=zeros(L,N+2);  %  1-N：译码路径  N+1：路径的度量值  N+2：可靠点的数量  
reserve_all=path_matrix(L); %matrix:矩阵
flag=0;                          %表示当前还没有遇到第一个信息位
PM_temp=zeros(2*L,3);             %存放2L个码字串的判断位置，用于选出L个码字串的临时矩阵,第1列存0/1，第二列存PM，第三列存是否可靠
PM_temp(1:2:2*L,1)=ones(L,1);   %把第一列奇数行的值设为1
LLR_matrix=2.*y./sigma^2;  
uk=zeros(L,1024);
pathCount = zeros(L,1);
% expectedLLR=50;
threshold=0;
%branch_time=[0 0 0 0];             %分支计时
allcut=0;
ci=1; %表示第几个校验点
lastCheckPoint=0;
c1=0;%用来统计信息位的个数


% for i=1:N
%     if p(i)==1
%         c1=c1+1;
%           if c1==172
%               c2=i;
%           elseif c1==343
%               c3=i;
%           end
%     end
% end
for i=1:1260   %从上到下估计每一个比特
    i;
    if p(i)==0  %当前为固定比特
        if i==1         %耗时0.0044
            uu=[];%前i-1个估计
            u=0;%当前比特估计值
            %LLR_matrix=matrix_1;
            LLR=likelihood_rate_c(N,i,uu,LLR_matrix);%%%%%%%%%%% 计算最大似然值LLR
            PM_former=0;%第i位之前路径度量值
            for j=1:L
                u_matrix(j,N+1)=path_metric(i,u,PM_former,LLR,p);%计算路径度量值
                u_matrix(j,N+2)=0;%可靠点数
            end
            pathCount(i)=1;%路径数记为1
        else           % i不是第一个    前面有估计完的比特          耗时0.012*512
            u=0;
            for j=1:L  %横向循环计算每条路径度量值
                j;
                uu=u_matrix(j,1:i-1); %前i-1个比特估计序列
                %LLR_matrix=matrix_1;
                LLR=likelihood_rate_c(N,i,uu,LLR_matrix);%递归计算对数似然比     Elapsed time is 0.0004 seconds.L=32 
                PM_former=u_matrix(j,N+1);%第j条路径的前i-1个比特的路径度量值
                u_matrix(j,N+1)=path_metric( i,u,PM_former,LLR,p );%第j条路径的当前路径度量值         Elapsed time is 0.000005 seconds.
            end
            pathCount(i)=pathCount(i-1);% 每层路径数不变
        end
    else  %p(i)==1  当前为信息比特
        flag=flag+1;
        if flag<=Flag %此时要保留所有路径 并算概率  %耗时 0.0462s
            u_matrix(:,i)=reserve_all(:,flag); %把reserve_all的第flag列的L行数据赋给u_matrix的第i列的L行
            for j=1:L
                j;
                uu=u_matrix(j,1:i-1);%前i-1个估计
                u=u_matrix(j,i);
                %LLR_matrix=matrix_1;
                PM_former=u_matrix(j,N+1);
                if PM_former>-inf
                    LLR=likelihood_rate_c(N,i,uu,LLR_matrix);
                    if isReliable(LLR,expectedLLR(i))==1 %足够可靠
                        if (1-2*u) ~= sign(LLR)%足够可靠的条件下错了，那么路径度量值为负无穷
                            u_matrix(j,N+1)=-inf; 
                        end
                    else %不可靠
                        u_matrix(j,N+1)=path_metric( i,u,PM_former,LLR,p ); %计算路径度量值
                    end
                else   %PM_former = -inf
                    u_matrix(j,N+1)=-inf;
                end            
                
                
                if isReliable(LLR,expectedLLR(i))==1
                    u_matrix(j,N+2)=u_matrix(j,N+2)+1;
                end
            end    %flag小于Flag条件下，j循环结束
            
            activePath = 0;
            for ii = 1 : L
                if u_matrix(ii,N+1) > -inf
                    activePath = activePath + 1;
                end
            end
            pathCount(i)=activePath/(2^(Flag-flag));
            %             pathCount(i)=pathCount(i-1)*2;
        else   %flag>Flag                                   %耗时4.7241s
            for j=1:L
                j;
                uu=u_matrix(j,1:i-1);
                %LLR_matrix=matrix_1;
                PM_former=u_matrix(j,N+1);
                if PM_former>-inf
                    LLR=likelihood_rate_c(N,i,uu,LLR_matrix);%%%%%%%%%%%%%%%%%%%
                    if isReliable(LLR,expectedLLR(i))==1 %足够可靠
                        if sign(LLR)==-1  %直接判定为1
                            PM_temp(2*j-1,2)=path_metric(i,1,PM_former,LLR,p);   %PM_temp矩阵奇数行存判定比特为1的路径测量值
                            PM_temp(2*j,2)=-inf;%0剪掉
                        else  %直接判定为0
                            PM_temp(2*j-1,2)=-inf;%1剪掉
                            PM_temp(2*j,2)=path_metric(i,0,PM_former,LLR,p);%PM_temp矩阵偶数行存判定比特为0的路径测量值
                        end
                    else %不可靠
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
            end %flag大于Flag条件下的j循环结束
            
            
            [a,b]=sort(PM_temp(:,2),'descend'); %把L条路径的路径度量值按降序排序
            
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
            %若是校验点，进行校验剪枝
          
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
    end%固定比特
end
[~,index]=sort(u_matrix(:,N+1),'descend');
% tmp=zeros(1,L);
% for ii=1:L
%     tmp(ii)=u_matrix(ii,N+2);
% end
% tmp
u_matrix(1,1:N)=u_matrix(index(1),1:N);
j=1;
for i=1:1260                  %把信息位K位从译码序列中提取出来
    if p(i)==1
        uk(:,j)=u_matrix(:,i);
        j=j+1;
    end
end
% K=length(uk);
xx = uk(1,1:341);
ii=1;
ci=1;
x1=zeros(1,341-length(checkPoint));
%for i=1:K
%    if ci<=length(checkPoint) && i==checkPoint(ci)
%        ci=ci+1;
%    else
%        x(ii)=xx(i);
%        ii=ii+1;
%    end
%end
c3=0;%记录ii
if L>1
     for ii=1:1:L
         err=crcCheck8a(uk(ii,:)) ;
         if err==0
             x1=uk(ii,1:333);
             c3=ii;
             break;
         else
             x1=uk(1,1:333);
         end
     end
 else
    x1 = uk(1,1:333);
%    x = uk(1,1:K);
end


for j=1:L
    if j~=c3
        u_matrix(j,N+1)=-inf;
    end
end
        

%第二次循环
for i=1261:1703   %从上到下估计每一个比特
    i;
    if p(i)==0  %当前为固定比特
        if i==1         %耗时0.0044
            uu=[];%前i-1个估计
            u=0;%当前比特估计值
            %LLR_matrix=matrix_1;
            LLR=likelihood_rate_c(N,i,uu,LLR_matrix);%%%%%%%%%%% 计算最大似然值LLR
            PM_former=0;%第i位之前路径度量值
            for j=1:L
                u_matrix(j,N+1)=path_metric(i,u,PM_former,LLR,p);%计算路径度量值
                u_matrix(j,N+2)=0;%可靠点数
            end
            pathCount(i)=1;%路径数记为1
        else           % i不是第一个    前面有估计完的比特          耗时0.012*512
            u=0;
            for j=1:L  %横向循环计算每条路径度量值
                j;
                uu=u_matrix(j,1:i-1); %前i-1个比特估计序列
                %LLR_matrix=matrix_1;
                LLR=likelihood_rate_c(N,i,uu,LLR_matrix);%递归计算对数似然比     Elapsed time is 0.0004 seconds.L=32 
                PM_former=u_matrix(j,N+1);%第j条路径的前i-1个比特的路径度量值
                u_matrix(j,N+1)=path_metric( i,u,PM_former,LLR,p );%第j条路径的当前路径度量值         Elapsed time is 0.000005 seconds.
            end
            pathCount(i)=pathCount(i-1);% 每层路径数不变
        end
    else  %p(i)==1  当前为信息比特
        flag=flag+1;
        if flag<=Flag %此时要保留所有路径 并算概率  %耗时 0.0462s
            u_matrix(:,i)=reserve_all(:,flag); %把reserve_all的第flag列的L行数据赋给u_matrix的第i列的L行
            for j=1:L
                j;
                uu=u_matrix(j,1:i-1);%前i-1个估计
                u=u_matrix(j,i);
                %LLR_matrix=matrix_1;
                PM_former=u_matrix(j,N+1);
                if PM_former>-inf
                    LLR=likelihood_rate_c(N,i,uu,LLR_matrix);
                    if isReliable(LLR,expectedLLR(i))==1 %足够可靠
                        if (1-2*u) ~= sign(LLR)%足够可靠的条件下错了，那么路径度量值为负无穷
                            u_matrix(j,N+1)=-inf; 
                        end
                    else %不可靠
                        u_matrix(j,N+1)=path_metric( i,u,PM_former,LLR,p ); %计算路径度量值
                    end
                else   %PM_former = -inf
                    u_matrix(j,N+1)=-inf;
                end            
                
                
                if isReliable(LLR,expectedLLR(i))==1
                    u_matrix(j,N+2)=u_matrix(j,N+2)+1;
                end
            end    %flag小于Flag条件下，j循环结束
            
            activePath = 0;
            for ii = 1 : L
                if u_matrix(ii,N+1) > -inf
                    activePath = activePath + 1;
                end
            end
            pathCount(i)=activePath/(2^(Flag-flag));
            %             pathCount(i)=pathCount(i-1)*2;
        else   %flag>Flag                                   %耗时4.7241s
            for j=1:L
                j;
                uu=u_matrix(j,1:i-1);
                %LLR_matrix=matrix_1;
                PM_former=u_matrix(j,N+1);
                if PM_former>-inf
                    LLR=likelihood_rate_c(N,i,uu,LLR_matrix);%%%%%%%%%%%%%%%%%%%
                    if isReliable(LLR,expectedLLR(i))==1 %足够可靠
                        if sign(LLR)==-1  %直接判定为1
                            PM_temp(2*j-1,2)=path_metric(i,1,PM_former,LLR,p);   %PM_temp矩阵奇数行存判定比特为1的路径测量值
                            PM_temp(2*j,2)=-inf;%0剪掉
                        else  %直接判定为0
                            PM_temp(2*j-1,2)=-inf;%1剪掉
                            PM_temp(2*j,2)=path_metric(i,0,PM_former,LLR,p);%PM_temp矩阵偶数行存判定比特为0的路径测量值
                        end
                    else %不可靠
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
            end %flag大于Flag条件下的j循环结束
            
            
            [a,b]=sort(PM_temp(:,2),'descend'); %把L条路径的路径度量值按降序排序
            
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
            %若是校验点，进行校验剪枝
          
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
    end%固定比特
end
[~,index]=sort(u_matrix(:,N+1),'descend');
% tmp=zeros(1,L);
% for ii=1:L
%     tmp(ii)=u_matrix(ii,N+2);
% end
% tmp
u_matrix(1,1:N)=u_matrix(index(1),1:N);
j=1;
for i=1261:1703                  %把信息位K位从译码序列中提取出来
    if p(i)==1
        uk(:,j)=u_matrix(:,i);
        j=j+1;
    end
end
% K=length(uk);
xx = uk(1,1:341);
ii=1;
ci=1;
x2=zeros(1,341-length(checkPoint));
%for i=1:K
%    if ci<=length(checkPoint) && i==checkPoint(ci)
%        ci=ci+1;
%    else
%        x(ii)=xx(i);
%        ii=ii+1;
%    end
%end
c4=0;%记录ii
if L>1
     for ii=1:1:L
         err=crcCheck8a(uk(ii,:)) ;
         if err==0
             x2=uk(ii,1:333);
             c4=ii;
             break;
         else
             x2=uk(1,1:333);
         end
     end
 else
    x2 = uk(1,1:333);
%    x = uk(1,1:K);
end


for j=1:L
    if j~=c4
        u_matrix(j,N+1)=-inf;
    end
end



%第三次循环
for i=1704:2048   %从上到下估计每一个比特
    i;
    if p(i)==0  %当前为固定比特
        if i==1         %耗时0.0044
            uu=[];%前i-1个估计
            u=0;%当前比特估计值
            %LLR_matrix=matrix_1;
            LLR=likelihood_rate_c(N,i,uu,LLR_matrix);%%%%%%%%%%% 计算最大似然值LLR
            PM_former=0;%第i位之前路径度量值
            for j=1:L
                u_matrix(j,N+1)=path_metric(i,u,PM_former,LLR,p);%计算路径度量值
                u_matrix(j,N+2)=0;%可靠点数
            end
            pathCount(i)=1;%路径数记为1
        else           % i不是第一个    前面有估计完的比特          耗时0.012*512
            u=0;
            for j=1:L  %横向循环计算每条路径度量值
                j;
                uu=u_matrix(j,1:i-1); %前i-1个比特估计序列
                %LLR_matrix=matrix_1;
                LLR=likelihood_rate_c(N,i,uu,LLR_matrix);%递归计算对数似然比     Elapsed time is 0.0004 seconds.L=32 
                PM_former=u_matrix(j,N+1);%第j条路径的前i-1个比特的路径度量值
                u_matrix(j,N+1)=path_metric( i,u,PM_former,LLR,p );%第j条路径的当前路径度量值         Elapsed time is 0.000005 seconds.
            end
            pathCount(i)=pathCount(i-1);% 每层路径数不变
        end
    else  %p(i)==1  当前为信息比特
        flag=flag+1;
        if flag<=Flag %此时要保留所有路径 并算概率  %耗时 0.0462s
            u_matrix(:,i)=reserve_all(:,flag); %把reserve_all的第flag列的L行数据赋给u_matrix的第i列的L行
            for j=1:L
                j;
                uu=u_matrix(j,1:i-1);%前i-1个估计
                u=u_matrix(j,i);
                %LLR_matrix=matrix_1;
                PM_former=u_matrix(j,N+1);
                if PM_former>-inf
                    LLR=likelihood_rate_c(N,i,uu,LLR_matrix);
                    if isReliable(LLR,expectedLLR(i))==1 %足够可靠
                        if (1-2*u) ~= sign(LLR)%足够可靠的条件下错了，那么路径度量值为负无穷
                            u_matrix(j,N+1)=-inf; 
                        end
                    else %不可靠
                        u_matrix(j,N+1)=path_metric( i,u,PM_former,LLR,p ); %计算路径度量值
                    end
                else   %PM_former = -inf
                    u_matrix(j,N+1)=-inf;
                end            
                
                
                if isReliable(LLR,expectedLLR(i))==1
                    u_matrix(j,N+2)=u_matrix(j,N+2)+1;
                end
            end    %flag小于Flag条件下，j循环结束
            
            activePath = 0;
            for ii = 1 : L
                if u_matrix(ii,N+1) > -inf
                    activePath = activePath + 1;
                end
            end
            pathCount(i)=activePath/(2^(Flag-flag));
            %             pathCount(i)=pathCount(i-1)*2;
        else   %flag>Flag                                   %耗时4.7241s
            for j=1:L
                j;
                uu=u_matrix(j,1:i-1);
                %LLR_matrix=matrix_1;
                PM_former=u_matrix(j,N+1);
                if PM_former>-inf
                    LLR=likelihood_rate_c(N,i,uu,LLR_matrix);%%%%%%%%%%%%%%%%%%%
                    if isReliable(LLR,expectedLLR(i))==1 %足够可靠
                        if sign(LLR)==-1  %直接判定为1
                            PM_temp(2*j-1,2)=path_metric(i,1,PM_former,LLR,p);   %PM_temp矩阵奇数行存判定比特为1的路径测量值
                            PM_temp(2*j,2)=-inf;%0剪掉
                        else  %直接判定为0
                            PM_temp(2*j-1,2)=-inf;%1剪掉
                            PM_temp(2*j,2)=path_metric(i,0,PM_former,LLR,p);%PM_temp矩阵偶数行存判定比特为0的路径测量值
                        end
                    else %不可靠
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
            end %flag大于Flag条件下的j循环结束
            
            
            [a,b]=sort(PM_temp(:,2),'descend'); %把L条路径的路径度量值按降序排序
            
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
            %若是校验点，进行校验剪枝
          
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
    end%固定比特
end
[~,index]=sort(u_matrix(:,N+1),'descend');
% tmp=zeros(1,L);
% for ii=1:L
%     tmp(ii)=u_matrix(ii,N+2);
% end
% tmp
u_matrix(1,1:N)=u_matrix(index(1),1:N);
j=1;
for i=1704:2048                  %把信息位K位从译码序列中提取出来
    if p(i)==1
        uk(:,j)=u_matrix(:,i);
        j=j+1;
    end
end
% K=length(uk);
xx = uk(1,1:342);
ii=1;
ci=1;
x3=zeros(1,342-length(checkPoint));
%for i=1:K
%    if ci<=length(checkPoint) && i==checkPoint(ci)
%        ci=ci+1;
%    else
%        x(ii)=xx(i);
%        ii=ii+1;
%    end
%end
c5=0;%记录ii
if L>1
     for ii=1:1:L
         err=crcCheck8a(uk(ii,:)) ;
         if err==0
             x3=uk(ii,1:334);
             c5=ii;
             break;
         else
             x3=uk(1,1:334);
         end
     end
 else
    x3 = uk(1,1:334);
%    x = uk(1,1:K);
end


for j=1:L
    if j~=c5
        u_matrix(j,N+1)=-inf;
    end
end




x=[x1,x2,x3];
 


