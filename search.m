function BERsValue = search(root, logicalArray)
    node = root;
    for i = 1:length(logicalArray)
        bit = logicalArray(i);
        if bit == 0
            if isempty(node.left)
                BERsValue = NaN;  % 或者使用其他表示“未找到”的值
                return;
            end
            node = node.left;
        else
            if isempty(node.right)
                BERsValue = NaN;  % 或者使用其他表示“未找到”的值
                return;
            end
            node = node.right;
        end
    end
    if node.isEndOfWord
        BERsValue = node.BERs;
    else
        BERsValue = NaN;  % 或者使用其他表示“未找到”的值
    end
end
