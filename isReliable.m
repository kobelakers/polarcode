function res = isReliable(llr,expectedLLR)
%根据索引及llr判断当前点是否可靠
%可靠返回1，否则返回0
if abs(llr) >= abs(expectedLLR)*0.3
% if abs(llr) >= inf
    res = 1;
else
    res = 0;
end


