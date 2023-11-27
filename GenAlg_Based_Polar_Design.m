%%
% For more details:
% A. Elkelesh, M. Ebada, S. Cammerer, and S. ten Brink, 揇ecoder-Tailored Polar Code Design Using the Genetic Algorithm,� IEEE Transactions on Communications, vol. 67, no. 7, pp. 4521�4534, July 2019.
% DOI: 10.1109/TCOMM.2019.2908870
% IEEE URL: https://ieeexplore.ieee.org/document/8680016
% arXiv URL: https://arxiv.org/pdf/1901.10464.pdf
% elkelesh@inue.uni-stuttgart.de
%%

function GenAlg_Based_Polar_Design
% See Fig. 2 and Algorithm 1 in the paper


global R;
trieRoot = TrieNode();

% redisClean(R);
rng('shuffle');

% Output from Algorithm 2 in the paper (i.e., initial population) 
% To get started, we use Bhattacharyya-based design at different design SNRs
% and RM-Polar-based design
data = load('population1.mat');
N = data.N;
k = data.k;
A = data.A;
clear data;

% 初始化 mode 为一个空的结构体
mode = struct('type', '', 'identifier', []);
modeNum = 1;

% 创建 mode 结构体
if modeNum == 1
    mode = createModeIdentifier('trie', trieRoot);
elseif modeNum == 2
    [R, M] = redisConnection();
    redisClean(R);
    mode = createModeIdentifier('redis', R);  % 注意这里是 R，不是 trieRoot
else
    warning('Invalid modeNum, mode remains uninitialized');
end

sigma=0.79;
llr_file_name = sprintf('EepectedLLR_block_length_%d_sigma_%.2f_method_origin_GA.txt',N,sigma);
expectedLLR=load(llr_file_name);

%%%%% Population 1
pop_index = 1;
name = ['population' num2str(pop_index) '.mat'];
[BERs] = compute_BER(A,expectedLLR,R,N,k,mode,pop_index);
save(name,'A','BERs','N','k');

finalBER = getMin5(BERs);
targetBER = finalBER * 0.75;

 while finalBER > targetBER
    % 打印信息到命令行窗口
    disp(['未到达目标BER: ' num2str(targetBER) '，当前BER为: ' num2str(finalBER)]);
    % 暂停5s
    pause(5);
    
    %%%%% Population N_pop
    pop_index = pop_index + 1;
    name = ['population' num2str(pop_index) '.mat'];
    A = population_update(A,BERs);
    A=logical(A);
    [BERs] = compute_BER(A,expectedLLR,R,N,k,mode,pop_index);
    finalBER = getMin5(BERs);
    save(name,'A','BERs','N','k');
end

disp(['最终达标BER为', num2str(finalBER)]);  
redisClean(R);
end