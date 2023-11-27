function [y] =polarEnc(x,N,p)
%������ʵ��polar����
%����xΪ����crcУ��λ����Ϣ�������У�NΪ����������г��ȣ�pΪλ�þ���ָʾ��Ϣλ�ú͹̶�λ�ã����ΪN���Ļ�ϱ�������
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
