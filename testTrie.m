% 创建前缀树的根节点
root = TrieNode();

% 插入逻辑变量和对应的BERs值
insert(root, [0 1 0 1 0 1], 0.5);
insert(root, [0 1 0 1 1 0], 0.8);

% 进行查询
result1 = search(root, [0 1 0 1 0 1]);  % 应返回 0.5
result2 = search(root, [0 1 0 0]);  % 应返回 NaN 或者其他表示“未找到”的值

% 显示结果
disp(['Result 1: ', num2str(result1)]);
disp(['Result 2: ', num2str(result2)]);

