clear all
clc
clf
%
% BP_SMALL ��LARGE����һ���㷨��û��MATLAB��NN TOOLs
% ���Ե�ʱ���ȿ�SMALL��LARGEҪ�ܰ��Сʱ
%


%��������BP����ṹ
%�������Ԫ��Ϊ5����������Ԫ��Ϊ3���������Ԫ��Ϊ1

%����������
maxcishu=100000;

%eΪ�������������ʵ�������
%���ڴ��п���maxcishu���洢�ռ�
e=zeros(maxcishu,1);

% ��������ά��5������ڵ���5
% maxp������߼�����
% minp������ͼ�����
% sp���տ��̼�
% ep�������̼�
% tnum���ճɽ���
% ��������
%shuju=xlsread('dm.xlsx', 'B1:K151');

shuju=importdata('BP_SMALL.xlsx');
sp=shuju.data(:,1)';
maxp=shuju.data(:,2)';
minp=shuju.data(:,3)';
tnum=shuju.data(:,10)';
ep=shuju.data(:,4)';

%
%shuju=importdata('300.xls');
%sp=shuju.data(:,0)';% sp���տ��̼�
%maxp=shuju.data(:,1)';
%minp=shuju.data(:,2)';
%tnum=shuju.data(:,4)';
%ep=shuju.data(:,5)';% ep�������̼�

%�����ݼ�����2:1��Ϊѵ�����������Ͳ���������
jishulength=length(ep);
jishu=ceil(jishulength/3*2) ;

%������������2/3�������һ��
spt=sp(jishu+1:end);
maxpt=maxp(jishu+1:end);
minpt=minp(jishu+1:end);
tnumt=tnum(jishu+1:end);
ept=ep(jishu+1:end);

%ѵ��������
sp=sp(1:jishu);
maxp=maxp(1:jishu);
minp=minp(1:jishu);
tnum=tnum(1:jishu);
ep=ep(1:jishu);

%��¼��ÿ������ֵ��Сֵ��Ϊѵ���������Ĺ�һ��׼��
maxp_max=max(maxp);
maxp_min=min(maxp);
minp_max=max(minp);
minp_min=min(minp);
ep_max=max(ep);
ep_min=min(ep);
sp_max=max(sp);
sp_min=min(sp);
tnum_max=max(tnum);
tnum_min=min(tnum);

% Ŀ������Ϊ���յ����̼ۣ��൱�ڰѵ������̼�ʱ��������ǰŲ��һ����λ
goalp=ep(2:jishu);

%���ݹ�һ��,���������ݹ�һ����(0 1)
guiyi=@(A)((A-min(A))/(max(A)-min(A)));
maxp=guiyi(maxp);
minp=guiyi(minp);
sp=guiyi(sp);
ep=guiyi(ep);
tnum=guiyi(tnum);

% �����Ŀ������goalp������ep��ǰ�ƶ�һλ�õ����������һ���Ŀ������ȱʧ
% ���ԣ�Ҫ�ѳ���Ŀ������goalp�����������������ɾ�����һ��
maxp=maxp(1:jishu-1);
minp=minp(1:jishu-1);
sp=sp(1:jishu-1);
ep=ep(1:jishu-1);
tnum=tnum(1:jishu-1);

%��Ҫѭ��ѧϰ����loopn����ѵ�������ĸ���
loopn=length(maxp);
%Ϊ�˷����ʾ��5���������ŵ�һ��5*loopn�ľ�����simp��,ÿһ����һ����������
simp=[maxp;minp;sp;ep;tnum];

%������ڵ�n
%����������ϣ�������ڵ���������ڵ����٣�һ��ȡ1/2����ڵ���
bn=3;

%�����㼤���ΪS�ͺ���
jihuo=@(x)(1/(1+exp(-x)));

%bx�������������ÿ���ڵ�����
%bxe��������bx����S���������ֵ��������������
bx=zeros(bn,1);
bxe=zeros(bn,1);

%Ȩֵѧϰ��u
u=0.02;

%W1(m,n)��ʾ�������m����Ԫ�ڵ�ĵ�n��������ֵ��Ȩ�أ�
%����ÿһ�ж�Ӧһ���ڵ�
%��������㵽�������ȨֵW1����һ��bn*5�ľ��󣬳�ֵ�������
W1=rand(bn,5);

%W2(m)��ʾ����ڵ��m������ĳ�ʼȨֵ�������������
W2=rand(1,bn);

%loopn��ѵ����������Ӧloopn�����
out=zeros(loopn,1);

for k=1:1:maxcishu
    
    %ѵ����ʼ,i��ʾΪ����������ǵ�i����������
    for i=1:1:loopn
        
        %���в�ÿ���ڵ�bx(n)�������ϵ����Ӧ����W1�ĵ�n��
        for j=1:1:bn
            bx(j)=W1(j,:)*simp(:,i);
            bxe(j)=jihuo(bx(j));
        end
        
        %�����
        out(i)=W2*bxe;
        
        %���򴫲�����
        %��������ڵ������Ȩֵ������,�������������AW2��
        %�����Ԫ����� f(x)=x
        %Ϊ����д���㣬��deta��A����
        AW2=zeros(1,bn);
        AW2=u*(out(i)-goalp(i))*bxe';
        
        %����������ڵ������Ȩֵ������,�������������AW1��,��Ҫ��������ڵ��������
        AW1=zeros(bn,5);
        for j=1:1:bn
            AW1(j,:)=u* (out(i)-goalp(i))*W2(j)*bxe(j)*(1-bxe(j))*simp(:,i)';
        end
        W1=W1-AW1;
        W2=W2-AW2;
    end
    
    %��������ƫ��
    e(k)=sum((out-goalp').^2)/2/loopn;
    %����趨
    if e(k)<=0.001
        disp('��������')
        disp(k)
        disp('ѵ�����������')
        disp(e(k))
        break
    end
end

%��ʾѵ���õ�Ȩֵ
W1
W2
%��������������ߣ�ֱ��չʾ��������
figure(1)
hold on
e=e(1:k);
plot(e)
title('ѵ���������������')
% ���������ʵ������Ա�ͼ
figure(2)
plot(out,'rp')
hold on
plot(goalp,'bo')
title('ѵ�����������������ʵ������Ա�')

%ѧϰѵ�����̽���

%���в��������׶�,������ĩβ��t����ѵ������
maxpt=(maxpt-maxp_min)/(maxp_max-maxp_min);
minpt=(minpt-minp_min)/(minp_max-minp_min);
spt=(spt-sp_min)/(sp_max-sp_min);
eptduibi=ept(2:end);
ept=(ept-ep_min)/(ep_max-ep_min);
tnumt=(tnumt-tnum_min)/(tnum_max-tnum_min);

% ͬ��������ά���ݷ���һ�������У����ڴ���
simpt=[maxpt;minpt;spt;ept;tnumt];

%��Ϊ���õ�ǰ������Ԥ����һ��ģ����Լ���������һ������̼ۺ�Ԥ������һ������̼���Ϊû�бȶ�ֵ������
for i=1:1:length(maxpt)-1
    for j=1:1:bn
        bx(j)=W1(j,:)*simpt(:,i);
        bxe(j)=jihuo(bx(j));
    end
    
    %���Ԥ������
    outt(i)=W2*bxe;
end

%Ԥ�������ʵ�ʶԱ�ɢ��ͼ
figure(3)
hold on
plot(outt,'rp')
plot(eptduibi,'bo')
title('����������Ԥ�������ʵ�ʶԱ�')

%����ȫ�����
disp('�������������')
disp(1/length(eptduibi)*0.5*sum((eptduibi-outt).^2))

