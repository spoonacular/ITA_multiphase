function [sorted,index_trace,indexcut]=sortsnake(trace,P0)
%function that sorts all coordinates to by starting at at specified point
%P0. Output sorted is [P0;P1;P2;...Pi] where P0 is specified starting point
%P1 is the point in trace closest to P0, P2 is the point in trace exluding
%P0, Pi is the point in trace closest to Pi-1 excluding P1:Pi-2. 
% This also means that if the data points forks the trace will choose one
% branch and avoid the other. When reaching the end of the chosen branch
% the boundary will jump to the other branch. If this happens the script will stop the
% boundary if the jump is more than 5 pixels.
% Input
%     trace:        a list of points to be sorted in [row,col] coordinates
%     P0:           the starting coordinate in [col,row]
% Output
%     sorted:       Sorted version of trace
%     index_trace:  logic vector that ensures sorted=trace(index_trace,:)
%     indexcut:     logic vector that cuts of secondary branches.
%



%data=[flip(P0);trace];
data=[P0;trace];
dist = pdist2(data,data);

N = size(data,1);

indexcut=ones(1,N-1);
result = NaN(1,N);
result(1) = 1; % first point is first row in data matrix

for ii=2:N
    dist(:,result(ii-1)) = Inf;
    [mindist, closest_idx] = min(dist(result(ii-1),:));
        result(ii) = closest_idx;
        if mindist>5
            indexcut(ii-1:end)=0;
        end
end
result(1)=[];
result=result-1;
sorted=trace(result',:);
indexcut=indexcut==1;
index_trace=result;