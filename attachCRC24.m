function[y] =attachCRC24(x,g)
%功能是在产生的随机比特后添加24位CRC校验码
%输入x为随机比特序列，g为CRC生成多项式
L = 24;
lenD = length(x);
p = zeros(1,L); % 24 位校验位
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



