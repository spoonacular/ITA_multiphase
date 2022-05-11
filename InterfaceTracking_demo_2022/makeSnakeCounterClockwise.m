function sorted_xy = makeSnakeCounterClockwise(sorted_xy)
% point 1: center of grain
xy_mean = mean(sorted_xy); 

% poinnt c: vertice with minimum x+y
start_ind = find(sum(sorted_xy,2)==min(sum(sorted_xy,2)));
xy_xmin = sorted_xy(start_ind,:);

% point 2: next vertice
next_ind = mod(start_ind,size(sorted_xy,1))+1;
xy_next = sorted_xy(next_ind,:);

angle = calAngleWith3Coords(xy_xmin,xy_next,xy_mean);
if angle > 180
    previous_ind = mod(start_ind-2,size(sorted_xy,1))+1;
    xy_previous =  sorted_xy(previous_ind,:);
    angle_previous = calAngleWith3Coords(xy_xmin,xy_previous,xy_mean);
    if angle_previous > 180
        if xy_previous(1)-xy_previous(2) > xy_next(1)-xy_next(2)
            sorted_xy = flip(sorted_xy);
        end
    else
        sorted_xy = flip(sorted_xy);
    end
end