function err = crcCheck24a(input)
%功能是解CRC处理,当接收方收到数据后，用收到的数据对g（事先约定的）进行模2除法，若余数为0，则认为数据传输无差错；若余数不为0，则认为数据传输出现了错误， % 校验位长度 
lenI=length(input)-24; 
G=[1 1 0 0 0 0 1 1 0 0 1 0 0 1 1 0 0 1 1 1 1 1 0 1 1];
for i= 1:lenI
    if input(i)==1
        for j=(1:length(G))
            input(i+j-1)=xor(input(i+j-1),G(j));
        end
    end
end
% 余数为0，代表传输正确。反之，代表传输有误。
if sum(input) == 0
    err = 0;  % 0代表正确
else
    err = 1;  % 1代表错误
end