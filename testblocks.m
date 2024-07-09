function testblocks()

%% Running Test Blocks

%This function runs the offline test for different designed blocks.
%The purpose of these tests is to be sure that every block is kept intact and working as intended.
%You could just type testblocks to run this code.

% % Author : Ateayeh Bayat
% % Date : 2021-2023

%% Globals

global simulator

%% Define Constants

load_constants

%% Test Blocks

%% Test DynamicModel Block

simulator.Sim.Dynamics.Mass = 90;
simulator.Sim.Dynamics.Friction.Coefficient = 0.0138; %N/kg
load_system('TestDynamicModel')
sim('TestDynamicModel');

for i = 1:3
    output_dynamics(i) = yout.getElement(i);
end

for i = 1:3
    output_values_dynamics(:, i) = output_dynamics(1, i).Values.Data;
end

rms_accelration_simulink = 4.052e-1;
rms_accelration_output = rms(output_values_dynamics(:, 1));
accelration_error = abs(rms_accelration_simulink-rms_accelration_output);
accelration_error_tolerance = rms_accelration_simulink * 0.01;
assert(accelration_error <= accelration_error_tolerance, 'Dynamic Model Accelration Test Did not Pass')

rms_velocity_simulink = 9.307e-2;
rms_velocity_output = rms(output_values_dynamics(:, 2));
velocity_error = abs(rms_velocity_simulink-rms_velocity_output);
velocity_error_tolerance = rms_velocity_simulink * 0.01;
assert(velocity_error <= velocity_error_tolerance, 'Dynamic Model Velocity Test Did not Pass')

rms_position_simulink = 4.143e-2;
rms_position_output = rms(output_values_dynamics(:, 3));
position_error = abs(rms_position_simulink-rms_position_output);
position_error_tolerance = rms_position_simulink * 0.01;
assert(position_error <= position_error_tolerance, 'Dynamic Model Position Test Did not Pass')

disp('Dynamic Model Test Passed Successfully')

%% Test CompleteDynamicModel Block

load('TEST_DYNAMIC_Mz_RIGHT.mat')
load('TEST_DYNAMIC_Mz_LEFT.mat')

load('TEST_DYNAMIC_VELOCITY_RIGHT.mat')
load('TEST_DYNAMIC_VELOCITY_LEFT.mat')

load('TEST_DYNAMIC_DESIRED_VELOCITY_RIGHT.mat')
load('TEST_DYNAMIC_DESIRED_VELOCITY_LEFT.mat')

simulator.Sim.Dynamics.Mass = 98.4;

load_system('TestCompleteDynamicModel')
sim('TestCompleteDynamicModel');

for i = 1:6
    output_complete_dynamics(i) = yout.getElement(i);
end

for i = 1:6
    output_values_complete_dynamics(:, i) = output_complete_dynamics(1, i).Values.Data;
end

rms_right_velocity_simulink = rms(TEST_DYNAMIC_DESIRED_VELOCITY_RIGHT);
rms_right_velocity_output = rms(output_values_complete_dynamics(:, 2));
right_velocity_error = abs(rms_right_velocity_simulink-rms_right_velocity_output);
right_velocity_error_tolerance = rms_right_velocity_simulink * 0.01;
assert(right_velocity_error <= right_velocity_error_tolerance, 'Complete Dynamic Model Right Velocity Test Did not Pass')

rms_left_velocity_simulink = rms(TEST_DYNAMIC_DESIRED_VELOCITY_LEFT);
rms_left_velocity_output = rms(output_values_complete_dynamics(:, 5));
left_velocity_error = abs(rms_left_velocity_simulink-rms_left_velocity_output);
left_velocity_error_tolerance = rms_left_velocity_simulink * 0.01;
assert(left_velocity_error <= left_velocity_error_tolerance, 'Complete Dynamic Model Left Velocity Test Did not Pass')

disp('Complete Dynamic Model Test Passed Successfully')

%% Test_ForceFilter Block

load_system('TestForceFilter')
sim('TestForceFilter');

for i = 1:2
    output_force(i) = yout.getElement(i);
end

for i = 1:2
    output_values_force(:, i) = output_force(1, i).Values.Data;
end

filter_error = abs(rms(output_values_force(:, 2))-rms(output_values_force(:, 1)));
filter_error_tolerance = rms(output_values_force(:, 1)) * 0.01;
assert(filter_error <= filter_error_tolerance, 'Filter Block Test Did not Pass')

disp('Filter Block Test Passed Successfully')

%% Test ForceBlock

load('Force_input1.mat')
load('Force_input2.mat')
load_system('TestForce')
sim('TestForce');

force_value = 35;


output_force_sensor = yout.signals(1).values;

rms_force_sensor_output = rms(output_force_sensor);
force_error = abs(force_value-rms_force_sensor_output);
force_error_tolerance = force_value * 0.05;
assert(force_error <= force_error_tolerance, 'Force Block Test Did not Pass')

disp('Force Block Test Passed Successfully')

%% Test_StabilityObserver Block

load_system('TestStabilityObserver')
simulator.StabilityObserverTest.command = 1;
sim('TestStabilityObserver');

for i = 1:3
    simulator.StabilityObserverTest.command = i;
    sim('TestStabilityObserver');
    if simulator.StabilityObserverTest.command == 1; % Low frequency input
        index_value = 0.0572; % rms of the instability index in the block
    else if simulator.StabilityObserverTest.command == 2; % High frequency input
            index_value = 0.5842;
    else if simulator.StabilityObserverTest.command == 3; % Real Force input
            index_value = 0.2710;
    end
    end
    end
    output_stabilityobserver = yout.getElement(1);

    output_values_stabilityobserver = output_stabilityobserver.Values.Data;

    rms_stabilityobserver_output = rms(output_values_stabilityobserver);
    stabilityobserver_error = abs(index_value-rms_stabilityobserver_output);
    stabilityobserver_error_tolerance = index_value * 0.05;
    assert(stabilityobserver_error <= stabilityobserver_error_tolerance, 'Stability Observer Block Test Did not Pass')
end

disp('Stability Observer Block Test Passed Successfully')

%% Test_StabilityController Block

load('DYNAMIC_DESIRED_ANGLE.mat')

load_system('TestStabilityController')
simulator.StabilityControllerTest.command = 1;
sim('TestStabilityController');
Kp_initial = 10;

for i = 1:2
    simulator.StabilityObserverTest.command = i;
    sim('TestStabilityController');
    if simulator.StabilityControllerTest.command == 1; % Position Command
        Kp = 10;
    else if simulator.StabilityControllerTest.command == 2; % Force Command
            Kp = 9.9538; %rms of the changing Kp
    end
    end
    for i = 1:2

        output_stabilitycontroller(i) = yout.getElement(i);
    end

    for i = 1:2

        output_values_stabilitycontroller(:, i) = output_stabilitycontroller(1, i).Values.Data;
    end

    rms_stabilitycontroller_output = rms(output_values_stabilitycontroller(:, 2));
    stabilitycontroller_error = abs(Kp-rms_stabilitycontroller_output);
    stabilitycontroller_error_tolerance = Kp * 0.01;
    assert(stabilitycontroller_error <= stabilitycontroller_error_tolerance, 'Stability Controller Block Test Did not Pass')
end

disp('Stability Controller Block Test Passed Successfully')
