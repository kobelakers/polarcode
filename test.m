alpha=0.1:0.2:1;
for j=1:length(alpha)
    u=0.0001:0.5:50;
    fx=zeros(1,length(u));
    for i=1:length(u)
        fx(i)=qfunc(sqrt(u(i)/2))-qfunc((1+alpha(j))*sqrt(u(i)/2));
    end
    semilogy(u,fx,'-');
    hold on;
end
legend('\alpha=0.1','\alpha=0.3','\alpha=0.5','\alpha=0.7','\alpha=1.0');
ylabel('第i层上正确路径被剪枝的概率');
xlabel('第i层对数似然比')
grid on;
set(findobj(get(gca,'Children'),'LineWidth',0.5),'LineWidth',1);