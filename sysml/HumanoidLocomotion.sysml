package HumanoidLocomotion {
    import ScalarValues::*;

    enum def GaitMode {
        enum stand;
        enum walk;
        enum start;
        enum stop;
        enum sideStep;
        enum diagonal;
        enum turn;
        enum curvedPath;
        enum recover;
        enum slope;
        enum stairs;
        enum unevenTerrain;
        enum lowFriction;
    }

    item def BodyVelocityCommand {
        attribute vx : Real;
        attribute vy : Real;
        attribute wz : Real;
    }

    item def StandTarget {
        attribute pelvisHeight : Real;
        attribute hipPitch : Real;
        attribute kneePitch : Real;
        attribute anklePitch : Real;
    }

    item def ImuMeasurement {
        attribute roll : Real;
        attribute pitch : Real;
        attribute rollRate : Real;
        attribute pitchRate : Real;
    }

    item def PressurePoint {
        attribute x : Real;
        attribute y : Real;
        attribute forceZ : Real;
    }

    item def CenterOfPressure {
        attribute x : Real;
        attribute y : Real;
        attribute totalForceZ : Real;
    }

    item def ZeroMomentPoint {
        attribute x : Real;
        attribute y : Real;
        attribute insideSupportPolygon : Boolean;
    }

    item def LinearInvertedPendulumState {
        attribute comX : Real;
        attribute comY : Real;
        attribute comHeight : Real;
        attribute comAX : Real;
        attribute comAY : Real;
        attribute gravity : Real;
    }

    item def RobotStateEstimate {
        attribute position : Real;
        attribute orientation : Real;
        attribute velocity : Real;
        attribute supportMargin : Real;
        attribute leftFootForce : Real;
        attribute rightFootForce : Real;
        attribute perceptionReliable : Boolean;
        attribute balanceReliable : Boolean;
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

    part def NeutralStandingController {
        attribute requiredSupportForce : Real;
        attribute minimumBalanceMargin : Real;
    }

    part def ImuStandingController {
        attribute kpRoll : Real;
        attribute kdRoll : Real;
        attribute kpPitch : Real;
        attribute kdPitch : Real;
    }

    part def CopStandingController;
    part def WeightShiftController;
    part def DisturbanceRecoveryController;
    part def ZmpCoPAnalyzer;
    part def LipmPlanner;
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
        part neutralStandingController : NeutralStandingController;
        part imuStandingController : ImuStandingController;
        part copStandingController : CopStandingController;
        part weightShiftController : WeightShiftController;
        part disturbanceRecoveryController : DisturbanceRecoveryController;
        part zmpCoPAnalyzer : ZmpCoPAnalyzer;
        part lipmPlanner : LipmPlanner;
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
            then action verifyStateAndBalance;
            then action enterOrMaintainStand;
            then action correctImuPosture;
            then action calculateCenterOfPressure;
            then action transferWeightForSupport;
            then action evaluateZmpAndLipm;
            then action estimateRobotState;
            then action planFootsteps;
            then action generateSwingTrajectory;
            then action solveInverseKinematics;
            then action stabilizeWholeBody;
            then action calculateJointCommands;
            then action enforceSafetyLimits;
            then action sendToRobotInterface;
        }

        requirement def Section14LocomotionRequirements {
            requirement def VelocityCommandInterface {
                doc /* Shall accept body-relative vx, vy, and wz commands. */
            }
            requirement def StableStanding {
                doc /* Shall establish and maintain a repeatable neutral standing state. */
            }
            requirement def ImuBalance {
                doc /* Shall use roll/pitch and angular-rate feedback for posture correction. */
            }
            requirement def ContactBalance {
                doc /* Shall use calibrated force or pressure sensors for CoP and support verification. */
            }
            requirement def PushRecovery {
                doc /* Shall increase damping or evaluate a recovery step for disturbances. */
            }
            requirement def SafeStop {
                doc /* Shall stop safely when balance or perception is unreliable. */
            }
            requirement def ZmpSupport {
                doc /* Shall keep the planned ZMP inside the support polygon for normal locomotion. */
            }
            requirement def LipmPlanning {
                doc /* May use LIPM and capture-point planning subject to full-body validation. */
            }
        }

        perform ExecuteLocomotionCycle;
    }
}
