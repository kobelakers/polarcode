function[y] =attachCRC8(x,g)
%�������ڲ�����������غ����12λCRCУ����
%����xΪ����������У�gΪCRC���ɶ���ʽ
L = 8;
lenD = length(x);
p = zeros(1,L); % 24 λУ��λ
scrg=[x,zeros(1,L)];
for i= 1:lenD
    if scrg(i)==1
        for j=(1:length(g))
            scrg(i+j-1)=xor(scrg(i+j-1),g(j));
        end
    end
end
for k= 1:L
    p(k)=scrg(lenD+k);
end
y=[x p];





