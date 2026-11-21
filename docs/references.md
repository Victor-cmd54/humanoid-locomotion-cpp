# References and learning path

## Source section

The supplied Word document,
*Building a Humanoid Robot Brain — AI Model, Knowledge Graph & 6-Stage
Pipeline in C++17–26*, is the source for the project topic:

- **Section 1.4 — Complete humanoid locomotion knowledge list:** defines
  body-relative velocity commands and the supported locomotion capabilities.
- **Section 1.4.1 — Standing:** explains standing, IMU-assisted posture,
  center-of-pressure control, weight transfer, and disturbance-resistant
  behavior.
- **Section 1.4.1.2 — Important safety boundary:** limits the supplied
  educational examples to simulation and simplified calculations.
- **The complete locomotion pipeline:** connects velocity commands through
  limiting, footstep planning, swing trajectories, inverse kinematics,
  whole-body/balance control, impedance control, safety limiting, and an
  interface.
- **Minimum viable milestone:** identifies the robot model, sensing, safety,
  state estimation, planning, control, simulation, and logging needed before
  more advanced work.

This repository creates a concise C++20 implementation of the command-limiter
stage and a SysML/UML architectural representation of the complete stage
sequence. It does not reproduce the entire document or claim that the omitted
controllers are implemented.

## Recommended external references

The following sources are a starting point for deeper study:

1. **Kajita, S. and colleagues — "Introduction to Humanoid Robotics"
   (Springer).** Covers humanoid kinematics, dynamics, ZMP, and walking
   control. Use a stable publisher or library edition.
2. **Vukobratović, M. and Borovac, B. — "Zero-Moment Point — Thirty Five
   Years of Its Life."** Foundational ZMP context for biped stability:
   https://doi.org/10.5772/1697
3. **Siciliano and Khatib — "Springer Handbook of Robotics."** Broad reference
   for manipulators, legged robots, dynamics, planning, and control.
4. **ROS 2 Control documentation:** architecture for hardware interfaces,
   controllers, and real-time-safe integration:
   https://control.ros.org/
5. **ROS 2 Humble documentation:** nodes, topics, lifecycle, parameters,
   launch, logging, and testing:
   https://docs.ros.org/en/humble/
6. **Navigation2 documentation:** navigation behavior, costmaps, and
   localization integration:
   https://docs.nav2.org/
7. **Robot Operating System 2 (ROS 2) design documentation:** middleware,
   quality of service, and distributed robot communication:
   https://design.ros2.org/
8. **ISO 10218-1/-2:** industrial robot safety requirements and risk
   assessment concepts. Local standards and a formal safety review are required
   for applicable industrial systems.
9. **IEC 61508 / ISO 13849:** functional-safety concepts and safety-related
   control systems. Consult a qualified safety professional rather than
   relying on software conventions alone.
10. **MuJoCo documentation:** physics simulation for locomotion, contact,
    balancing, and controller development:
    https://mujoco.readthedocs.io/
11. **Gazebo documentation:** integrated simulation and ROS 2 testing:
    https://gazebosim.org/docs

## How to verify an external claim

Before adopting a controller or paper result for a real robot:

- confirm that the robot model, mass distribution, foot geometry, friction,
  actuator envelope, and contact assumptions match the implementation;
- reproduce the method in deterministic simulation;
- test the full failure chain: sensor loss, estimator divergence, stale
  commands, actuator faults, thermal limits, communication loss, and emergency
  stop;
- have a qualified reviewer assess stability and functional safety;
- cite the exact paper, edition, DOI, or standard in source and test records.
