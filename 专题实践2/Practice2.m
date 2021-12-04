%% 提取上海和北京两个城市所有检测站点的数据；
    % 1. 存储为csv文件；
    % 2. csv文件第一行为表头（tablehead）
    % 3. 文件命名格式：城市名_数据获取日期_数据获取实践.csv
    % 4. 所有操作必须通过算法自动实现，且算法具有通用性

bj = '北京';
sh = '上海';
% url = 'http://pm25.in/';
% html = webread(url);
%% 读取html
clear; clc;
html =  'PM25.html';
% 读 html
fid = fopen(html,'r','b','UTF-8');
str ={};
while ~feof(fid)
    tline = fgetl(fid);
    str = [str;tline];
end
fclose(fid)
%% 提取时间
dt = regexp(str, '\d{4}-\d{2}-\d{2} \d{2}','match','once');
dt = dt(~cellfun(@isempty,dt));
dt = dt{1};
% 分割时间
dt = regexprep(dt(1),'[-\s]','');
%% 提取数据
% 提取表头
thread = regexp(str,'<th.*?/th>','match');
thread = thread(~cellfun(@isempty,thread));
thread = cellfun(@(x) regexprep(x,'<.*?>',''),thread);
% 提取表格内容
data = regexp(str,'<td.*?/td>','match');
data = data(~cellfun(@isempty,data));
data = cellfun(@(x) regexprep(x,'<.*?>',''),data);
% 构建为二维数组
data = reshape(data,[length(thread) length(data)/length(thread)]);
data = data';
thread = thread';
% cell转成table
table = cell2table(data,"VariableNames",thread);
% 标题名
filename = ['Shanghai_',dt,'_数据获取实践.csv'];
writetable(table,filename);
