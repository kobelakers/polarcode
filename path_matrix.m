function y=path_matrix(L)

%���ڹ��쵱��Ҫ����ȫ��·����ʱ���·������
%����LΪ����·������

logL=log2(L);%%%%%%%%%%%%%%%%%%%%%
if logL==0
    y=[];
elseif logL==1
    y=[0;1];
else
    above=[zeros(L/2,1),path_matrix(L/2)];
    below=[ones(L/2,1),path_matrix(L/2)];
    y=[above;below];
end

end