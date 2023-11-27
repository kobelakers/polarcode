function checkPointSelect(ebn0,checkPoint)
%
N=1024;
K=512;
sigma=sqrt(N/(2*10^(ebn0/10)*(K-4)));
% sigma=0.79;
constructed_code_file_name = sprintf('constructedCode\\PolarCode_block_length_%d_sigma_%.2f_method_origin_GA.txt',N,sigma);
indices = load(constructed_code_file_name);
pp=zeros(N,1);
pp(indices(1:K))=1;
p=logical(pp);

indexErrProb_file_name = sprintf('indexErrProbs_%d_sigma_%.2f_method_origin_GA.txt',N,sigma);
indexErrProb=load(indexErrProb_file_name);
scatter(1:N,indexErrProb,'b*');
hold on;

infoBitCount=zeros(N,1);
if p(1)
   infoBitCount(1) = 1;
end
for i = 2:N
   if p(i)
        infoBitCount(i) = infoBitCount(i-1) + 1;
   else
       infoBitCount(i) = infoBitCount(i-1);
   end
end

ci=1;
for i=1:N
    if p(i) && ci<=length(checkPoint) && infoBitCount(i)==checkPoint(ci)
        i
        indexErrProb(i)
        scatter(i,indexErrProb(i),'ro','filled');
        ci=ci+1;
        hold on;
    end
end

ylim([0 2e-4])


end

