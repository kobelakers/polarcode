function [x,pathCount] = polarDecCRC8(L,y,p,sigma,infoBitCount,expectedLLR,checkPoint)
%��������ɽ�����������
%����L��·��������ȣ�y�ǽ������г���ΪN��p��λ�þ���ָʾ��Ϣ���غ͹̶����ص�λ��,sigmaΪ�ŵ���˹�����ı�׼��
%���x������õ�����Ϣ��������
N=2048;
Flag=log2(L); %   %%%%%%%%%%%%%      %Flag����ָʾL��·����ѡȡ�������л�flag<=Flagȫѡ��������ȡ�ϴ��L��
u_matrix=zeros(L,N+2);  %  1-N������·��  N+1��·���Ķ���ֵ  N+2���ɿ��������  
reserve_all=path_matrix(L); %matrix:����
flag=0;                          %��ʾ��ǰ��û��������һ����Ϣλ
PM_temp=zeros(2*L,3);             %���2L�����ִ����ж�λ�ã�����ѡ��L�����ִ�����ʱ����,��1�д�0/1���ڶ��д�PM�������д��Ƿ�ɿ�
PM_temp(1:2:2*L,1)=ones(L,1);   %�ѵ�һ�������е�ֵ��Ϊ1
LLR_matrix=2.*y./sigma^2;  
uk=zeros(L,1024);
pathCount = zeros(L,1);
% expectedLLR=50;
threshold=0;
%branch_time=[0 0 0 0];             %��֧��ʱ
allcut=0;
ci=1; %��ʾ�ڼ���У���
lastCheckPoint=0;
c1=0;%����ͳ����Ϣλ�ĸ���


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
for i=1:1260   %���ϵ��¹���ÿһ������
    i;
    if p(i)==0  %��ǰΪ�̶�����
        if i==1         %��ʱ0.0044
            uu=[];%ǰi-1������
            u=0;%��ǰ���ع���ֵ
            %LLR_matrix=matrix_1;
            LLR=likelihood_rate_c(N,i,uu,LLR_matrix);%%%%%%%%%%% ���������ȻֵLLR
            PM_former=0;%��iλ֮ǰ·������ֵ
            for j=1:L
                u_matrix(j,N+1)=path_metric(i,u,PM_former,LLR,p);%����·������ֵ
                u_matrix(j,N+2)=0;%�ɿ�����
            end
            pathCount(i)=1;%·������Ϊ1
        else           % i���ǵ�һ��    ǰ���й�����ı���          ��ʱ0.012*512
            u=0;
            for j=1:L  %����ѭ������ÿ��·������ֵ
                j;
                uu=u_matrix(j,1:i-1); %ǰi-1�����ع�������
                %LLR_matrix=matrix_1;
                LLR=likelihood_rate_c(N,i,uu,LLR_matrix);%�ݹ���������Ȼ��     Elapsed time is 0.0004 seconds.L=32 
                PM_former=u_matrix(j,N+1);%��j��·����ǰi-1�����ص�·������ֵ
                u_matrix(j,N+1)=path_metric( i,u,PM_former,LLR,p );%��j��·���ĵ�ǰ·������ֵ         Elapsed time is 0.000005 seconds.
            end
            pathCount(i)=pathCount(i-1);% ÿ��·��������
        end
    else  %p(i)==1  ��ǰΪ��Ϣ����
        flag=flag+1;
        if flag<=Flag %��ʱҪ��������·�� �������  %��ʱ 0.0462s
            u_matrix(:,i)=reserve_all(:,flag); %��reserve_all�ĵ�flag�е�L�����ݸ���u_matrix�ĵ�i�е�L��
            for j=1:L
                j;
                uu=u_matrix(j,1:i-1);%ǰi-1������
                u=u_matrix(j,i);
                %LLR_matrix=matrix_1;
                PM_former=u_matrix(j,N+1);
                if PM_former>-inf
                    LLR=likelihood_rate_c(N,i,uu,LLR_matrix);
                    if isReliable(LLR,expectedLLR(i))==1 %�㹻�ɿ�
                        if (1-2*u) ~= sign(LLR)%�㹻�ɿ��������´��ˣ���ô·������ֵΪ������
                            u_matrix(j,N+1)=-inf; 
                        end
                    else %���ɿ�
                        u_matrix(j,N+1)=path_metric( i,u,PM_former,LLR,p ); %����·������ֵ
                    end
                else   %PM_former = -inf
                    u_matrix(j,N+1)=-inf;
                end            
                
                
                if isReliable(LLR,expectedLLR(i))==1
                    u_matrix(j,N+2)=u_matrix(j,N+2)+1;
                end
            end    %flagС��Flag�����£�jѭ������
            
            activePath = 0;
            for ii = 1 : L
                if u_matrix(ii,N+1) > -inf
                    activePath = activePath + 1;
                end
            end
            pathCount(i)=activePath/(2^(Flag-flag));
            %             pathCount(i)=pathCount(i-1)*2;
        else   %flag>Flag                                   %��ʱ4.7241s
            for j=1:L
                j;
                uu=u_matrix(j,1:i-1);
                %LLR_matrix=matrix_1;
                PM_former=u_matrix(j,N+1);
                if PM_former>-inf
                    LLR=likelihood_rate_c(N,i,uu,LLR_matrix);%%%%%%%%%%%%%%%%%%%
                    if isReliable(LLR,expectedLLR(i))==1 %�㹻�ɿ�
                        if sign(LLR)==-1  %ֱ���ж�Ϊ1
                            PM_temp(2*j-1,2)=path_metric(i,1,PM_former,LLR,p);   %PM_temp���������д��ж�����Ϊ1��·������ֵ
                            PM_temp(2*j,2)=-inf;%0����
                        else  %ֱ���ж�Ϊ0
                            PM_temp(2*j-1,2)=-inf;%1����
                            PM_temp(2*j,2)=path_metric(i,0,PM_former,LLR,p);%PM_temp����ż���д��ж�����Ϊ0��·������ֵ
                        end
                    else %���ɿ�
                        PM_temp(2*j-1,2)=path_metric(i,1,PM_former,LLR,p);   %PM_temp���������д��ж�����Ϊ1��·������ֵ
                        PM_temp(2*j,2)=path_metric(i,0,PM_former,LLR,p);%PM_temp����ż���д��ж�����Ϊ0��·������ֵ
                    end
                else
                    PM_temp(2*j-1,2)=-inf;   %PM_temp���������д��ж�����Ϊ1��·������ֵ
                    PM_temp(2*j,2)=-inf;%PM_temp����ż���д��ж�����Ϊ0��·������ֵ
                end
                
                PM_temp(2*j-1,3)=0;
                PM_temp(2*j,3)=0;
                if isReliable(LLR,expectedLLR(i))==1
                    if sign(LLR)==1
                        PM_temp(2*j,3)=1;%�ж�Ϊ0�ɿ�
                    else
                        PM_temp(2*j-1,3)=1;%�ж�Ϊ1�ɿ�
                    end
                end
            end %flag����Flag�����µ�jѭ������
            
            
            [a,b]=sort(PM_temp(:,2),'descend'); %��L��·����·������ֵ����������
            
            temp=zeros(L,i+2);%zeros(0,i+1)
            for k=1:L                                            %���ѭ�����ڴ�2L������ֵ��ѡȡ�ϴ��L��
                if  mod(b(k),2)==1                               %������ʾ���һλ��1��tempcode��i+1λ�Ǹ�·����pm
                    reliableCount = u_matrix((b(k)+1)/2,N+2) + PM_temp(b(k),3);
                    temp(k,:)=[u_matrix((b(k)+1)/2,1:i-1),1,a(k),reliableCount]; %�ҳ�������Ӧu_matrix��ĵĵڼ�������
                else                                              %ż����ʾ���һλ��0 ��tempcode��i+1λ�Ǹ�·����pm
                    reliableCount = u_matrix(b(k)/2,N+2) + PM_temp(b(k),3);
                    temp(k,:)=[u_matrix(b(k)/2,1:i-1),0,a(k),reliableCount];
                end
            end
            u_matrix(:,1:i)=temp(:,1:i);
            u_matrix(:,N+1)=temp(:,i+1);
            u_matrix(:,N+2)=temp(:,i+2);
            %��ֵͳ�Ƽ�֦
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
            %����У��㣬����У���֦
          
            %�˴�ͳ�Ƶ�ǰ�����´��·��������
            activePath = 0;
            for ii = 1 : L
                if u_matrix(ii,N+1) > -inf
                    activePath = activePath + 1;
                end
            end
            %ȫ������֦�Ļ����������
            if activePath==0
                u_matrix(1,N+1)=temp_best;
                activePath=1;
                allcut=allcut+1;
            end
            pathCount(i)=activePath;
        end
    end%�̶�����
