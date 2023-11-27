function insert(root, logicalArray, BERsValue)
    node = root;
    for i = 1:length(logicalArray)
        bit = logicalArray(i);
        if bit == 0
            if isempty(node.left)
                node.left = TrieNode();
            end
            node = node.left;
        else
            if isempty(node.right)
                node.right = TrieNode();
            end
            node = node.right;
        end
    end
    node.isEndOfWord = true;
    node.BERs = BERsValue;  % 存储BERs值
    pause(1);
end
