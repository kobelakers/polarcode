function storeData(mode, key, BERs,md5hash)
    
    if strcmp(mode.mode, 'trie')
        root = mode.identifier;
        insert(root, key, BERs);  % 假设你已经定义了一个 insert 函数来处理这个
    elseif strcmp(mode.mode, 'redis')
        strBER = num2str(BERs);  % 转换double为字符串
        R = mode.identifier;
        [R, M] = redisSet(R, md5hash, strBER);
        assert_string(M, 'OK');
    else
        error('Invalid storage mode');
    end
end