end
[~,index]=sort(u_matrix(:,N+1),'descend');
% tmp=zeros(1,L);
% for ii=1:L
%     tmp(ii)=u_matrix(ii,N+2);
% end
% tmp
u_matrix(1,1:N)=u_matrix(index(1),1:N);
j=1;
for i=1:1260                  %����ϢλKλ��������������ȡ����
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
c3=0;%��¼ii
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
        

%�ڶ���ѭ��
for i=1261:1703   %���ϵ��¹���ÿһ������
    i;
    if p(i)==0  %��ǰΪ�̶�����
        if i==1         %��ʱ0.0044
            uu=[];%ǰi-1������
            u=0;%��ǰ���ع���ֵ
            %LLR_matrix=matrix_1;
            LLR=likelihood_rate_c(N,i,uu,LLR_matrix);%%%%%%%%%%% ���������ȻֵLLR
            PM_former=0;%��iλ֮ǰ·������ֵ
            for j=1:L
                u_matrix(j,N+1)=path_metric(i,u,PM_former,LLR,p);%����·������ֵ
                u_matrix(j,N+2)=0;%�ɿ�����
            end
            pathCount(i)=1;%·������Ϊ1
        else           % i���ǵ�һ��    ǰ���й�����ı���          ��ʱ0.012*512
            u=0;
            for j=1:L  %����ѭ������ÿ��·������ֵ
                j;
                uu=u_matrix(j,1:i-1); %ǰi-1�����ع�������
                %LLR_matrix=matrix_1;
                LLR=likelihood_rate_c(N,i,uu,LLR_matrix);%�ݹ���������Ȼ��     Elapsed time is 0.0004 seconds.L=32 
                PM_former=u_matrix(j,N+1);%��j��·����ǰi-1�����ص�·������ֵ
                u_matrix(j,N+1)=path_metric( i,u,PM_former,LLR,p );%��j��·���ĵ�ǰ·������ֵ         Elapsed time is 0.000005 seconds.
            end
            pathCount(i)=pathCount(i-1);% ÿ��·��������
        end
    else  %p(i)==1  ��ǰΪ��Ϣ����
        flag=flag+1;
        if flag<=Flag %��ʱҪ��������·�� �������  %��ʱ 0.0462s
            u_matrix(:,i)=reserve_all(:,flag); %��reserve_all�ĵ�flag�е�L�����ݸ���u_matrix�ĵ�i�е�L��
            for j=1:L
                j;
                uu=u_matrix(j,1:i-1);%ǰi-1������
                u=u_matrix(j,i);
                %LLR_matrix=matrix_1;
                PM_former=u_matrix(j,N+1);
                if PM_former>-inf
                    LLR=likelihood_rate_c(N,i,uu,LLR_matrix);
                    if isReliable(LLR,expectedLLR(i))==1 %�㹻�ɿ�
                        if (1-2*u) ~= sign(LLR)%�㹻�ɿ��������´��ˣ���ô·������ֵΪ������
                            u_matrix(j,N+1)=-inf; 
                        end
                    else %���ɿ�
                        u_matrix(j,N+1)=path_metric( i,u,PM_former,LLR,p ); %����·������ֵ
                    end
                else   %PM_former = -inf
                    u_matrix(j,N+1)=-inf;
                end            
                
                
                if isReliable(LLR,expectedLLR(i))==1
                    u_matrix(j,N+2)=u_matrix(j,N+2)+1;
                end
            end    %flagС��Flag�����£�jѭ������
            
            activePath = 0;
            for ii = 1 : L
                if u_matrix(ii,N+1) > -inf
                    activePath = activePath + 1;
                end
            end
            pathCount(i)=activePath/(2^(Flag-flag));
            %             pathCount(i)=pathCount(i-1)*2;
        else   %flag>Flag                                   %��ʱ4.7241s
            for j=1:L
                j;
                uu=u_matrix(j,1:i-1);
                %LLR_matrix=matrix_1;
                PM_former=u_matrix(j,N+1);
                if PM_former>-inf
                    LLR=likelihood_rate_c(N,i,uu,LLR_matrix);%%%%%%%%%%%%%%%%%%%
                    if isReliable(LLR,expectedLLR(i))==1 %�㹻�ɿ�
                        if sign(LLR)==-1  %ֱ���ж�Ϊ1
                            PM_temp(2*j-1,2)=path_metric(i,1,PM_former,LLR,p);   %PM_temp���������д��ж�����Ϊ1��·������ֵ
                            PM_temp(2*j,2)=-inf;%0����
                        else  %ֱ���ж�Ϊ0
                            PM_temp(2*j-1,2)=-inf;%1����
                            PM_temp(2*j,2)=path_metric(i,0,PM_former,LLR,p);%PM_temp����ż���д��ж�����Ϊ0��·������ֵ
                        end
                    else %���ɿ�
                        PM_temp(2*j-1,2)=path_metric(i,1,PM_former,LLR,p);   %PM_temp���������д��ж�����Ϊ1��·������ֵ
                        PM_temp(2*j,2)=path_metric(i,0,PM_former,LLR,p);%PM_temp����ż���д��ж�����Ϊ0��·������ֵ
                    end
                else
                    PM_temp(2*j-1,2)=-inf;   %PM_temp���������д��ж�����Ϊ1��·������ֵ
                    PM_temp(2*j,2)=-inf;%PM_temp����ż���д��ж�����Ϊ0��·������ֵ
                end
                
                PM_temp(2*j-1,3)=0;
                PM_temp(2*j,3)=0;
                if isReliable(LLR,expectedLLR(i))==1
                    if sign(LLR)==1
                        PM_temp(2*j,3)=1;%�ж�Ϊ0�ɿ�
                    else
                        PM_temp(2*j-1,3)=1;%�ж�Ϊ1�ɿ�
                    end
                end
            end %flag����Flag�����µ�jѭ������
            
            
            [a,b]=sort(PM_temp(:,2),'descend'); %��L��·����·������ֵ����������
            
            temp=zeros(L,i+2);%zeros(0,i+1)
            for k=1:L                                            %���ѭ�����ڴ�2L������ֵ��ѡȡ�ϴ��L��
                if  mod(b(k),2)==1                               %������ʾ���һλ��1��tempcode��i+1λ�Ǹ�·����pm
                    reliableCount = u_matrix((b(k)+1)/2,N+2) + PM_temp(b(k),3);
                    temp(k,:)=[u_matrix((b(k)+1)/2,1:i-1),1,a(k),reliableCount]; %�ҳ�������Ӧu_matrix��ĵĵڼ�������
                else                                              %ż����ʾ���һλ��0 ��tempcode��i+1λ�Ǹ�·����pm
                    reliableCount = u_matrix(b(k)/2,N+2) + PM_temp(b(k),3);
                    temp(k,:)=[u_matrix(b(k)/2,1:i-1),0,a(k),reliableCount];
                end
            end
            u_matrix(:,1:i)=temp(:,1:i);
            u_matrix(:,N+1)=temp(:,i+1);
            u_matrix(:,N+2)=temp(:,i+2);
            %��ֵͳ�Ƽ�֦
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
            %����У��㣬����У���֦
          
            %�˴�ͳ�Ƶ�ǰ�����´��·��������
            activePath = 0;
            for ii = 1 : L
                if u_matrix(ii,N+1) > -inf
                    activePath = activePath + 1;
                end
            end
            %ȫ������֦�Ļ����������
            if activePath==0
                u_matrix(1,N+1)=temp_best;
                activePath=1;
                allcut=allcut+1;
            end
            pathCount(i)=activePath;
        end
    end%�̶�����
