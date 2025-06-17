function custom_colormap = generate_random_colormap(n)
    % 参数：
    % n：需要生成的颜色数量（包括黑色）

    % 初始化颜色映射矩阵
    custom_colormap = zeros(n, 3);

    % 生成 n-1 个随机颜色
    for i = 1:(n-1)
        % 生成一个随机颜色
        color = rand(1, 3);

        % 确保颜色不是黑色
        while all(color < 0.1) % 如果颜色接近黑色，则重新生成
            color = rand(1, 3);
        end

        % 将生成的颜色添加到颜色映射矩阵中
        custom_colormap(i, :) = color;
    end

    % 确保所有颜色都是唯一的
    [~, idx] = unique(custom_colormap(1:n-1, :), 'rows');
    while length(idx) < n-1
        % 如果有重复的颜色，重新生成缺失的颜色
        for i = 1:(n-1)
            if ~ismember(i, idx)
                color = rand(1, 3);
                while all(color < 0.1) % 确保颜色不是黑色
                    color = rand(1, 3);
                end
                custom_colormap(i, :) = color;
            end
        end
        [~, idx] = unique(custom_colormap(1:n-1, :), 'rows');
    end

    % 添加黑色到颜色映射的末尾
    custom_colormap(n, :) = [0, 0, 0];
end