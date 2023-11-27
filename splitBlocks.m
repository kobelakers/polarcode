function [start,blockLength] = splitBlocks(EbN0)
N=1024;
K=512;
sigma=sqrt(N/(2*10^(EbN0/10)*K));
constructed_code_file_name = sprintf('constructedCode\\PolarCode_block_length_%d_sigma_%.2f_method_origin_GA.txt',N,sigma);
indices = load(constructed_code_file_name);
pp=zeros(N,1);
pp(indices(1:K))=1;
p=logical(pp);

%�ֳ������Ŀ�
contBlockNum=0;
for i=2:length(p)
    if p(i)==1 && p(i-1)==0
        contBlockNum=contBlockNum+1;
        contstart(contBlockNum)=i;
    elseif p(i)==0 && p(i-1)==1
        contLength(contBlockNum)=i-contstart(contBlockNum);
    elseif i==length(p)
        contLength(contBlockNum)=i-contstart(contBlockNum)+1;
    end
end
aaa=2;

%ÿ�������Ŀ��ٻ���
count=0;
for i=1:contBlockNum
    if contLength(i)==1
        count=count+1;
        start(count)=contstart(i);
        blockLength(count)=1;
    elseif mod(contstart(i),2)==0 && contLength(i)>1 %ż����ͷ����ͷ
        count=count+1;
        start(count)=contstart(i);
        blockLength(count)=1;
        if mod(contstart(i)+contLength(i)-1,2)==0 %ż����β������
            bin=dec2bin(contLength(i)-1);
            unitCount=length(bin);
            unit=0;
            for j=unitCount:-1:1
                if bin(j)=='1'
                    unit=unit+1;
                    size(unit)=2^(unitCount-j);
                end
            end
            for k=1:unit
                count=count+1;
                start(count)=start(count-1)+blockLength(count-1);
                blockLength(count)=size(k);
            end
        else
            %������β��ȥβ
            bin=dec2bin(contLength(i)-2);
            unitCount=length(bin);
            unit=0;
            for j=unitCount:-1:1
                if bin(j)=='1'
                    unit=unit+1;
                    size(unit)=2^(unitCount-j);
                end
            end
            for k=1:unit
                count=count+1;
                start(count)=start(count-1)+blockLength(count-1);
                blockLength(count)=size(k);
            end
            count=count+1;
            start(count)=start(count-1)+blockLength(count-1);
            blockLength(count)=1;
        end
    else %������ͷ������
        if mod(contstart(i)+contLength(i)-1,2)==0 %ż����β������
            bin=dec2bin(contLength(i));
            unitCount=length(bin);
            unit=0;
            for j=unitCount:-1:1
                if bin(j)=='1'
                    unit=unit+1;
                    size(unit)=2^(unitCount-j);
                end
            end
            for k=1:unit
                count=count+1;
                if k==1
                    start(count)=contstart(i);
                else
                    start(count)=start(count-1)+blockLength(count-1);
                end
                blockLength(count)=size(k);
            end
        else
            %������β��ȥβ
            bin=dec2bin(contLength(i)-1);
            unitCount=length(bin);
            unit=0;
            for j=unitCount:-1:1
                if bin(j)=='1'
                    unit=unit+1;
                    size(unit)=2^(unitCount-j);
                end
            end
            for k=1:unit
                count=count+1;
                if k==1
                    start(count)=contstart(i);
                else
                    start(count)=start(count-1)+blockLength(count-1);
                end
                blockLength(count)=size(k);
            end
            count=count+1;
            start(count)=start(count-1)+blockLength(count-1);
            blockLength(count)=1;
        end
    end
end

index=zeros(1,length(blockLength));
index(1)=1;
for i=2:length(blockLength)
    index(i)=index(i-1)+blockLength(i);
end

index=zeros(1,length(contLength));
index(1)=1;
for i=2:length(contLength)
    index(i)=index(i-1)+contLength(i);
end

end





