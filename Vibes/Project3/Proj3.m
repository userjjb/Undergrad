%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Josh Bevan 2013
%22.520 Vibrations
%
%Small script that solves for mode shapes and freqs of MDOF system
%The equations of motion are decoupled by transforming to modal space.
%The resultant system is created from the linear superposition of each SDOF
%mode shape and it's time-variant response.
%
%The displacement is plotted for each DOF, and compared to similiar data
%gathered from a SIMULINK model

clc
close all
%clear all

%Variable values
M=1;
K=10000;
C=10;

F=1;

%Initial matrices
MMatrix=    [2*M    0;
            0       4*M];
        
KMatrix=    [2*K    -K;
            -K      2*K];
        
CMatrix=    [2*C    -C;
            -C      2*C];

%Solve for mode shapes and natural freqs
[Shape,Freq]=eig(KMatrix,MMatrix);

w1=Freq(1,1)^(1/2);
w2=Freq(2,2)^(1/2);

%Transform to modal space
ModalM = Shape'*MMatrix*Shape;
ModalK = Shape'*KMatrix*Shape;
ModalC = Shape'*CMatrix*Shape;
ModalF = Shape'*[0;F];

%Setup desired time step and size of time-variant response matrix
timestep=0.0001;
t=0:timestep:.5;
TotResponse=zeros(2,size(t,2));
sol=zeros(size(t,2),1);
for i=1:2
    %Use symbolic solver to solve each now decoupled SDOF modal system
    eqn=dsolve('(ModalMi*D2p)+(ModalCi*Dp)+(ModalKi*p)=ModalFi*sin(0.5*(w1+w2)*t)', 'p(0)=0','Dp(0)=0');
    %Calculate numeric value of symbolic variables and substitute to calc actual value
    ModalMi= ModalM(i,i);
    ModalKi= ModalK(i,i);
    ModalCi= ModalC(i,i);
    ModalFi=-ModalF(i);
    sol(:,i)=subs(eqn);
    %Total response is the linear superposition of each modal response sigma{ u_i*p(t) } for all i
    TotResponse=TotResponse+Shape(:,i)*sol(:,i)';
end

hold on
%plot(t,TotResponse(1,:),'Color','red')
plot(t,-Mass1.signals.values,'-r')
title('1')
%plot(t,TotResponse(2,:),'Color','red')
plot(t,-Mass2.signals.values,'-b')
title('2')
figure
temp=Mass1.signals.values./Mass2.signals.values;
avg=mean2(min(-2.72,max(-2.75,temp)))
plot(t,temp)

