function m = phi_test( x )
m=zeros(1,length(x));
for i=1:length(x)
    if x(i)<7.0633
        m(i)=exp(0.0116*x(i)*x(i)-0.4212*x(i));
    else
        m(i)=exp(-0.2944*x(i)-0.3169);
    end
end