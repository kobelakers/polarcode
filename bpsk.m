function y=bpsk(x,len)
%实现一个简单的映射关系
%输入x为编码后的混合序列，len为其长
y=zeros(1,length(x));
for i=1:len
    if x(i)==0
        y(i)=1;
    else
        y(i)=-1;
    end

end

