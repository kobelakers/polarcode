classdef TrieNode < handle
    properties
        isEndOfWord;  % 布尔值，表示这是否是一个单词/变量的末尾
        BERs;  % 存储BERs值
        left;  % 左子节点，表示0
        right;  % 右子节点，表示1
    end
    methods
        function obj = TrieNode()
            obj.isEndOfWord = false;
            obj.BERs = [];  % 初始化为空
            obj.left = [];
            obj.right = [];
        end
    end
end
