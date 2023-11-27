function construct_origin_GA(N,sigma)
%采用GA算法构建极化码，不用log
    n = ceil(log2(N)); 
    NN = 2^n;
    if(NN~=N)
        fprintf('The num N must be the power of 2!');
        return;
    end
    
    
    bitreversedindices = zeros(1,N);
    for index = 1 : N
        bitreversedindices(index) = bin2dec(wrev(dec2bin(index-1,n)));
    end
    
    mean_llr = 2/sigma^2;
    channels = mean_llr*ones(1, N);
    
    for i=1:n
        c1 = channels(1:2:N);
        c2 = channels(2:2:N);
%         channels = [c1.*c1, c1+c2 - c1.*c2];
        channels = [inv_phi_test(1 - (1 - sym(phi_test(c1))).*(1 - sym(phi_test(c2)))), c1 + c2]; %蝶形图式递推，brilliant
    end
    channels = channels(bitreversedindices+1);
    
    indexErrProbs = qfunc(sqrt(abs(channels)/2));
%     annotherChannels = log2((1-annother)./annother);
    indexErrProbs_file_name = sprintf('indexErrProbs_%d_sigma_%.2f_method_origin_GA.txt',N,sigma);
    indexErrProbs_fid = fopen(indexErrProbs_file_name,'w+');
    for ii = 1:length(indexErrProbs)
        if indexErrProbs(ii)==inf
            fprintf(indexErrProbs_fid,'%d\r\n',1000);
        else
            fprintf(indexErrProbs_fid,'%d\r\n',indexErrProbs(ii));
        end
    end
    fclose(indexErrProbs_fid);
    
    
    llr_file_name = sprintf('EepectedLLR_block_length_%d_sigma_%.2f_method_origin_GA.txt',N,sigma);
    llr_fid = fopen(llr_file_name,'w+');
    for ii = 1:length(channels)
        if channels(ii)==inf
            fprintf(llr_fid,'%d\r\n',1000);
        else
            fprintf(llr_fid,'%d\r\n',channels(ii));
        end
    end
    fclose(llr_fid);

    file_name = sprintf('PolarCode_block_length_%d_sigma_%.2f_method_origin_GA.txt',N,sigma);
    fid = fopen(file_name,'w+');
    [~,indices] = sort(channels,'descend');
    for ii = 1:length(channels)
        fprintf(fid,'%d\r\n',indices(ii));
    end
    fclose(fid);

end

