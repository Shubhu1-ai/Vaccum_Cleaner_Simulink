# Autonomous Vacuum Cleaner Robot Simulation

**Course:** ANNEE 4 - INDUSTRY AND ROBOTICS (MOBILE ROBOTICS)  
**Institution:** École Supérieure d'Ingénieurs Léonard de Vinci (ESILV)  
**Authors:** Bollu Shubham N., Athul Thekkinkattil  
**Instructor:** Laurent DELALE  
**Date:** November 06, 2025  

---

## Abstract
This project presents the design, implementation, and evaluation of an autonomous vacuum cleaner robot utilizing a hybrid control architecture. The system combines a global spiral trajectory planner with a reactive obstacle avoidance mechanism to maximize cleaning efficiency in unknown environments. Simulation results demonstrate effective area coverage, achieving approximately 33-40% room coverage within 1000 seconds of operation in a $20m \times 20m$ environment containing obstacles.

## 1. Introduction
The primary objective of this project is to develop and simulate an autonomous mobile robot capable of efficiently cleaning an unknown indoor environment. The robot maximizes forward movement while avoiding obstacles and ensuring comprehensive area coverage without requiring complex mapping systems such as SLAM.

The proposed system employs a differential drive robot modeled as a unicycle kinematic system. The control architecture integrates:
* A global path planning strategy based on Archimedean spiral trajectories
* A local reactive obstacle avoidance system using ultrasonic distance sensing
* Dynamic motor modeling with asymmetric characteristics to simulate real-world conditions
* Grid-based coverage mapping for performance evaluation

---

## 2. Proposed Control Strategy
The control strategy is designed as a hierarchical architecture with two complementary layers: global trajectory planning and local reactive control.

### 2.1 Global Strategy: Archimedean Spiral Trajectory
To maximize area coverage, we implement a space-filling curve approach using an Archimedean spiral pattern. This strategy ensures systematic outward expansion.

* **Linear Velocity:** The commanded linear velocity is maintained constantly.
  $$v_{cmd} = v_{ref\_const} = 0.2~m/s$$
* **Radius of Curvature:** The spiral radius increases linearly with time.
  $$R(t) = R_{0} + k_{R} \cdot t$$
  *(where $R_{0} = 1.0~m$ is the initial radius, and $k_{R} = 0.05$ is the spiral expansion rate gain)*
* **Angular Velocity:** Calculated to maintain the relationship between linear velocity, angular velocity, and radius.
  $$\omega_{cmd}(t) = \frac{v_{cmd}}{R(t)} = \frac{v_{ref\_const}}{R_{0} + k_{R} \cdot t}$$

### 2.2 Local Strategy: Reactive Obstacle Avoidance
A reactive control layer continuously monitors sensor data and overrides the global spiral trajectory when obstacles are detected (using an ultrasonic distance sensor reading, $d$).

| State | Condition | Control Action |
| :--- | :--- | :--- |
| **Normal Operation** | $d > 1.0~m$ | Follow spiral trajectory. Reset internal turn direction. |
| **Warning Zone** | $0.4~m < d \le 1.0~m$ | Soft avoidance: Speed to $0.8 \times v_{cmd}$, soft turn ($\omega = 0.6~rad/s$). |
| **Critical Zone** | $d \le 0.4~m$ | Hard avoidance: Speed to $0.6 \times v_{cmd}$, sharp turn ($\omega = 1.5~rad/s$). |

To prevent oscillatory behavior, the system randomly selects a left or right turn direction upon initial detection and commits to it until the obstacle is cleared.

---

## 3. Simulation Architecture
The complete system is implemented in MATLAB/Simulink using a modular block-based architecture.

![Simulink Architecture](Screenshot 2026-10-25 154015_2.png)

### 3.1 Kinematic Model
The robot is modeled using differential drive kinematics:
$$v = \frac{R_{w}}{2}(\omega_{R} + \omega_{L})$$
$$\omega = \frac{R_{w}}{L_{ax}}(\omega_{R} - \omega_{L})$$
Where $R_{w} = 0.05~m$ (wheel radius) and $L_{ax} = 0.2~m$ (axle track).

The global pose $(x, y, \theta)$ is updated using:
$$\dot{x} = v \cos(\theta)$$
$$\dot{y} = v \sin(\theta)$$
$$\dot{\theta} = \omega$$

### 3.2 Dynamic Motor Model
To simulate physical imperfections, DC motors are assigned slightly different back-EMF constants:
* Right motor: $K_{ed} = 1.2$
* Left motor: $K_{eg} = 1.0$

Two independent PID controllers ($K_{p}=10$, $K_{i}=50$, $K_{d}=0$) compensate for these asymmetries.

---

## 4. Simulation Results and Analysis

### 4.1 Trajectory Analysis
The trajectory visualization clearly shows the initial tight circular motion, gradual expansion, reactive deviations when encountering the obstacle at (3,3), and wall-following behavior.

![Robot Trajectory](Screenshot 2026-10-25 154156_2.png)

### 4.2 Cleaning Coverage Performance
The binary coverage map provides a spatial representation of cleaned areas (black) vs uncleaned areas (grey), with the obstacle shown in white.

![Coverage Map](Screenshot 2026-10-25 154207_2.png)

### 4.3 Combined Visualization
The combined visualization overlays the robot's red path onto the black coverage map.

![Combined Visualization](Screenshot 2026-10-25 154257_2.png)

**Final Performance Metrics:**
* **Simulation Duration:** 1000 s
* **Final Coverage Percentage:** 33-40%
* **Average Linear Velocity:** $0.2~m/s$
* **Total Distance Traveled:** ~200 m

---

## 5. Implementation Instructions

### 5.1 System Requirements
* MATLAB Version: R2020a or newer
* Required Toolboxes: Simulink, Stateflow
* Operating System: Windows, macOS, or Linux

### 5.2 File Structure
The project archive contains the following files. Make sure your directory matches this structure:

![File Structure](image_06fb5a.png)

* `ZigzagRobot.slx` - Main Simulink model file
* `ZigZag_robot_simulation.m` - MATLAB initialization and execution script

### 5.3 Execution Procedure
To run the simulation, follow these steps precisely:
1. Extract the provided archive to a local directory.
2. Open MATLAB and navigate to the extracted folder.
3. Open `ZigZag_robot_simulation.m` in the MATLAB Editor.
4. Execute the script by pressing **F5** or clicking "Run".

> **⚠️ IMPORTANT:** Do not open or run the Simulink model file (`.slx`) directly first. The MATLAB script initializes essential workspace variables (e.g., `obs_center`, `k_R`, `Kp_w`) that the Simulink model requires to function.

### 5.4 Parameter Modification
You can customize scenarios by modifying parameters in `ZigZag_robot_simulation.m`:
| Parameter | Default | Effect |
| :--- | :--- | :--- |
| `v_ref_const` | $0.2~m/s$ | Robot linear velocity (cleaning speed) |
| `obs_center` | `[3, 3]` | Obstacle position coordinates |
| `room_length` | $20~m$ | Room dimensions (square room) |
| `k_R` | 0.05 | Spiral expansion rate |
| `R_0` | $1.0~m$ | Initial spiral radius |
| `Kp_w` | 10 | PID proportional gain |