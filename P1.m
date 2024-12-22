
% ARWHEAD minimization 

function P1()

    % function
    function fx = f(x)
        fx = (x(1)^2 + x(2)^2)^2 - 4 * x(1) + 3;
    end

    % Test
    function test_nelder_mead()
        % Starting points
        start_points = [randn(2,1) * 3; randn(2,1) * 2];  
        start = start_points(:, randi(size(start_points, 2)));  
        fprintf('Start point is [%f, %f]\n', start(1), start(2));

        % find the minimum
        [xend, fval] = fminsearch(@f, start);
        fprintf('Converged minimum at [%f, %f].\n', xend(1), xend(2));
        fprintf('Minimum function value: %f\n', fval);

        % Plot (I had chatgpt help me with plooting syntax)
        N = 100;
        [Xm, Ym] = meshgrid(linspace(-5, 5, N));  
        Zm = (Xm.^2 + Ym.^2).^2 - 4 * Xm + 3;     
        contour(Xm, Ym, Zm, 25, 'LineWidth', 1.5) 
        hold on
        xlabel('x', 'FontSize', 12)
        ylabel('y', 'FontSize', 12)
        title('ARWHEAD Function Minimization', 'FontSize', 14)
        plot(xend(1), xend(2), 'ks', 'MarkerFaceColor', 'g', 'MarkerSize', 10);  
        plot(start(1), start(2), 'md', 'MarkerFaceColor', 'r', 'MarkerSize', 8);  
        text(xend(1), xend(2), 'Min', 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right');
        text(start(1), start(2), 'Start', 'VerticalAlignment', 'top', 'HorizontalAlignment', 'right');
        legend('Function Contours', 'Minimum', 'Start Point', 'Location', 'northwest')

        % Grid points around the minimum
        epsilon = 1e-2;  
        grid_spacing = linspace(-epsilon, epsilon, 10);  
        success = 0;
        fail = 0;
        fend = f(xend);
        for dx = grid_spacing
            for dy = grid_spacing
                test_point = xend + [dx, dy];  
                test_value = f(test_point);
                
                % Check if function value is higher at the test point
                if test_value > fend
                    success = success + 1;
                else
                    fail = fail + 1;
                end
            end
        end
        fprintf('Systematic grid test woked %d times and didnwork %d times\n', success, fail);
    end

    % test
    test_nelder_mead();
end
