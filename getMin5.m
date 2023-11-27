function average_of_top5 = getMin5(BERs)
sorted_BERs = sort(BERs);          % 对BERs进行排序
top5_min_values = sorted_BERs(1:5); % 取排序后的前五个值
average_of_top5 = mean(top5_min_values);  % 计算这五个值的平均值
end