% 基于 MODIS 离水反射率数据开展 Nicaragua 湖叶绿素浓度反演研究
% 2021-11-9
clear;clc;
%% 读取数据
filename = 'A2017050191000.L2_LAC_OC.nc';
% 查看nc文件信息
info = ncinfo(filename);
% 读取用于质控的flag
flags = ncread(filename,'geophysical_data/l2_flags');
% 读取经纬度
lon = ncread(filename,'navigation_data/longitude');
lat = ncread(filename,'navigation_data/latitude');
% 读取反射率
Rrs_443 = ncread(filename, 'geophysical_data/Rrs_443');
Rrs_488 = ncread(filename, 'geophysical_data/Rrs_488');
Rrs_547 = ncread(filename, 'geophysical_data/Rrs_547');

%% 质量控制
% 需要用于判断质控的位置
bit_position = [0 1 3 4 5 8 9 12 14 15 16 19 21 22 25];

mask = ones(size(flags));
for i = 1:numel(bit_position)
    b = bitget(flags,bit_position(1)+1,'int32');
    mask(b==1) = nan;
end
% 进行质控
QC443 = Rrs_443.*mask;
QC488 = Rrs_488.*mask;
QC547 = Rrs_547.*mask;
%% 裁剪数据
shp = shaperead('lake nicaragua2.shp');
%选择在shp范围内的数据
loc1 = find(lon>=shp.BoundingBox(1) & lon<=shp.BoundingBox(2) ...
    & lat>=shp.BoundingBox(3) & lat<=shp.BoundingBox(4));
lon = lon(loc1);
lat = lat(loc1);
QC443 = QC443(loc1);
QC488 = QC488(loc1);
QC547 = QC547(loc1);
%% 反演
a = [0.2424 -2.7423 1.8017 0.0015 -1.2280];
Rrs = log10(max(QC443,QC488)./QC547);
chla = 10.^(a(1)+a(2)*Rrs.^1+a(3)*Rrs.^2+a(4)*Rrs.^3+a(5)*Rrs.^4);

%% 插值
% 网格大小
cs = 0.01;

% 建立投影参数
F = scatteredInterpolant(lon(:), lat(:), chla(:), 'linear', 'none');

[X,Y] = meshgrid(shp.BoundingBox(1) - 5*cs+0.5*cs:cs:shp.BoundingBox(2) + 5*cs-0.5*cs, ...
                    shp.BoundingBox(3) - 5*cs + 0.5*cs:cs:shp.BoundingBox(4) + 5*cs - 0.5*cs);

chla_grid = F(X,Y);
% 建立参考系
R = georefcells([shp.BoundingBox(1) - 5*cs, shp.BoundingBox(2) + 5*cs], ...
    [shp.BoundingBox(3) - 5*cs, shp.BoundingBox(4) + 5*cs], size(chla_grid));
%% 矢量裁切
[Z, ~] = vec2mtx(shp.X, shp.Y, chla_grid, R, 'filled');

chla_grid(Z==0) = nan;
%% 绘图
figure('color','w', 'Position',[100,100,800,600]);
pcolor(X,Y,chla_grid);
shading flat; 
colormap(jet); 
colorbar; 
axis equal;
hold on;
geoshow(shp.Y, shp.X, 'color', 'k', 'LineWidth',0.8);
caxis([0 90]);

