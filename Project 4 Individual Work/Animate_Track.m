% === Track Visualization Script ===
% Assumes Wp = [x, y] contains the track waypoints

% Plot the track
figure;
h_center = plot(Wp(:,1), Wp(:,2), 'k--', 'LineWidth', 1); % Dashed black centerline
hold on;

% Compute track boundaries
left_boundary = zeros(size(Wp));
right_boundary = zeros(size(Wp));
for i = 1:length(Wp)
    if i < length(Wp)
        dir_vector = Wp(i+1,:) - Wp(i,:);
    else
        dir_vector = Wp(i,:) - Wp(i-1,:);
    end
    dir_vector = dir_vector / norm(dir_vector); % Normalize
    normal_vector = [-dir_vector(2), dir_vector(1)]; % Perpendicular (left)
    left_boundary(i,:) = Wp(i,:) + (track_width/2) * normal_vector;
    right_boundary(i,:) = Wp(i,:) - (track_width/2) * normal_vector;
end

% Plot solid black boundaries
h_bound = plot(left_boundary(:,1), left_boundary(:,2), 'k-', 'LineWidth', 2);
plot(right_boundary(:,1), right_boundary(:,2), 'k-', 'LineWidth', 2);

% Plot formatting
title('Race Track');
xlabel('X Position (m)');
ylabel('Y Position (m)');
axis equal;
grid on;

% === Car Animation ===
h = animatedline('Color', 'r', 'LineWidth', 1); % Car path trace

% Set plot limits
margin = 100;
axis([min(Wp(:,1))-margin, max(Wp(:,1))+margin, ...
      min(Wp(:,2))-margin, max(Wp(:,2))+margin]);

% Car shape, size based on track width
w = 3;
car = [- w*2, - w; w*2, -w; w*2, w; -w*2, w]';
a = patch('XData', car(1,:), 'YData', car(2,:), ...
    'EdgeColor', [0 0 0], 'FaceColor', 'b');

legend([h_center, h_bound, h, a], {'Centerline', 'Track Boundaries', 'Car Path', 'Car'}, 'Location', 'northeast');

% Animation loop
for i = 1:length(simout.X.Data)-1
    x = simout.X.Data(i);
    y = simout.Y.Data(i);
    addpoints(h, x, y);

    dx = simout.X.Data(i+1) - simout.X.Data(i);
    dy = simout.Y.Data(i+1) - simout.Y.Data(i);
    angle = atan2(dy, dx);

    car_centered = car - mean(car, 2);
    car_rotated = rotate(car_centered, angle);
    car_final = car_rotated + [x; y];

    a.XData = car_final(1, :);
    a.YData = car_final(2, :);

    drawnow limitrate;
end

hold off;

% === Rotation Helper Function ===
function xyt = rotate(xy, theta)
    R = [cos(theta), -sin(theta); sin(theta), cos(theta)];
    xyt = R * xy;
end