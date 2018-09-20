function [alpha theta x y z fitness error_tvd]=trajGenerate(N,target_alpha,target_theta,target_tvd,LENGTH,ds,lambda,C)

alpha=zeros(1,N);
theta=zeros(1,N);
alpha(1)=pi/2;
sum=cos(theta(1))*ds;
x(1)=0;
y(1)=0;
z(1)=0;
invalid=false;
for i=2:N
    alpha(i)=(target_alpha-pi/2)*(i)*ds/LENGTH+pi/2;
    if(lambda*cos(theta(i-1))+C<0)
        invalid=true;
        break;
    end
    theta(i)=theta(i-1)+ds*sqrt(lambda*cos(theta(i-1))+C)/LENGTH;
    y(i) = y(i-1) + sin(theta(i-1))*cos(alpha(i-1))*ds;
    x(i) = x(i-1) + sin(theta(i-1))*sin(alpha(i-1))*ds;
    z(i) = z(i-1) - cos(theta(i-1))*ds;
    sum=sum+cos(theta(i))*ds;
end

error_tvd=(target_tvd/LENGTH-sum/LENGTH)^2;
error_theta=(theta(length(theta))-target_theta)^2;

if(invalid)
    fitness=inf;
end

if(invalid==false)
    fitness=error_tvd+error_theta;
end