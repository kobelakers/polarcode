function err = crcCheck24a(input)
%�����ǽ�CRC����,�����շ��յ����ݺ����յ������ݶ�g������Լ���ģ�����ģ2������������Ϊ0������Ϊ���ݴ����޲����������Ϊ0������Ϊ���ݴ�������˴��� % У��λ���� 
lenI=length(input)-24; 
G=[1 1 0 0 0 0 1 1 0 0 1 0 0 1 1 0 0 1 1 1 1 1 0 1 1];
for i= 1:lenI
    if input(i)==1
        for j=(1:length(G))
            input(i+j-1)=xor(input(i+j-1),G(j));
        end
    end
end
% ����Ϊ0����������ȷ����֮������������
if sum(input) == 0
    err = 0;  % 0������ȷ
else
    err = 1;  % 1�������
end