function [x,pathCount] = polarDec_noCheck(L,y,p,sigma,infoBitCount,expectedLLR)
%��������ɽ�����������
%����L��·��������ȣ�y�ǽ������г���ΪN��p��λ�þ���ָʾ��Ϣ���غ͹̶����ص�λ��,sigmaΪ�ŵ���˹�����ı�׼��
%���x������õ�����Ϣ��������
N=length(y);
Flag=log2(L); %   %%%%%%%%%%%%%      %Flag����ָʾL��·����ѡȡ�������л�flag<=Flagȫѡ��������ȡ�ϴ��L��
u_matrix=zeros(L,N+2);  %�þ�����һ����L*(N+1)���Ķ�ά����u_matrix��ÿһ�е�ǰN�д��һ������·����Ӧ�����֣�u_matrix(:,N+1)���Ӧ�ź�ѡ·���Ķ���ֵ,N+2λ��ź�ѡ·���пɿ��������
reserve_all=path_matrix(L);
flag=0;                          %��ʾ��ǰ��û��������һ����Ϣλ
PM_temp=zeros(2*L,3);             %���2L�����ִ����ж�λ�ã�����ѡ��L�����ִ�����ʱ����,��1�д�0/1���ڶ��д�PM�������д��Ƿ�ɿ�
PM_temp(1:2:2*L,1)=ones(L,1);   %�ѵ�һ�������е�ֵ��Ϊ1
LLR_matrix=2.*y./sigma^2;
uk=zeros(L,512);
pathCount = zeros(L,1);
% expectedLLR=50;
threshold=0;
%branch_time=[0 0 0 0];             %��֧��ʱ
allcut=0;
ci=1; %��ʾ�ڼ���У���
lastCheckPoint=0;
for i=1:N
    i;
    if p(i)==0
        if i==1         %��ʱ0.0044
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
        else                 %��ʱ0.012*512
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
        if flag<=Flag %��ʱҪ��������·�� �������  %��ʱ 0.0462s
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
        else                                    %��ʱ4.7241s
            for j=1:L
                j;
                uu=u_matrix(j,1:i-1);
                %LLR_matrix=matrix_1;
                PM_former=u_matrix(j,N+1);
                if PM_former>-inf
                    LLR=likelihood_rate_c(N,i,uu,LLR_matrix);%%%%%%%%%%%%%%%%%%%
                    if isReliable(LLR,expectedLLR(i))==1
                        if sign(LLR)==-1  %ֱ���ж�Ϊ1
                            PM_temp(2*j-1,2)=path_metric(i,1,PM_former,LLR,p);   %PM_temp���������д��ж�����Ϊ1��·������ֵ
                            PM_temp(2*j,2)=-inf;%0����
                        else
                            PM_temp(2*j-1,2)=-inf;%1����
                            PM_temp(2*j,2)=path_metric(i,0,PM_former,LLR,p);%PM_temp����ż���д��ж�����Ϊ0��·������ֵ
                        end
                    else
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
            end
            [a,b]=sort(PM_temp(:,2),'descend');
            
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
for i=1:N                  %����ϢλKλ��������������ȡ����
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
