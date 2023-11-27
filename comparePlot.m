scl2=xlsread('scldata.xlsx','all','E5:I5');
scl4=xlsread('scldata.xlsx','all','E10:I10');
scl8=xlsread('scldata.xlsx','all','E15:I15');

newscl1=xlsread('scldata.xlsx','all','l5:p5');
newscl2=xlsread('scldata.xlsx','all','l10:p10');
newscl3=xlsread('scldata.xlsx','all','l15:p15');
newscl45=xlsread('scldata.xlsx','all','l20:p20');

newscl3_4=xlsread('scldata.xlsx','all','s16:w16');
newscl45_4=xlsread('scldata.xlsx','all','s21:w21');

cascl=[498/1643,499/9594,125/50000,2/50000];

str0 = ['--*';'--^';'--o'];
str=['-+';'-d';'-s';'-p';':^';'->'];
% semilogy(1:0.5:3,scl2,str0(1,:));
% hold on;
semilogy(1:0.5:3,scl4,str0(2,:));
hold on;
semilogy(1:0.5:3,scl8,str0(3,:));
hold on;
semilogy(1:0.5:2.5,cascl,str0(1,:));
hold on;
% semilogy(1:0.5:3,newscl1,str(1,:));
% hold on;
semilogy(1:0.5:3,newscl2,str(2,:));
hold on;
semilogy(1:0.5:3,newscl3,str(3,:));
hold on;
semilogy(1:0.5:3,newscl45,str(4,:));
hold on;
% 
semilogy(1:0.5:3,newscl3_4,str(5,:));
hold on;
% semilogy(1:0.5:3,newscl45_4,str(6,:));
% hold on;

legend('scl4','scl8','newscl2','newscl3','newscl45','newscl3-4');
legend('SCL(L=4)','SCL(L=8)','CA-SCL(L=8)','PE-SCL(\alpha=0.2)','PE-SCL(\alpha=0.3)','PE-SCL(\alpha=0.45)','PE-SCP-SCL(\alpha=0.3,|C|=4)');
set(findobj(get(gca,'Children'),'LineWidth',0.5),'LineWidth',1);
xlabel('Eb/N0(dB)');
ylabel('ÎóÖ¡ÂÊ');
% legend('scl2','scl4','scl8','newscl2','newscl3','newscl45','newscl3-4');
% legend('scl2','scl4','scl8','newscl1','newscl2','newscl3','newscl45','newscl3-4','newscl45-4');
grid on;