end
[~,index]=sort(u_matrix(:,N+1),'descend');
% tmp=zeros(1,L);
% for ii=1:L
%     tmp(ii)=u_matrix(ii,N+2);
% end
% tmp
u_matrix(1,1:N)=u_matrix(index(1),1:N);
j=1;
for i=1261:1703                  %����ϢλKλ��������������ȡ����
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
c4=0;%��¼ii
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



%������ѭ��
for i=1704:2048   %���ϵ��¹���ÿһ������
    i;
    if p(i)==0  %��ǰΪ�̶�����
        if i==1         %��ʱ0.0044
            uu=[];%ǰi-1������
            u=0;%��ǰ���ع���ֵ
            %LLR_matrix=matrix_1;
            LLR=likelihood_rate_c(N,i,uu,LLR_matrix);%%%%%%%%%%% ���������ȻֵLLR
            PM_former=0;%��iλ֮ǰ·������ֵ
            for j=1:L
                u_matrix(j,N+1)=path_metric(i,u,PM_former,LLR,p);%����·������ֵ
                u_matrix(j,N+2)=0;%�ɿ�����
            end
            pathCount(i)=1;%·������Ϊ1
        else           % i���ǵ�һ��    ǰ���й�����ı���          ��ʱ0.012*512
            u=0;
            for j=1:L  %����ѭ������ÿ��·������ֵ
                j;
                uu=u_matrix(j,1:i-1); %ǰi-1�����ع�������
                %LLR_matrix=matrix_1;
                LLR=likelihood_rate_c(N,i,uu,LLR_matrix);%�ݹ���������Ȼ��     Elapsed time is 0.0004 seconds.L=32 
                PM_former=u_matrix(j,N+1);%��j��·����ǰi-1�����ص�·������ֵ
                u_matrix(j,N+1)=path_metric( i,u,PM_former,LLR,p );%��j��·���ĵ�ǰ·������ֵ         Elapsed time is 0.000005 seconds.
            end
            pathCount(i)=pathCount(i-1);% ÿ��·��������
        end
    else  %p(i)==1  ��ǰΪ��Ϣ����
        flag=flag+1;
        if flag<=Flag %��ʱҪ��������·�� �������  %��ʱ 0.0462s
            u_matrix(:,i)=reserve_all(:,flag); %��reserve_all�ĵ�flag�е�L�����ݸ���u_matrix�ĵ�i�е�L��
            for j=1:L
                j;
                uu=u_matrix(j,1:i-1);%ǰi-1������
                u=u_matrix(j,i);
                %LLR_matrix=matrix_1;
                PM_former=u_matrix(j,N+1);
                if PM_former>-inf
                    LLR=likelihood_rate_c(N,i,uu,LLR_matrix);
                    if isReliable(LLR,expectedLLR(i))==1 %�㹻�ɿ�
                        if (1-2*u) ~= sign(LLR)%�㹻�ɿ��������´��ˣ���ô·������ֵΪ������
                            u_matrix(j,N+1)=-inf; 
                        end
                    else %���ɿ�
                        u_matrix(j,N+1)=path_metric( i,u,PM_former,LLR,p ); %����·������ֵ
                    end
                else   %PM_former = -inf
                    u_matrix(j,N+1)=-inf;
                end            
                
                
                if isReliable(LLR,expectedLLR(i))==1
                    u_matrix(j,N+2)=u_matrix(j,N+2)+1;
                end
            end    %flagС��Flag�����£�jѭ������
            
            activePath = 0;
            for ii = 1 : L
                if u_matrix(ii,N+1) > -inf
                    activePath = activePath + 1;
                end
            end
            pathCount(i)=activePath/(2^(Flag-flag));
            %             pathCount(i)=pathCount(i-1)*2;
        else   %flag>Flag                                   %��ʱ4.7241s
            for j=1:L
                j;
                uu=u_matrix(j,1:i-1);
                %LLR_matrix=matrix_1;
                PM_former=u_matrix(j,N+1);
                if PM_former>-inf
                    LLR=likelihood_rate_c(N,i,uu,LLR_matrix);%%%%%%%%%%%%%%%%%%%
                    if isReliable(LLR,expectedLLR(i))==1 %�㹻�ɿ�
                        if sign(LLR)==-1  %ֱ���ж�Ϊ1
                            PM_temp(2*j-1,2)=path_metric(i,1,PM_former,LLR,p);   %PM_temp���������д��ж�����Ϊ1��·������ֵ
                            PM_temp(2*j,2)=-inf;%0����
                        else  %ֱ���ж�Ϊ0
                            PM_temp(2*j-1,2)=-inf;%1����
                            PM_temp(2*j,2)=path_metric(i,0,PM_former,LLR,p);%PM_temp����ż���д��ж�����Ϊ0��·������ֵ
                        end
                    else %���ɿ�
                        PM_temp(2*j-1,2)=path_metric(i,1,PM_former,LLR,p);   %PM_temp���������д��ж�����Ϊ1��·������ֵ
                        PM_temp(2*j,2)=path_metric(i,0,PM_former,LLR,p);%PM_temp����ż���д��ж�����Ϊ0��·������ֵ
                    end
                else
                    PM_temp(2*j-1,2)=-inf;   %PM_temp���������д��ж�����Ϊ1��·������ֵ
                    PM_temp(2*j,2)=-inf;%PM_temp����ż���д��ж�����Ϊ0��·������ֵ
                end
                
                PM_temp(2*j-1,3)=0;
                PM_temp(2*j,3)=0;
                if isReliable(LLR,expectedLLR(i))==1
                    if sign(LLR)==1
                        PM_temp(2*j,3)=1;%�ж�Ϊ0�ɿ�
                    else
                        PM_temp(2*j-1,3)=1;%�ж�Ϊ1�ɿ�
                    end
                end
            end %flag����Flag�����µ�jѭ������
            
            
            [a,b]=sort(PM_temp(:,2),'descend'); %��L��·����·������ֵ����������
            
            temp=zeros(L,i+2);%zeros(0,i+1)
            for k=1:L                                            %���ѭ�����ڴ�2L������ֵ��ѡȡ�ϴ��L��
                if  mod(b(k),2)==1                               %������ʾ���һλ��1��tempcode��i+1λ�Ǹ�·����pm
                    reliableCount = u_matrix((b(k)+1)/2,N+2) + PM_temp(b(k),3);
                    temp(k,:)=[u_matrix((b(k)+1)/2,1:i-1),1,a(k),reliableCount]; %�ҳ�������Ӧu_matrix��ĵĵڼ�������
                else                                              %ż����ʾ���һλ��0 ��tempcode��i+1λ�Ǹ�·����pm
                    reliableCount = u_matrix(b(k)/2,N+2) + PM_temp(b(k),3);
                    temp(k,:)=[u_matrix(b(k)/2,1:i-1),0,a(k),reliableCount];
                end
            end
            u_matrix(:,1:i)=temp(:,1:i);
            u_matrix(:,N+1)=temp(:,i+1);
            u_matrix(:,N+2)=temp(:,i+2);
            %��ֵͳ�Ƽ�֦
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
            %����У��㣬����У���֦
          
            %�˴�ͳ�Ƶ�ǰ�����´��·��������
            activePath = 0;
            for ii = 1 : L
                if u_matrix(ii,N+1) > -inf
                    activePath = activePath + 1;
                end
            end
            %ȫ������֦�Ļ����������
            if activePath==0
                u_matrix(1,N+1)=temp_best;
                activePath=1;
                allcut=allcut+1;
            end
            pathCount(i)=activePath;
        end
    end%�̶�����
end
[~,index]=sort(u_matrix(:,N+1),'descend');
% tmp=zeros(1,L);
% for ii=1:L
%     tmp(ii)=u_matrix(ii,N+2);
% end
% tmp
u_matrix(1,1:N)=u_matrix(index(1),1:N);
j=1;
for i=1704:2048                  %����ϢλKλ��������������ȡ����
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
c5=0;%��¼ii
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
 


