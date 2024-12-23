function P2()
    % Define the set of stencils for the GPS search
    stencils = defineStencils();

    % Initial guess 
    u0 = [0.6; 0.4; 0.7];
    
    % parameters
    alpha0 = 0.2;
    tol = 1e-6;

    % GPS for each stencil and display the results
    for i = 1:length(stencils)
        fprintf('GPS with stencil D_S%d...\n', i);
        ustar = gps(@Hartmann, u0, stencils{i}, alpha0, tol);
        fprintf('Final for D_S%d: [%f, %f, %f]\n\n', i, ustar(1), ustar(2), ustar(3));
    end
end

% stencil sets
function stencils = defineStencils()
    % Three stencil sets
    D_S1 = [0, 1, 0, -sqrt(3);
            0, 0, 1, -sqrt(3);
            1, 0, 0, -sqrt(3)];
        
    D_S2 = [0, 1, 0, 0, -1, 0;
            0, 0, 1, 0, 0, -1;
            1, 0, 0, -1, 0, 0];
        
    D_S3 = [-sqrt(3), sqrt(3), -sqrt(3), sqrt(3), -sqrt(3), sqrt(3), -sqrt(3), sqrt(3);
             sqrt(3), -sqrt(3), -sqrt(3), sqrt(3), sqrt(3), -sqrt(3), -sqrt(3), sqrt(3);
             sqrt(3), sqrt(3), sqrt(3), sqrt(3), -sqrt(3), -sqrt(3), -sqrt(3), -sqrt(3)];
    
    % Store 
    stencils = {D_S1, D_S2, D_S3};
end

% GPS 
function ustar = gps(f, u0, D, alpha0, tol)
    u = u0;
    a = alpha0;
    fmin = f(u); 
    
    % iterations
    max_iters = 100;
    
    for cnt = 1:max_iters
        unew = u;
        
        % Search 
        for i = 1:size(D, 2)
            dx = a * D(1, i);
            dy = a * D(2, i);
            dz = a * D(3, i);
            xnew = [u(1) + dx; u(2) + dy; u(3) + dz];
            fnew = f(xnew);
            
            % Update if a lower function value is found
            if fnew < fmin
                unew = u + [dx; dy; dz];
                fmin = fnew;
            end
        end
        
        % Check d
        if isequal(unew, u)
            if a < tol
                % If lower than tolerance ot converged
                ustar = unew;
                fprintf('Converged %d iterations at [%f, %f, %f]\n', cnt, ustar(1), ustar(2), ustar(3));
                return
            else
                a = a / 2;
            end
        else
            % Update the search point
            u = unew;
        end
    end
    ustar = u;
end

% Hartmann onlinev
function y = Hartmann(xx)
    % Hartmann function
    alpha = [1.0, 1.2, 3.0, 3.2]';
    A = [3.0, 10, 30;
         0.1, 10, 35;
         3.0, 10, 30;
         0.1, 10, 35];
    P = 10^(-4) * [3689, 1170, 2673;
                   4699, 4387, 7470;
                   1091, 8732, 5547;
                   381, 5743, 8828];
    
    outer = 0;
    for ii = 1:4
        inner = 0;
        for jj = 1:3
            xj = xx(jj);
            Aij = A(ii, jj);
            Pij = P(ii, jj);
            inner = inner + Aij * (xj - Pij)^2;
        end
        outer = outer + alpha(ii) * exp(-inner);
    end
    y = -outer;  
end

