function res = isReliable(llr,expectedLLR)
%����������llr�жϵ�ǰ���Ƿ�ɿ�
%�ɿ�����1�����򷵻�0
if abs(llr) >= abs(expectedLLR)*0.3
% if abs(llr) >= inf
    res = 1;
else
    res = 0;
end


