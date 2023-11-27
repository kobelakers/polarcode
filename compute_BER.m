function BERs = compute_BER(A,expectedLLR,R,N,K,mode,pop_index)

g=logical([1 1 1 1 1 1 0 0 1]);

rows = size(A, 1);
BERs = zeros(rows, 1);

L=8;
crcLength=0;
frame=100;
    % 使用循环遍历每一行
    for row = 1:rows
        % 获取当前行的数据
        p = A(row, :);
        [exists, BER,md5hash] = isExist(mode,p);
        if exists
            curBER = BER;
            BERs(row)=curBER;
            % 打印curBER到命令行窗口
            disp(['curBER: ' num2str(curBER)]);
        else% 如果不存在，则执行其他逻辑

        %定义数组统计当前索引下已出现过的信息位数量
        infoBitCount=zeros(N,1);
        if p(1)
           infoBitCount(1) = 1;
        end
        for i = 2:N
           if p(i)
              infoBitCount(i) = infoBitCount(i-1) + 1;
           else
               infoBitCount(i) = infoBitCount(i-1);
           end
        end
        parityCheckLength=0;
        % checkPoint=[136,244,353,448];   %1db
        % checkPoint=[126,254,363,438];   %1db  中段
        % checkPoint=[137,244,353,448];   %1.5db
        % checkPoint=[126,254,363,438];   %1.5db   中段
        % checkPoint=[141,254,353,448];   %2db   尾段
        % checkPoint=[129,254,363,438];   %2db   中段
        checkPoint=[];   %2db   新中段
        % checkPoint=[124,230,337,417];   %2db   初段
        % checkPoint=[50,99,138,178,216,276,322,385];  %2.5db
        % checkPoint=[129,254,363,438];   %2.5db   中段
        % checkPoint=[143,279,353,448]; %3db
        % checkPoint=[133,269,363,438]; %3db  中段
        parityCheckLength=length(checkPoint);

        %输出编码后校验点索引



        %大赛所用信息/固定比特位置配置
        EbN0=1;%仿真信噪比
        lE=length(EbN0);
        err_ber=zeros(1,lE);  %%程序开始之前没有误码，误比特个数
        err_bler=zeros(1,lE);  %%误码块个数
        errorrate_ber=zeros(1,lE);%误比特率
        errorrate_bler=zeros(1,lE);%误码块率
        allPathCount=zeros(N,lE);

            fprintf('\n Now running:%f  [%d of %d] \n\t Iteration-Counter: %53d',EbN0(1),1,length(EbN0),0);
            sigma=sqrt(N/(2*10^(EbN0(1)/10)*(K-crcLength)));%高斯噪声标准差
            for zs=1:frame
%                 u=genSrc(K-crcLength-parityCheckLength);%生成随机序列 0.003087 seconds.
%         %         x=attachCRC24(u,g);%加入CRC校验位 0.006702 seconds.
%         %         x=u;
%         %         x=attachParityCheck(u,checkPoint);%加入奇偶校验
%                 x1=polarEnc(u,N,p);%编码后的比特序列,大概0.05s
%                 x11=bpsk(x1,N);%发送比特序列0.001226 seconds.
%                 y=awgn(x11,N,sigma);%加入噪声后的接收比特序列 0.000822 seconds.


%%%%
        u=genSrc(K-24-parityCheckLength);%鐢熸垚闅忔満搴忓垪 0.003087 seconds.
        x1=attachCRC8(u(1:333),g);
        x2=attachCRC8(u(334:666),g);
        x3=attachCRC8(u(667:1000),g);
       
        x4=[x1,x2,x3];
%         x=u;
%       x2=attachParityCheck(x,checkPoint);%鍔犲叆濂囧伓鏍￠獙
        x5=polarEnc(x4,N,p);%鐮佸悗鐨勬瘮鐗瑰簭鍒?,澶ф0.05s
        x11=bpsk(x5,N);%鍙戦?佹瘮鐗瑰簭鍒?0.001226 seconds.
        y=awgn(x11,N,sigma);%鍔犲叆鍣０鍚庣殑鎺ユ敹姣旂壒搴忓垪 0.000822 seconds.


%%%%
                %tic
                [uyima,pathCount]=polarDec1(L,y,p,sigma,infoBitCount,expectedLLR,checkPoint);%译码后序列，一次译码要10.221911 seconds
        %         [uyima,pathCount]=polarDec_noCheck(L,y,p,sigma,infoBitCount,expectedLLR);
                allPathCount(:,1) = allPathCount(:,1) + pathCount;
                %toc
                errbits=length(find(uyima~=u));%译码后序列和信息序列不同bit的长度
                if errbits~=0
                    errblock=1;
                else
                    errblock=0;
                end
                err_ber(1)=errbits+err_ber(1);%err用于统计当前的错误bit总个数
                err_bler(1)=errblock+err_bler(1);%统计误块个数
                if mod(zs,20)==0
                    for iiiii=1:53
                        fprintf('\b');
                    end
                    fprintf(' %7d   ---- %7d FEs, %7d BEs found so far',zs,err_bler(1),err_ber(1));
                end
            end
            errorrate_ber(lE)=err_ber(lE)./(length(u)*frame)%计算误码率
            BERs(row)=errorrate_ber(lE);
            curBER = BERs(row);
            
            storeData(mode,p,curBER,md5hash);
            
        end

    end
end