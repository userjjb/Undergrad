clc
clear all
close all

%Variable values
M=1;
K=10000;
C=10;

F=1;

MMatrix=    [2*M    0;
            0       4*M];
        
KMatrix=    [2*K    -K;
            -K      2*K];
        
CMatrix=    [2*C    -C;
            -C      2*C];

[Shape,Freq]=eig(KMatrix,MMatrix);
ModalF = Shape'*[0;F];

w1=Freq(1,1)^(1/2);
w2=Freq(2,2)^(1/2);

x0=[0;0];
v0=[0;0];
n=20001;
dt=0.0001;

iter=0;
u=zeros(2,n);
for t=0:dt:2
    iter=iter+1;
    u(:,iter)=sin(0.5*(w1+w2)*t);
end

u(1,:)=u(1,:)*ModalF(1);
u(2,:)=u(2,:)*ModalF(2);
        
[x,xd]=vtb1_4(n,dt,x0,v0,MMatrix,CMatrix,KMatrix,u);
plot(0:dt:2+dt,x(1,:))
figure
plot(0:dt:2+dt,x(2,:))