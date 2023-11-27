function initialize_origin_phi()

persistent phi_initialized;
global minus_log_phi_inv_table;
global min_phi;
global max_phi;
global increment_minus_log_phi;
global phi_x_table;
global min_x;
global max_x;
global increment_x;

if isempty(phi_initialized)
    phi_initialized = 1;
    min_x = 0;
    max_x = 100;
    increment_x = 0.01;
    index = 1;
    for x = min_x: increment_x: max_x + increment_x
        if (x < 7.0633)
            phi_x_table(index) = exp(0.0116*x.^2-0.4212*x);
        else
            phi_x_table(index) = exp(-0.2944*x-0.3169);
        end
        index = index + 1;
    end
    
    if nargin < 1
        x_increment = 10^(-4);
    end
    x_vec = 0: x_increment: 400;
    
    phi_vec = (x_vec <  7.0633) .* exp(0.0116*x_vec.^2-0.4212*x_vec);
    phi_vec = (x_vec >= 7.0633) .* exp(-0.2944*x_vec-0.3169) + phi_vec;
    phi_vec = min(phi_vec, 1);
    min_phi = 5.2463e-52;
    max_phi = 1;
    increment_minus_log_phi = 10^(-3);
    minus_log_phi_inv_table = zeros(ceil((max_minus_log_phi - min_minus_log_phi)/increment_minus_log_phi) + 1, 1);
    for x_index = 1 : length(x_vec)
        x_value  = x_vec(x_index);
        phi_value = phi_vec(x_index);
        minus_log_phi = -log(phi_value);
        if minus_log_phi < max_minus_log_phi + increment_minus_log_phi
            minus_log_phi_index = ceil((minus_log_phi - min_minus_log_phi)/increment_minus_log_phi) + 1;
            minus_log_phi_inv_table(minus_log_phi_index) = x_value;
        end
    end
    
end


end

