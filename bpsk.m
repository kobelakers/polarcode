function y=bpsk(x,len)
%ʵ��һ���򵥵�ӳ���ϵ
%����xΪ�����Ļ�����У�lenΪ�䳤
y=zeros(1,length(x));
for i=1:len
    if x(i)==0
        y(i)=1;
    else
        y(i)=-1;
    end

end

