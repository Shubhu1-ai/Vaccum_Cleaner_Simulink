%% ZigZag_robot_simulation.m
% -------------------------------------------------------------------------
% FINAL INITIALIZATION AND VISUALIZATION SCRIPT FOR THE VACUUM CLEANER ROBOT
% Runs the Simulink model "ZigzagRobot.slx" with updated variable names.
% -------------------------------------------------------------------------

% --- Room and Environment Parameters ---
Ts = 0.01;                  % Sampling Period (10 ms)
r_clean = 0.4;              % Cleaning radius of the robot (meters)
room_length = 20;           % Length of the square room (m)
halfL  = room_length/2;      
obs_center = [3; 3];   % Center (x,y) of the obstacle
obstacle_radius = 0.25;     % Radius of the obstacle

% --- Robot and Motor Parameters ---
R_w  = 0.05;            % Wheel radius (m)
L_ax = 0.2;             % Axle track (distance between wheels) (m)
v_max = 0.3;            % Maximum linear speed (m/s)
Jg  = 1; fg  = 1; Rg  = 1; Lg  = 1; Kmg = 1; Keg = 1; % Left Motor Params
Jd  = 1; fd  = 1; Rd  = 1; Ld  = 1; Kmd = 1; Ked = 1.2; % Right Motor Params
Kp_w = 10; Ki_w = 50; Kd_w = 0; % Motor PID Controllers

% --- TRAJECTORY LAW Parameters (SPIRAL LAW) ---
% These variables MUST exist in the workspace for the model to compile.
v_ref_const = 0.2;    
R0          = 1;      
k_R         = 0.05;   

initial_radius   = R0;
rate_gain        = k_R;
linear_speed_cmd = v_ref_const;

% --- Coverage Map ---
grid_resolution = 100;                 % Grid resolution (N x N)
cell_size = room_length / grid_resolution;    % Size of one cell

% Simulation Time
T_end = 1000;   % Seconds of simulation

%% --- Random Initial Position ---
halfL = room_length/2;
x0 = (rand()*room_length) - halfL;
y0 = (rand()*room_length) - halfL;
theta0 = (rand()*2*pi) - pi;

% Avoid the obstacle at startup 
while sqrt((x0 - obs_center(1))^2 + (y0 - obs_center(2))^2) < obstacle_radius + 0.3
    x0 = (rand()*room_length) - halfL;
    y0 = (rand()*room_length) - halfL;
end
fprintf("Robot initial position: x=%.2f , y=%.2f , theta=%.2f rad\n", x0,y0,theta0);

%% =============================================================
% Run the Simulation (Calling the model: ZigzagRobot)
% =============================================================
try
    fprintf("Starting simulation (T_end = %d s) using model ZigzagRobot.slx...\n", T_end);
    out = sim("ZigzagRobot.slx", 'StopTime', num2str(T_end));
    fprintf("Simulation finished.\n");
catch ME
    warning('Simulation Error: Check your MATLAB Function code for syntax errors and ensure "ZigzagRobot.slx" is in the correct directory.');
    rethrow(ME);
end

%% =============================================================
% POST-PROCESSING AND VISUALIZATION
% =============================================================
if ~exist('out','var') || isempty(out)
    error("The simulation did not produce any data (out). Check for errors above.");
end

% --- DATA EXTRACTION ---
x = out.x_out;              % x(t) vector 
y = out.y_out;              % y(t) vector 
coverage_ts = get(out, 'coverage_percent'); 
t = coverage_ts.Time;               % Time vector
coverage_percentage = coverage_ts.Data; 

TT = out.grid_out;

% Coverage Map Processing
last_cell = TT.Data(end);
grid_last = last_cell{1};
L = room_length;
halfL = L/2;
N = size(grid_last, 1);

% Metric Grid (X,Y in meters)
[X, Y] = meshgrid(linspace(-halfL, halfL, N), ...
                  linspace(-halfL, halfL, N));

% -------------------------------------------------------------
% FIGURE 1: ROBOT PATH
% -------------------------------------------------------------
figure('Name','Robot Path');
plot(x, y, 'b', 'LineWidth', 1.5);
hold on;
% Draw obstacle using the renamed constant
viscircles(obs_center', obstacle_radius, 'Color', 'r', 'LineStyle', '--');
% Mark start and end
plot(x(1), y(1), 'go', 'MarkerFaceColor', 'g', 'MarkerSize', 8); 
plot(x(end), y(end), 'rx', 'LineWidth', 2, 'MarkerSize', 10); 
axis equal; grid on;
xlabel('x (m)');
ylabel('y (m)');
title('Robot Path (Zigzag Movement with Avoidance)');
xlim([-halfL halfL]);
ylim([-halfL halfL]);

% -------------------------------------------------------------
% FIGURE 2: Coverage ROOM (20x20 m) - Improved Colors
% -------------------------------------------------------------
figure('Name','Room Cleaned');
surf(X, Y, double(grid_last'), 'EdgeColor','none');
view(2);         
axis equal;
colormap(flipud(gray)); % Black/Dark = Cleaned
colorbar;
hold on;
viscircles(obs_center', obstacle_radius, 'Color', 'r', 'LineStyle', '--');
xlabel('x (m)');
ylabel('y (m)');
title('Total cleaned Room (Black Areas = Cleaned)');

% -------------------------------------------------------------
% FIGURE 3: TOTAL AREA CLEANED
% -------------------------------------------------------------
figure('Name','Total Area Cleaned');
surf(X, Y, double(grid_last'), 'EdgeColor','none');
view(2);
hold on;
% Plot trajectory slightly above the map (1.1*ones)
plot3(x, y, 1.1*ones(size(x)), 'r', 'LineWidth', 1.4);
viscircles(obs_center', obstacle_radius, 'Color', 'r', 'LineStyle', '--');
axis equal;
colormap(flipud(gray));
xlabel('x (m)');
ylabel('y (m)');
title('Total Cleaned Area (20x20 m)');
grid on;


%% -------------------------------------------------------------
% FIGURE 4: Cleaning Progress Over Time 
% -------------------------------------------------------------
figure('Name','Coverage Percentage');
plot(t, coverage_percentage, 'Color',[0.2 0.2 0.8], 'LineWidth', 2); % Deep blue line
xlabel('Time (s)'); ylabel('Coverage (%)');
title('Cleaning Percentage vs Time');
grid on; ylim([0 100]);
text(t(end)*0.8, coverage_percentage(end)-5, sprintf('Final Coverage Percentage: %.1f%%', coverage_percent(end)),'FontSize',12,'Color','k');
