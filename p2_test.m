function p2()

    % B matrix
    function B = B_matrix(x, b)
        b1 = b(1);
        b2 = b(2);
        N = length(x);

        J = zeros(N, 2);
        for n = 1:N
            x_n = x(n);
            J(n, 1) = 1 - cos(b2 * x_n);
            J(n, 2) = b1 * x_n * sin(b2 * x_n);
        end
        B = 2 * (J') * J;
    end

    % f(x, b)
    function fx = f(x, b)
        b1 = b(1);
        b2 = b(2);
        fx = b1 * (1 - cos(b2 * x));
    end

    % H matrix (Hessian)
    function H = H_matrix(x, y, b)
        b1 = b(1);
        b2 = b(2);
        N = length(x);

        H11 = 0; H12 = 0; H21 = 0; H22 = 0;
        for n = 1:N
            x_n = x(n);
            y_n = y(n);
            H11 = H11 + 2 * (1 - cos(b2 * x_n))^2;
            H12 = H12 + 4 * x_n * b1 * sin(b2 * x_n) * (1 - cos(b2 * x_n)) - 2 * y_n * x_n * sin(b2 * x_n);
            H21 = H21 + 2 * x_n * sin(b2 * x_n) * (2 * b1 * (1 - cos(b2 * x_n)) - y_n);
            H22 = H22 + 2 * b1^2 * x_n^2 * sin(b2 * x_n)^2;
        end
        H = [H11, H12; H21, H22];
    end

    % Norm differences for different noise amplitudes
    function norm_diff = calculate_norm_diff(amp, N, b)
        x = linspace(-1.5, 1.5, N)';
        y = f(x, b) + amp * (randn(N, 1) - 0.5);
        H = H_matrix(x, y, b);
        B = B_matrix(x, b);
        diff = H - B;
        norm_diff = norm(diff);
    end

    % Run ecperiment and plot results
    function run_noise_experiment()
        N = 100;
        b = randn(1, 2);
        noise_amplitudes = logspace(log10(1e-5), log10(3e-1), 10);
        norm_diffs = arrayfun(@(amp) calculate_norm_diff(amp, N, b), noise_amplitudes);
        figure;
        loglog(noise_amplitudes, norm_diffs, 'ro', 'MarkerFaceColor', 'r');
        xlabel('Noise');
        ylabel('Norm Diff');
        title('Norm Diff vs. Noise');
    end

    
    run_noise_experiment();

end

