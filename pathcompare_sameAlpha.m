% scl8=xlsread('scldata.xlsx','2.5db','a3:a1026');
% scl4=xlsread('scldata.xlsx','2.5db','h3:h1026');
%

%alpha=0.3
snr1=xlsread('scldata.xlsx','1db','t3:t1026');
snr1_5=xlsread('scldata.xlsx','1.5db','d3:d1026');
snr2=xlsread('scldata.xlsx','2db','f3:f1026');
snr2_5=xlsread('scldata.xlsx','2.5db','d3:d1026');
snr3=xlsread('scldata.xlsx','3db','d3:d1026');

pruned_snr1=xlsread('scldata.xlsx','1db','s3:s1026');
pruned_snr1_5=xlsread('scldata.xlsx','1.5db','t3:t1026');
pruned_snr2=xlsread('scldata.xlsx','2db','q3:q1026');
pruned_snr2_5=xlsread('scldata.xlsx','2.5db','v3:v1026');
pruned_snr3=xlsread('scldata.xlsx','3db','t3:t1026');

plot([1:1024],snr1,'-');
hold on;
plot([1:1024],snr1_5,'-');
hold on;
plot([1:1024],snr2,'-');
hold on;
plot([1:1024],snr2_5,'-');
hold on;
plot([1:1024],snr3,'-');
hold on;

plot([1:1024],pruned_snr1,'--');
hold on;
plot([1:1024],pruned_snr1_5,'--');
hold on;
plot([1:1024],pruned_snr2,'--');
hold on;
plot([1:1024],pruned_snr2_5,'--');
hold on;
plot([1:1024],pruned_snr3,'--');
hold on;

% legend('ebn0=1dB','ebn0=1.5dB','ebn0=2dB','ebn0=2.5dB','ebn0=3dB','(pruned)ebn0=1dB','(pruned)ebn0=1.5dB','(pruned)ebn0=2dB','(pruned)ebn0=2.5dB','(pruned)ebn0=3dB');
legend('PE-SCL(1dB)','PE-SCL(1.5dB)','PE-SCL(2dB)','PE-SCL(2.5dB)','PE-SCP-SCL(3dB)','PE-SCP-SCL(1dB)','PE-SCP-SCL(1.5dB)','PE-SCP-SCL(2dB)','PE-SCP-SCL(2.5dB)','PE-SCP-SCL(3dB)');
set(findobj(get(gca,'Children'),'LineWidth',0.5),'LineWidth',1);
xlabel('比特索引');
ylabel('平均路径数');
xlim([1 1024]);
grid on;