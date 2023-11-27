function PM = path_metric( i,u,PM_former,LLR,p )
%�����Ǽ���·����������Ϊ��·������Ӧ���������еĸ��ʣ����ö�����ʽ������ֵ���չ�ʽ�ݹ����õ�
%����i�ǵ�iλ���ƣ�uΪ�����Ƶ���Ϣ���ػ�̶����أ�PM_former�ǵ�iλ֮ǰ��·��������pλΪ�þ���ָʾ��Ϣλ�͹̶�λ��λ�ã�LLRΪ��Ӧ�Ķ�����Ȼ�Ⱦ���
%���PMΪ·������ֵ

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

