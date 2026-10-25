# Autonomous Vacuum Cleaner Robot Simulation

**Course:** ANNEE 4 - INDUSTRY AND ROBOTICS (MOBILE ROBOTICS)  
**Institution:** École Supérieure d'Ingénieurs Léonard de Vinci (ESILV)  
**Authors:** Bollu Shubham N., Athul Thekkinkattil  
**Instructor:** Laurent DELALE  
**Date:** November 06, 2025  

---

## Abstract & Project Overview

This project presents the design, implementation, and evaluation of an autonomous vacuum cleaner robot utilizing a hybrid control architecture. The primary objective is to develop and simulate a mobile robot capable of efficiently cleaning an unknown indoor environment without relying on complex mapping systems (like SLAM). 

The system combines a global spiral trajectory planner with a local reactive obstacle avoidance mechanism to maximize cleaning efficiency. Simulation results demonstrate effective area coverage, achieving approximately 33-40% room coverage within 1000 seconds of operation in a $20m \times 20m$ environment containing obstacles.

---

## 1. Proposed Control Strategy

The control strategy uses a hierarchical architecture with two complementary layers.

### 1.1 Global Strategy: Archimedean Spiral Trajectory
To maximize coverage, we implemented a space-filling curve approach using an Archimedean spiral pattern.
*   **Linear Velocity:** Maintained at a constant rate for consistent cleaning.
    $$v_{cmd} = v_{ref\_const} = 0.2 m/s$$
*   **Radius of Curvature:** Increases linearly with time.
    $$R(t) = R_{0} + k_{R} \cdot t$$
    *(where $R_{0} = 1.0 m$ and $k_{R} = 0.05$)*
*   **Angular Velocity:** 
    $$\omega_{cmd}(t) = \frac{v_{cmd}}{R(t)} = \frac{v_{ref\_const}}{R_{0} + k_{R} \cdot t}$$

### 1.2 Local Strategy: Reactive Obstacle Avoidance
A reactive control layer overrides the spiral trajectory when obstacles are detected via an ultrasonic distance sensor ($d$).

| State | Condition | Control Action |
| :--- | :--- | :--- |
| **Normal Operation** | $d > 1.0 m$ | Follow spiral trajectory. Reset turn direction state. |
| **Warning Zone** | $0.4 m < d \le 1.0 m$ | Soft avoidance: Reduce speed to $0.8 \times v_{cmd}$, soft turn ($\omega = 0.6 rad/s$). |
| **Critical Zone** | $d \le 0.4 m$ | Hard avoidance: Reduce speed to $0.6 \times v_{cmd}$, sharp turn ($\omega = 1.5 rad/s$). |

*(Note: Turn direction is locked upon initial detection to prevent oscillatory loops).*

---

## 2. Simulation Architecture

The system is implemented in MATLAB/Simulink (`ZigzagRobot.slx`).

![Simulink Architecture Model](path/to/your/simulink_model_image.png)
*> Placeholder: Insert the main Simulink architecture image from Page 4 of your report here.*

### 2.1 Kinematic & Dynamic Modeling
The robot is modeled using differential drive kinematics.
$$v = \frac{R_{w}}{2}(\omega_{R} + \omega_{L})$$
$$\omega = \frac{R_{w}}{L_{ax}}(\omega_{R} - \omega_{L})$$
*(where $R_{w} = 0.05 m$ and $L_{ax} = 0.2 m$)*

The DC motors are modeled with electrical and mechanical dynamics, assigning slightly different back-EMF constants (Right: $K_{ed} = 1.2$, Left: $K_{eg} = 1.0$) to simulate real-world asymmetry. Two independent PID controllers ($K_{p} = 10, K_{i} = 50$) compensate for this asymmetry.

### 2.2 Sensor & Coverage Mapping
*   **Sensor:** An ultrasonic sensor is simulated using a ray-casting algorithm checking intersections against a $20m \times 20m$ room and a cylindrical obstacle at $(3,3)$.
*   **Coverage:** Evaluated using a $100 \times 100$ uniform grid ($0.2m \times 0.2m$ cells). 
    $$Coverage Percentage = \frac{Number of Cleaned Cells}{Total Navigable Cells} \times 100\%$$

---

## 3. Simulation Results and Analysis

The simulation was executed for $T = 1000$ seconds. 

### Performance Metrics
| Metric | Value |
| :--- | :--- |
| Simulation Duration | 1000 s |
| Final Coverage Percentage | 33-40% |
| Average Linear Velocity | $0.2 m/s$ |
| Total Distance Traveled | ~200 m |

### Visualizations

![Robot Trajectory](path/to/your/trajectory_image.png)
*> Placeholder: Insert the "Robot Trajectory (Zigzag Movement)" plot from Page 9 here.*

![Map of Cleaned Areas](path/to/your/cleaned_areas_image.png)
*> Placeholder: Insert the "Map of Cleaned Areas" grid from Page 9 here.*

![Cleaning Progress vs Time](path/to/your/progress_graph.png)
*> Placeholder: Insert the "Cleaning Progress vs Time" graph from Page 10 here.*

The coverage grows linearly initially (0-400s) and then experiences diminishing returns (400-1000s) as the robot frequently encounters boundaries and obstacles, requiring reactive avoidance maneuvers.

---

## 4. Implementation Instructions

### 4.1 System Requirements
*   **MATLAB Version:** R2020a or newer
*   **Required Toolboxes:** Simulink, Stateflow
*   **OS:** Windows, macOS, or Linux

### 4.2 File Structure
Below is the required structure of the project files:

![File Structure](image_06fb5a.png)

*   `ZigzagRobot.slx` - Main Simulink model file
*   `ZigZag_robot_simulation.m` - MATLAB initialization and execution script
*   `Shubham_Bollu_Mobile_Robotics_FInal.pdf` - Project Report

### 4.3 Execution Procedure
**⚠️ IMPORTANT:** Do not open or run the Simulink `.slx` model file directly.

1. Extract the project archive to a local directory.
2. Open MATLAB and navigate to the extracted folder.
3. Open `ZigZag_robot_simulation.m` in the MATLAB Editor.
4. Run the script (Press **F5** or click **Run**). 
    * *This script initializes essential workspace variables (e.g., `obs_center`, `k_R`, `Kp_w`) before automatically executing the Simulink model.*

### 4.4 Parameter Customization
You can test different scenarios by modifying variables directly inside `ZigZag_robot_simulation.m`:
*   `v_ref_const = 0.3` (To test faster cleaning)
*   `obs_center = [5, 8]` (To change obstacle position)
*   `room_length = 30` (To simulate a larger room)

---

## 5. Future Improvements
*   **Hybrid Coverage:** Combine the spiral pattern with wall-following for better corner coverage.
*   **Memory Integration:** Maintain a "visited cells" map to avoid redundant pathing.
*   **Multi-Sensor Fusion:** Add side-facing sensors for 360-degree obstacle awareness and improved recovery trajectories.