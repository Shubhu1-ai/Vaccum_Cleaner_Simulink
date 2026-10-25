# Autonomous Vacuum Cleaner Robot Simulation

**Course:** ANNEE 4 - INDUSTRY AND ROBOTICS (MOBILE ROBOTICS)  
**Institution:** École Supérieure d'Ingénieurs Léonard de Vinci (ESILV)  
**Authors:** Bollu Shubham N.
**Instructor:** Laurent DELALE  

## Project Overview
This project presents the design, implementation, and evaluation of an autonomous vacuum cleaner robot utilizing a hybrid control architecture. The system is modeled as a differential drive unicycle kinematic system and simulated entirely within MATLAB and Simulink. 

It maximizes cleaning efficiency in an unknown $20m \times 20m$ environment without relying on complex mapping systems (like SLAM) by combining:
1. **Global Path Planning:** An Archimedean spiral trajectory pattern for systematic outward expansion and optimal space-filling in obstacle-free zones.
2. **Local Reactive Control:** An obstacle avoidance mechanism using simulated ultrasonic distance sensing.

## Repository / File Structure
Based on the provided project files, the directory is structured as follows:

* `slprj/` - Simulink project cache and build folder.
* `Shubham_Bollu_Mobile_Robotics_FInal.pdf` - Detailed project report.
* `ZigZag_robot_simulation.m` - MATLAB initialization and execution script (Main entry point).
* `ZigzagRobot.slx` - Main Simulink model file containing the kinematic, dynamic, and control logic.
* `ZigzagRobot.slxc` - Simulink cache file.

## System Requirements
* **MATLAB Version:** R2020a or newer
* **Required Toolboxes:**
  * Simulink
  * Stateflow (used for the state machine implementation of the obstacle avoidance logic)
* **Operating System:** Windows, macOS, or Linux

## Execution Instructions
To properly run the simulation and generate the coverage maps, follow these steps precisely:

1. Extract the project archive to a local directory.
2. Open MATLAB and navigate to the extracted folder using the "Current Folder" browser.
3. Open the script `ZigZag_robot_simulation.m` in the MATLAB Editor.
4. Execute the script by pressing **F5** or clicking the **Run** button.

> **⚠️ IMPORTANT:** Do not open or run the Simulink model file (`ZigzagRobot.slx`) directly. The MATLAB script is required to initialize essential workspace variables (e.g., obstacle center, expansion rate, PID gains) before the model can run.

### Automated Output
Running the script will automatically simulate 1000 seconds of operation and generate four output figures:
* **Figure 1:** Robot trajectory path
* **Figure 2:** Room coverage map
* **Figure 3:** Combined trajectory and coverage visualization
* **Figure 4:** Coverage percentage vs. time plot

## Simulation Parameters & Customization
You can test different scenarios by modifying the following variables directly inside `ZigZag_robot_simulation.m`:

| Parameter | Default Value | Description |
| :--- | :--- | :--- |
| `v_ref_const` | $0.2~m/s$ | Commanded linear velocity (cleaning speed) |
| `obs_center` | `[3, 3]` | Coordinates of the cylindrical obstacle |
| `room_length` | $20~m$ | Dimensions of the square room |
| `k_R` | $0.05$ | Spiral expansion rate gain |
| `R_0` | $1.0~m$ | Initial spiral radius |
| `Kp_w` | $10$ | PID proportional gain for motor control |

## Key Features
* **Asymmetric Motor Dynamics:** Simulates real-world hardware imperfections by assigning slightly different back-EMF constants to the left ($K_{eg}=1.0$) and right ($K_{ed}=1.2$) motors. Two independent PI controllers handle accurate velocity tracking.
* **Ray Casting Sensor Simulation:** Features a computationally efficient simulated ultrasonic sensor that detects boundaries and obstacles to trigger avoidance states.
* **Finite State Machine (FSM):** Handles smooth transitions between Normal Operation (spiral), Warning Zone (soft turn), and Critical Zone (hard turn/sharp avoidance).
* **Grid-Based Coverage Mapping:** Quantifies cleaning efficiency by mapping out a $100 \times 100$ discretized grid and tracking the cleaning radius ($r_{clean}=0.4~m$).

## Performance
In a simulated $1000~s$ run, the robot achieves a coverage of approximately **33-40%** while maintaining an average speed of $0.2~m/s$ and covering a total distance of roughly $200~m$.
