# Humanoid Locomotion C++

An educational C++20 project for learning how a humanoid locomotion system
turns a body-motion request into a safe, testable control pipeline. It is a
software example only: it is not hardware-control code and is not
safety-certified.

## Project contents

- `src/main.cpp` — small velocity-command limiter example.
- `sysml/HumanoidLocomotion.sysml` — SysML v2 textual model of the locomotion
  subsystem, its responsibilities, and its control-cycle order.
- `uml/HumanoidLocomotion.puml` — UML class and activity view of the same
  system architecture.
- `uml/HumanoidLocomotion.svg` — rendered architecture diagram for direct
  viewing and Word/document embedding.
- `docs/locomotion-concepts.md` — an explanation of the locomotion topic,
  adapted from the corresponding section of the supplied robotics learning
  document.
- `docs/references.md` — source document section map and external reference
  material for balance control, bipedal walking, ROS 2, and safety.

The model and guide cover body-relative velocity commands (`vx`, `vy`, `wz`),
command limiting, state estimation, footstep planning, swing-foot
trajectories, inverse kinematics, balance and whole-body control, joint
impedance, and safety limiting. See the [locomotion concepts guide](docs/locomotion-concepts.md)
for an explanation of how these stages fit together and how to learn them
progressively.

## Build and run

Requires CMake 3.20+ and a C++20 compiler.

```sh
cmake -S . -B build
cmake --build build --config Release
./build/humanoid_locomotion
ctest --test-dir build --output-on-failure
```

On Windows with a multi-configuration generator, run
`.\build\Release\humanoid_locomotion.exe`.

The sample prints requested and limited velocity values. Its numeric limits
are for demonstration only. They are not a recommendation for physical
hardware.

## Safety and scope

The project does not implement state estimation, footstep generation,
inverse kinematics, balance control, or motor communication. The SysML model
shows how those responsibilities relate; it does not claim that they are
implemented by the sample. Use simulation, robot-specific analysis, hardware
limits, watchdogs, and an independent emergency stop before any real-world
robot testing.

## Source topic

The explanatory guide is based on the “Complete humanoid locomotion
knowledge list,” the locomotion pipeline, and the minimum viable milestone
in *Building a Humanoid Robot Brain — AI Model, Knowledge Graph & 6-Stage
Pipeline in C++17–26* (sections 1.4, 1.4.1.2, and 20).
