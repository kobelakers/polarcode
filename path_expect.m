function pathExpect = path_expect()
%
str = ['-*';'-^';'-o';'-d';'-s';'-p';'-+';'-^';'->'];
N=1024;
K=512;
% alpha = 0.1:0.1:0.7;
% EbN0=[2,2.25,2.5,2.75,3];
alpha=0.2:0.05:0.4;
EbN0=2;
for j=1:length(alpha)
    for k=1:length(EbN0)
        sigma=sqrt(N/(2*10^(EbN0(k)/10)*K));
        llr_file_name = sprintf('constructedCode\\EepectedLLR_block_length_%d_sigma_%.2f_method_origin_GA.txt',N,sigma);
        expectedLLR=load(llr_file_name);
        
        constructed_code_file_name = sprintf('constructedCode\\PolarCode_block_length_%d_sigma_%.2f_method_origin_GA.txt',N,sigma);
        indices = load(constructed_code_file_name);
        pp=zeros(N,1);
        pp(indices(1:K))=1;
        p=logical(pp);
        
        pathExpect=ones(N,1);
        for i=2:N
            if p(i)==1
                expandProb=qfunc((1-alpha(j))*sqrt(expectedLLR(i)/2))-qfunc((1+alpha(j))*sqrt(expectedLLR(i)/2));
                pathExpect(i)=pathExpect(i-1)*2*expandProb+pathExpect(i-1)*(1-expandProb);
            else
                pathExpect(i)=pathExpect(i-1);
            end
        end
        
        plot(1:N,pathExpect,'-');
        hold on;
    end
end

pathExpect=ones(N,1);
L=8;
for i=2:N
    if p(i)==1
        pathExpect(i)=pathExpect(i-1)*2;
        if pathExpect(i)>L
            pathExpect(i)=pathExpect(i-1);
        end
    else
        pathExpect(i)=pathExpect(i-1);
    end
end
plot(1:N,pathExpect,'-');


xlim([1 N]);
legend('\alpha=0.2','\alpha=0.25','\alpha=0.3','\alpha=0.35','\alpha=0.4','\alpha=\infty');
% legend('EbN0=1','EbN0=1.5','EbN0=2','EbN0=2.5');
xlabel('比特索引');
ylabel('路径数量');
grid on;

set(findobj(get(gca,'Children'),'LineWidth',0.5),'LineWidth',1);

end

