# Humanoid locomotion: from intent to safe motion

This guide adapts the humanoid-locomotion learning section of *Building a
Humanoid Robot Brain — AI Model, Knowledge Graph & 6-Stage Pipeline in
C++17–26* (sections 1.4, 1.4.1.2, and the minimum viable milestone). It
explains the ideas represented in `sysml/HumanoidLocomotion.sysml`.

## What locomotion means

Humanoid locomotion is the process of turning a desired body motion into
coordinated, balanced foot and joint motion. It includes more than walking:
standing, starting and stopping, walking backward or sideways, turning,
moving along curves, changing gait, responding to disturbances, and adapting
to terrain are all part of the problem.

A useful command interface is a body-relative velocity triple:

| Value | Meaning | Example |
| --- | --- | --- |
| `vx` | Forward/backward speed in metres per second | Positive moves forward |
| `vy` | Left/right speed in metres per second | Positive steps left |
| `wz` | Yaw rate in radians per second | Positive turns left |

Combining components expresses diagonal or curved motion. This is a request
to the locomotion system, not a direct motor command.

## The locomotion pipeline

The model represents a staged control pipeline:

1. **Limit the request.** Bound forward, lateral, and turning speeds before
   planning. Real systems also need acceleration and jerk limits selected
   for their particular robot.
2. **Estimate the robot state.** Combine available measurements such as joint
   encoders, an IMU, and foot-contact sensing to estimate pose, velocity, and
   support.
3. **Plan footsteps.** Convert the bounded body motion into feasible step
   targets, considering reachability, self-collision, terrain, friction,
   balance, and step-size limits.
4. **Generate swing-foot motion.** Move a lifted foot smoothly toward its
   target with clearance above the terrain; adapt the landing height to the
   estimated surface.
5. **Solve inverse kinematics.** Convert target foot poses into joint targets.
   Reject unreachable targets rather than silently forcing them to a limit.
6. **Stabilize the whole body.** Coordinate the center of mass, support
   contacts, and joint motion. Simplified models such as the linear inverted
   pendulum can help explain planning; they do not replace full-body
   validation.
7. **Calculate joint commands.** An impedance controller can combine position
   and velocity errors with feed-forward terms to compute desired effort.
8. **Enforce safety limits.** Check joint, torque, speed, contact, and
   controller-health constraints before commands reach an interface.
9. **Send and measure.** Deliver commands to a simulator or validated
   interface, observe the result, and feed measurements into the next cycle.

The repeated engineering loop is **perceive → estimate → plan → control →
measure → correct**. Separating these stages makes the system easier to test
and lets engineers replace one algorithm without hiding its responsibilities
inside a monolithic gait function.

## Why standing comes first

Standing provides a repeatable starting, stopping, and recovery condition.
Before attempting steps, verify the state estimate, foot contacts, and balance
response. IMU measurements can reveal body tilt and rotation; foot force or
pressure measurements provide contact information that joint positions alone
cannot. A step should not begin merely because a timer says it is time to lift
a foot—the support leg must be carrying the robot safely.

Balance methods reason about the relationship between the center of mass,
ground contacts, and forces. Center of pressure (CoP), zero-moment point
(ZMP), capture-point reasoning, simplified pendulum models, and whole-body
control are different tools with different assumptions and operating ranges.
They should be learned and tested in simulation before hardware use.

## Learning and validation progression

Build capability in small steps: establish a stable stand; test controlled
starts and stops; add short forward and backward steps; then add lateral and
turning commands. After each stage, inspect logs and regression tests. Only
then expand toward diagonal motion, terrain adaptation, disturbance recovery,
and transitions between gaits.

The minimal learning system should include a robot model, verified sensing,
an emergency-stop concept, joint and command limits, state estimation,
footstep planning, balance control, simulation tests, and controlled-stop
behavior. Test first in simulation. On physical hardware, use robot-specific
limits, a support harness where appropriate, independent emergency stopping,
watchdogs, and supervision by qualified robotics engineers.

## Scope of this repository

`src/main.cpp` demonstrates only the first stage: clamping a velocity request
to explicitly illustrative bounds. `sysml/HumanoidLocomotion.sysml` describes
the larger system and the ordering of its responsibilities. Neither artifact
is a balance controller or a hardware driver, and the sample values are not
validated limits for any real robot.
