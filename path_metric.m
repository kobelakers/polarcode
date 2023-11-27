function PM = path_metric( i,u,PM_former,LLR,p )
%功能是计算路径度量，即为该路径所对应的译码序列的概率，采用对数形式，度量值按照公式递归计算得到
%输入i是第i位估计，u为待估计的信息比特或固定比特，PM_former是第i位之前的路径度量，p位为置矩阵，指示信息位和固定位的位置，LLR为对应的对数似然比矩阵
%输出PM为路径度量值

if (p(i)==1 || (p(i)==0 && u==0)) && ((1-2*u) == sign(LLR))
    if i==1
        PM = 0;
    else 
        PM = PM_former;
    end
elseif (p(i)==1 || (p(i)==0 && u==0)) && ((1-2*u) ~= sign(LLR))
    if i==1
        PM = 0-abs(LLR);
    else
        PM = PM_former-abs(LLR);
    end
else
    PM = -inf;
end
end

