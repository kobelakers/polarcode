function [y] =polarEnc(x,N,p)
%功能是实现polar编码
%输入x为加入crc校验位的信息比特序列，N为编码后发送序列长度，p为位置矩阵，指示信息位置和固定位置，输出为N长的混合比特序列
j=0;
h=zeros(1,N);
y=zeros(1,N);
for i=1:N
    if(p(i)==1)
        j=j+1;
        h(i)=x(j);
    else
        h(i)=0;
    end
end
n=log2(N);
F=[1 0;1 1];
A=F;
for k = 1:1:n-1
A=kron(A,F);
end
s=h*A;
for i=1:N
if mod(s(i),2)==0
       s(i)=0;
    else
        s(i)=1;
end
end
i=1:N;
i=(i-1).';
w=dec2bin(i);
w=fliplr(w);
i=bin2dec(w)+1;
m=i.';
for n=1:N
    y(n)=s(m(n));
end
