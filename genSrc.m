function [x] = genSrc(len)
%产生随机序列作为信息比特
% 输入只有长度K-24
x=randi([0 1],1,len);
end
