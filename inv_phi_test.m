function x = inv_phi_test( y )
x=zeros(1,length(y));
for i=1:length(y)
    if y(i)<0.0911
        x(i)=-(log(y(i))+0.3169)/0.2944;
    else
        x(i)=(0.4212-sqrt(0.4212*0.4212+4*0.0116*log(y(i))))/(2*0.0116);
    end
    if x(i)==inf
       y(i) 
    end
end

