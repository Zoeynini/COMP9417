%function [PD,ED] = yuce_day(units,accuracy)
units = 10;
accuracy=30;

A=importdata('A.mat');%���빩Ԥ������
p1=A(1:43999,1:4); %input 
%A����һ��6�У� ���̣���ߣ���ͣ����̣��ɽ������ֲ���
%����ѳɽ����ͳֲ� һ�����벨���ʻ��úܴ�
t1=A(2:44000,1); %target ѵ����ȡ�ķ�֮��
p=p1';
t=t1';
[pn,minp,maxp,tn,mint,maxt]=premnmx(p,t);%��Ҫ����ѧϰ����������һ������
%[Pn,minp,maxp,Tn,mint,maxt]=premnmx(P,T)������P��T�ֱ�Ϊԭʼ�����������ݡ�
% PN - R x Q ���� ����һ��������������. 
% minp- R x 1 ��������������P����Сֵ. 
% maxp- R x 1 ����������P�����ֵ. 
% TN - S x Q ���󣬹�һ����Ŀ������. 
% mint- S x 1 ����������ÿ��Ŀ��ֵT����Сֵ��
% maxt- S x 1 ����������ÿ��Ŀ��ֵT�����ֵ

%����BP���磬����ʼ��ѵ������
net=newff(minmax(pn),[accuracy,1],{'tansig','purelin'},'traingdm');

inputWeights=net.IW{1,1};
inputbias=net.b{1};
layerWeights=net.IW{1,1};
layerbias=net.b{2};
%������ʼ��
%InData=6;             %�����
%NeroData=10;          %������Ԫ����
%OutData=1;            %�����
LearnSpeed=0.01;      %ѧϰ�ٶ�
Display=50;           %��ʾ����
MaxTrain=50000;         %���ѵ������
Error=0.001;           %�������
Time=300;             %����ʱ(s)
ILR=10;               %ѧϰ�ٶ�������
DLR=0.1;              %ѧϰ�ٶȼ�����
MC=0.01;               %����

net.trainparam.show=Display;
net.trainparam.epochs=MaxTrain;
net.trainparam.lr=LearnSpeed;
net.trainparam.goal=Error;
net.trainParam.time=Time;
net.trainParam.lr_inc=ILR;
net.trainParam.lr_dec=DLR;
net.trainParam.mc=MC;

%����traingdmѵ�����������������ѧϰѵ��
net=train(net,pn,tn); %ѵ��֮���net



%��ʼ����
%Ԥ���44001-54001
p2=A(44000:54000,1:4); %����
p2=p2';
p2n=tramnmx(p2,minp,maxp);%��p2��һ������
a2n=sim(net,p2n);%����Ԥ�⣬
a2=postmnmx(a2n,mint,maxt);%��a2n���з���һ������
%ED=abs(a2'-A(16:2000,1));%��¼�������

t_plot=A(44001:54001,1); %target 
t_plot=t_plot';



figure(1)

plot(t_plot,'b');
hold on;
plot(a2,'r');
title('SET OF TEST');


figure(2)
title('SET OF TRAINING');
Train_out=sim(net,pn);%����Ԥ�⣬
Train_out=postmnmx(Train_out,mint,maxt);%��a2n���з���һ������
plot(t,'b');
hold on;
plot(Train_out,'r');
title('SET OF TEST');


ED= t_plot-a2;
figure(3)
plot(ED)

;
%a2     1*10001 40000:54000 �����һ��min��Ԥ��
%t_plot 1*10001 40001-54000
t_ori= A(44000:54000,1);
t_ori= t_ori'
t_diff=t_plot-t_ori;
aNt_diff=a2-t_ori;
%a2o Ԥ���44000-54000
p2o=A(43999:53999,1:4); %����
p2o=p2o';
p2no=tramnmx(p2o,minp,maxp);%��p2��һ������
a2no=sim(net,p2no);%����Ԥ�⣬
a2o=postmnmx(a2no,mint,maxt);%��a2n���з���һ������
aNa_diff=a2-a2o;
aNa_d=heaviside(aNa_diff);
%0-1
t_d=heaviside(t_diff);
aNt_d=heaviside(aNt_diff);
%final_daNt=xor(t_d,aNt_d); %0ΪԤ�ⷽ����ȷ��1Ϊ������
final_d=xor(t_d,aNa_d); %0ΪԤ�ⷽ����ȷ��1Ϊ������

figure(4)
plot(final_d);

tabulate(final_d);
% �����������Ϊ����ֻҪ���࣬�������գ�����ֻҪ�жϷ��򣬲���Ҫ֪������Ĵ�С
%  Value    Count   Percent
%      0     7784     77.83%
%      1     2217     22.17%

