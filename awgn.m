function [y] =awgn(x,len,sigma)
%���������͵Ļ�ϱ������awgn������ģ�ⷢ������ͨ���ŵ�
% ����xΪbpsk��Ļ�ϱ��أ�lenΪ�䳤�ȣ�sigmaΪ��˹������׼������Ϊ���ձ���
noises = sigma*randn(1, len);
y=x+noises;
end

