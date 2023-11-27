function [exists, BER,md5hash] = isExist(modeStruct, p)
    BER = NaN;
    exists = false;
    md5hash = ''; % 初始化为空字符串
    if strcmp(modeStruct.mode, 'trie')
        root = modeStruct.identifier;
        BERsValue = search(root, p);  % identifier 作为 root 传入
        if ~isnan(BERsValue)  % 如果不是 NaN，那么存在
           exists = true;
           BER = BERsValue;
        end
    elseif strcmp(modeStruct.mode, 'redis')
        % 将逻辑数组转换为字符串
        pStr = num2str(p, '%d');  % 转换为 0 和 1 组成的字符串

        % 去除空格，因为 num2str 会在数字之间添加空格
        pStr = strrep(pStr, ' ', '');

        % 计算 MD5 值
        md5hash = generateMD5(pStr);

        % 尝试从 Redis 中获取数据
        [Value, R, S] = redisGet(modeStruct.identifier, md5hash);
        if strcmp(S, 'OK')
            exists = true;
            curBER = str2double(Value);
            BER = curBER;
        end
    else
        error('Invalid search mode');
    end
end
