package HumanoidLocomotion {
    import ScalarValues::*;

    enum def GaitMode {
        enum stand;
        enum walk;
        enum turn;
        enum recover;
        enum stop;
    }

    item def BodyVelocityCommand {
        attribute vx : Real;
        attribute vy : Real;
        attribute wz : Real;
    }

    item def RobotStateEstimate {
        attribute position : Real;
        attribute orientation : Real;
        attribute velocity : Real;
        attribute supportMargin : Real;
    }

    item def FootstepPlan {
        attribute stepDuration : Real;
        attribute stepLength : Real;
        attribute stepWidth : Real;
        attribute swingHeight : Real;
    }

    part def CommandLimiter {
        attribute maxForwardSpeed : Real;
        attribute maxLateralSpeed : Real;
        attribute maxYawRate : Real;
    }

    part def StateEstimator;
    part def FootstepPlanner;
    part def SwingFootTrajectoryGenerator;
    part def InverseKinematicsSolver;
    part def BalanceAndWholeBodyController;
    part def JointImpedanceController;
    part def SafetyLimiter;
    part def RobotInterface;

    part def HumanoidLocomotionSystem {
        attribute gaitMode : GaitMode;

        part commandLimiter : CommandLimiter;
        part stateEstimator : StateEstimator;
        part footstepPlanner : FootstepPlanner;
        part trajectoryGenerator : SwingFootTrajectoryGenerator;
        part inverseKinematics : InverseKinematicsSolver;
        part balanceController : BalanceAndWholeBodyController;
        part jointController : JointImpedanceController;
        part safetyLimiter : SafetyLimiter;
        part robotInterface : RobotInterface;

        action def ExecuteLocomotionCycle {
            in desiredMotion : BodyVelocityCommand;
            in robotState : RobotStateEstimate;
            out plannedSteps : FootstepPlan;

            action limitVelocityCommand;
            then action estimateRobotState;
            then action planFootsteps;
            then action generateSwingTrajectory;
            then action solveInverseKinematics;
            then action stabilizeWholeBody;
            then action calculateJointCommands;
            then action enforceSafetyLimits;
            then action sendToRobotInterface;
        }

        perform ExecuteLocomotionCycle;
    }
}
