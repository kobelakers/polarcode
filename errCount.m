function errProb = errCount()
%
str = ['-*';'-^';'-o';'-d';'-s';'-p';'-+';'-^';'->'];
N=1024;
K=512;
alpha = 0:0.1:0.7;
EbN0=[2,2.25,2.5,2.75,3];

for m = 1:length(EbN0)
    sigma=sqrt(N/(2*10^(EbN0(m)/10)*K));
    llr_file_name = sprintf('constructedCode\\EepectedLLR_block_length_%d_sigma_%.2f_method_origin_GA.txt',N,sigma);
    expectedLLR=load(llr_file_name);
    
    constructed_code_file_name = sprintf('constructedCode\\PolarCode_block_length_%d_sigma_%.2f_method_origin_GA.txt',N,sigma);
    indices = load(constructed_code_file_name);
    pp=zeros(N,1);
    pp(indices(1:K))=1;
    p=logical(pp);
    
    indexErrProb=zeros(N,1);
    
    errProb = zeros(1,length(alpha));
    for a = 1:length(alpha)
        correctProb=1;
        for i=1:N
            if p(i)==1
                indexErrProb(i)=qfunc((1+alpha(a))*sqrt(expectedLLR(i)/2));
                correctProb=correctProb*(1-indexErrProb(i));
            end
        end
        errProb(a)=1-correctProb;
    end
    semilogy(alpha,errProb,str(m,:));
    hold on;
end
grid on;
legend("ebn0=2dB","ebn0=2.25dB","ebn0=2.5dB","ebn0=2.75dB","ebn0=3dB");
xlabel("$\alpha$",'interpreter','latex');
ylabel("$\sum_{i\in\mathcal{A}}{P(\Gamma_i|\bar{\Lambda}_i)}$",'interpreter','latex')
set(findobj(get(gca,'Children'),'LineWidth',0.5),'LineWidth',1);
