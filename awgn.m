function [y] =awgn(x,len,sigma)
%功能是向发送的混合比特添加awgn噪声，模拟发送序列通过信道
% 输入x为bpsk后的混合比特，len为其长度，sigma为高斯噪声标准差，输出即为接收比特
noises = sigma*randn(1, len);
y=x+noises;
end

