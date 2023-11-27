function LLR = likelihood_rate(N,i,uu,LLR_matrix)
%功能是计算对数似然比
%输入N是在当前递归过程中的信道总数，i是这N个复合信道中的第i个子信道；uu是前i-1个已知的估计，是一个长度为i-1的向量，LLR_matrix是对数似然比矩阵
%输出LLR是对数似然比矩阵

if N==1
    LLR=LLR_matrix(1);
 else
    if mod(i,2)==1    %i为奇数
        uoe = mod(uu(1:2:i-2)+uu(2:2:i-1),2); %输入奇数项与偶数项异或
        ue = uu(2:2:i-1);%输入偶数项
        L1 = likelihood_rate(N/2,(i+1)/2,uoe,LLR_matrix(1,1:N/2));
        L2 = likelihood_rate(N/2,(i+1)/2,ue,LLR_matrix(1,N/2+1:N));
        LLR = sign(L1.*L2).*min(abs(L1),abs(L2));
    else    %i为偶数
        uoe = mod(uu(1:2:i-3)+uu(2:2:i-2),2); %输入奇数项与偶数项异或
        ue = uu(2:2:i-2);%输入偶数项
        L1 = likelihood_rate(N/2,i/2,uoe,LLR_matrix(1,1:N/2));
        L2 = likelihood_rate(N/2,i/2,ue,LLR_matrix(1,N/2+1:N));
        LLR = (-1)^uu(i-1).*L1+L2;
    end
    
end
end


