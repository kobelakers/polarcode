scl8=xlsread('scldata.xlsx','2.5db','a3:a1026');
scl4=xlsread('scldata.xlsx','2.5db','h3:h1026');

new1=xlsread('scldata.xlsx','2.5db','b3:b1026');
new2=xlsread('scldata.xlsx','2.5db','c3:c1026');
new3=xlsread('scldata.xlsx','2.5db','d3:d1026');
new4=xlsread('scldata.xlsx','2.5db','e3:e1026');


plot([1:1024],new1,'-');
hold on;
plot([1:1024],new2,'-');
hold on;
plot([1:1024],new3,'-');
hold on;
plot([1:1024],new4,'-');
hold on;
plot([1:1024],scl4,'-');
hold on;
plot([1:1024],scl8,'-');
hold on;

% legend('newscl1','newscl2','newscl3','newscl45','scl4','scl8');
legend('PE-SCL(\alpha=0.1)','PE-SCL(\alpha=0.2)','PE-SCL(\alpha=0.3)','PE-SCL(\alpha=0.45)','SCL(L=4)','SCL(L=8)');
set(findobj(get(gca,'Children'),'LineWidth',0.5),'LineWidth',1);
xlabel('比特索引');
ylabel('平均路径数');
xlim([1 1024]);
grid on;