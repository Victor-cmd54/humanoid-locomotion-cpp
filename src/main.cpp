#include <algorithm>
#include <iomanip>
#include <iostream>

struct VelocityCommand {
    double vx_mps;
    double vy_mps;
    double wz_radps;
};

struct VelocityLimits {
    double forward_mps;
    double lateral_mps;
    double yaw_radps;
};

VelocityCommand limit_command(const VelocityCommand& command,
                              const VelocityLimits& limits) {
    return {
        std::clamp(command.vx_mps, -limits.forward_mps, limits.forward_mps),
        std::clamp(command.vy_mps, -limits.lateral_mps, limits.lateral_mps),
        std::clamp(command.wz_radps, -limits.yaw_radps, limits.yaw_radps),
    };
}

int main() {
    // Illustrative software limits only; they are not robot hardware settings.
    constexpr VelocityLimits demo_limits{
        .forward_mps = 0.30,
        .lateral_mps = 0.20,
        .yaw_radps = 0.60,
    };
    constexpr VelocityCommand requested{
        .vx_mps = 0.45,
        .vy_mps = 0.10,
        .wz_radps = 0.75,
    };

    const VelocityCommand limited = limit_command(requested, demo_limits);
    std::cout << std::fixed << std::setprecision(2)
              << "Requested (vx, vy, wz): "
              << requested.vx_mps << ", " << requested.vy_mps << ", "
              << requested.wz_radps << '\n'
              << "Limited   (vx, vy, wz): "
              << limited.vx_mps << ", " << limited.vy_mps << ", "
              << limited.wz_radps << '\n';

    if (limited.vx_mps != demo_limits.forward_mps ||
        limited.vy_mps != requested.vy_mps ||
        limited.wz_radps != demo_limits.yaw_radps) {
        std::cerr << "Velocity command limit check failed.\n";
        return 1;
    }
}
