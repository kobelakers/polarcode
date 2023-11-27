function x = attachParityCheck(u,checkPoint)
%
n=length(checkPoint);
res=zeros(n,1);
x=zeros(1,length(u)+n);
blockLength=zeros(n,1);
for i=1:n
    if i==1
        blockLength(i)=checkPoint(i)-1;
    else
        blockLength(i)=checkPoint(i)-checkPoint(i-1)-1;
    end
end
%分段校验
for i=1:n
    if i==1
        for j=1:blockLength(i)
            res(i)=xor(res(i),u(j));
        end
    else
        for j=1:blockLength(i)
            res(i)=xor(res(i),u(j+checkPoint(i-1)-i+1));
        end
    end
end

%全段校验
% for i=1:n
%     for j=1:checkPoint(i)-1
%         res(i)=xor(res(i),u(j));
%     end
% end

for i=1:n+1
    if i==1
        x(1:blockLength(i)+1)=[u(1:blockLength(i)),res(i)];
    elseif i==n+1
        x(checkPoint(i-1)+1:length(u)+n)=u(checkPoint(i-1)-i+2:length(u));
    else
        x(checkPoint(i-1)+1:checkPoint(i))=[u(checkPoint(i-1)-i+2:checkPoint(i)-i),res(i)];
    end
end

end

