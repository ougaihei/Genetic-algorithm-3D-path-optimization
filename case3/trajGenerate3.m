function [alpha theta x y z fitness]=trajGenerate3(lambda1,lambda2,lambda3,lambda4)
ds=1;
dds=lambda4;
sb=1000;
xb=1400;
yb=1400;
zb=2000;
epsilon=(ds/sb)/2;
theta(1)=0;
alpha(1)=pi/2;
alpha(2)=alpha(1)-(ds/sb)*epsilon;
theta(2)=theta(1)+(ds/sb)*epsilon;
sumz=0;
sumx=0;
sumy=0;
x(1)=0;
y(1)=0;
z(1)=0;
tol=0.0001;
i=2;
invalid=false;
while(abs(theta(length(theta))-pi/2)>tol && alpha(length(alpha))-0>tol)
    theta(i+1)=2*theta(i)-theta(i-1)+(ds/sb)^2/2*(-lambda1*sin(theta(i))+lambda2*cos(theta(i))*sin(alpha(i))+lambda3*cos(theta(i))*cos(alpha(i)));
    alpha(i+1)=2*alpha(i)-alpha(i-1)+(ds/sb)^2/2*(lambda2*sin(theta(i))*cos(alpha(i))-lambda3*sin(theta(i))*sin(alpha(i)));
    
    if(theta(i+1)<=theta(i) || alpha(i+1)>=alpha(i))
    %    if(alpha(i+1)>=alpha(i))
            
       % invalid=true;
        break;
    end
    i=i+1;
end
count=i;
for i=2:count
    y(i) = y(i-1) + sin(theta(i-1))*cos(alpha(i-1))*dds;
    x(i) = x(i-1) + sin(theta(i-1))*sin(alpha(i-1))*dds;
    z(i) = z(i-1) - cos(theta(i-1))*dds; 
    sumz=sumz+cos(theta(i-1))*dds;
    sumy=sumy+sin(theta(i-1))*cos(alpha(i-1))*dds;
    sumx=sumx+sin(theta(i-1))*sin(alpha(i-1))*dds;
end
L=count*dds;
errorz=(1-sumz/zb)^2;
errorx=(1-sumx/xb)^2;
errory=(1-sumy/yb)^2;
error_theta=(theta(length(theta))-pi/2)^2;
error_alpha=(alpha(length(alpha))-0)^2;

if(invalid)
    fitness=inf;
else
fitness=errorx+errorz+errory+error_alpha+error_theta;
end
