%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% demo 1.  Hello Voronoi
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% demo 描述:
%   用二维矩阵表示的二维栅格图来为二维平面建模，并在其上随机散布种子
%   进行Voronoi区域划分并染色
%
% 算法思路：
%   对二维栅格进行遍历，计算每一个单元格距离哪一个种子最近，
%   并将所有属于同一个的种子的单元格染上相同的颜色
%
% 算法复杂度评价：
%   最好O(n^2)，最坏O(n^4) 其中n为栅格地图的尺寸，n*n
%   最好情况对应种子稀疏分布
%   最坏情况对应种子密集分布
%
% 算法应用：
%   只是一个可视化
%
% TODO：
%   seed 增粗中存在的索引访问错误
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc;
clear;
close all;

%##################################
%                             初始化
%##################################
%% 定义2维环境参数
height       = 20;
width        = 20;
resolution   = 0.2;

%% 构建栅格地图场景
rows         = height / resolution;  % 行数
cols         = width / resolution;  % 列数

% 定义栅格地图全域，并初始化空白区域, 因为数字全部都是1（我们定义了白色表示空地）
field        = ones(rows,cols);

%% 随机播撒种子
num_seeds    = 40;
seeds        = zeros(num_seeds,2);

for i = 1:num_seeds
    seed_position = [floor(rows*rand(1)) + 1,floor(cols*rand(1)) + 1];
    
    seeds(i,:) = seed_position;
end

%% 对seed point所在处进行标记，使其在显示时呈黑色
if(rows > 500 || cols > 500) 
    % 地图比较大，有可能一个像素的黑点看不到，则进行加粗处理
    % bug: seeds(i,1),seeds(i,2) 有可能是 1,这里会出现访问索引错误
    for i = 1:num_seeds
        field(seeds(i,1) - 1, seeds(i,2) - 1) = num_seeds + 1;
        field(seeds(i,1) - 1, seeds(i,2)    ) = num_seeds + 1;
        field(seeds(i,1) - 1, seeds(i,2) + 1) = num_seeds + 1;

        field(seeds(i,1)    , seeds(i,2) - 1) = num_seeds + 1;
        field(seeds(i,1)    , seeds(i,2)    ) = num_seeds + 1;
        field(seeds(i,1)    , seeds(i,2) + 1) = num_seeds + 1;

        field(seeds(i,1) + 1, seeds(i,2) - 1) = num_seeds + 1;
        field(seeds(i,1) + 1, seeds(i,2)    ) = num_seeds + 1;
        field(seeds(i,1) + 1, seeds(i,2) + 1) = num_seeds + 1;
    end
else
    for i = 1:num_seeds
        field(seeds(i,1)    , seeds(i,2)    ) = num_seeds + 1;
    end
end


%##################################
%                    Voronoi分区计算
%##################################
for i = 1:rows
    for j = 1:cols

        if(field(i,j) == num_seeds + 1)
            continue;
        end

        min_dist = inf;
        closest_seed = inf;


        for k = 1:length(seeds(:,1))
            dist = (i - seeds(k,1))^2 + (j - seeds(k,2))^2;

            if(dist < min_dist)
                min_dist = dist;
                closest_seed = k;
            end

        end

        field(i,j) = closest_seed;

    end
end

%##################################
%                      栅格地图可视化
%##################################
% 构建颜色映射图
% 构建地图的过程中需要多少中颜色就定义多少行
cmap = generate_random_colormap(num_seeds + 1);
colormap(cmap);

% 显示二维矩阵
image(field);

axis equal; 
axis tight; 
axis off; 



