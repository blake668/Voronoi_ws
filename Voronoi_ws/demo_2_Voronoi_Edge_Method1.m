%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% demo 2.  Voronoi edge calculate - grid method
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% demo 描述:
%   基于demo1构建的栅格地图及Voronoi分区，对每个分区的边缘进行标记并染色
%   
% 算法思路：
%   在demo1的遍历法构建Voronoi分区的基础上:
%   再次遍历栅格地图，进行9宫格滤波，
%   如果9宫格内存在不一样的分区信息，则可认为此栅格位于两个分区的交界处
%
% 算法复杂度评价：
%   最好O(n^2)，最坏O(n^4) 其中n为栅格地图的尺寸，n*n
%   最好情况对应种子稀疏分布
%   最坏情况对应种子密集分布
%
% 算法应用：
%   对于机器人导航来说，Voronoi的区域边缘是最安全的通行区域
%   而如果seeds是零散分布的城市，沿着Voronoi边缘来铺设轨道，是一个比较优的解法
%
% TODO：
%   
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc;
clear;
close all;

%##################################
%                             初始化
%##################################
%% 定义2维环境参数
height       = 200;
width        = 200;
resolution   = 0.2;

%% 构建栅格地图场景
rows         = height / resolution;  % 行数
cols         = width / resolution;  % 列数

% 定义栅格地图全域，并初始化空白区域, 因为数字全部都是1（我们定义了白色表示空地）
field        = ones(rows,cols);

%% 随机播撒种子
num_seeds    = 20;
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
%                    Voronoi边缘计算
%##################################
for i = 1:rows
    for j = 1:cols
        center_value = field(i,j);

        if(center_value == num_seeds + 1)
            continue;
        end

        value_upleft    = get_value_invalid_cover(field, i - 1, j - 1, num_seeds + 1);
        value_up        = get_value_invalid_cover(field, i - 1, j    , num_seeds + 1);
        value_upright   = get_value_invalid_cover(field, i - 1, j + 1, num_seeds + 1);
        value_left      = get_value_invalid_cover(field, i    , j - 1, num_seeds + 1);
        value_right     = get_value_invalid_cover(field, i    , j + 1, num_seeds + 1);
        value_downleft  = get_value_invalid_cover(field, i + 1, j - 1, num_seeds + 1);
        value_down      = get_value_invalid_cover(field, i + 1, j    , num_seeds + 1);
        value_downright = get_value_invalid_cover(field, i + 1, j + 1, num_seeds + 1);

        if( ((value_upleft    ~= num_seeds + 1) && (value_upleft    ~= center_value)) || ...
            ((value_up        ~= num_seeds + 1) && (value_up        ~= center_value)) || ...
            ((value_upright   ~= num_seeds + 1) && (value_upright   ~= center_value)) || ...
            ((value_left      ~= num_seeds + 1) && (value_left      ~= center_value)) || ...
            ((value_right     ~= num_seeds + 1) && (value_right     ~= center_value)) || ...
            ((value_downleft  ~= num_seeds + 1) && (value_downleft  ~= center_value)) || ...
            ((value_down      ~= num_seeds + 1) && (value_down      ~= center_value)) || ...
            ((value_downright ~= num_seeds + 1) && (value_downright ~= center_value)) )
            field(i,j) = num_seeds + 1;
        end

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



