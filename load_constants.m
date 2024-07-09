function load_constants()
% LoadConstants

% This function defines the simulator.constants structure
% It could be run by typing load_constants


global simulator


simulator.TimeStep = 1 / 2000


% % Constants for Hardware Enable
simulator.Constants.Hardware.Enable = 0;


% Constants for Simple Dynamic model ( Racing Wheelchair)
simulator.Sim.Dynamics.Mass = 79.8 + 16.8; %kg
simulator.Sim.Dynamics.Friction.Coefficient = 0.0113; %N/kg


% Constants for Complete Dynamic model
simulator.Sim.Dynamics.vertical_moment_of_inertia = 8; %kg.m2

% Constants for New Racing Dynamic model
simulator.Sim.Dynamics.wind_speed = 1; %m/s

% % Butterworth Filter Design
%
Ts = simulator.TimeStep;
Fs = 1 / Ts;
% F_pass1=120;
% [num1,den1] = butter(1,F_pass1/(Fs/2),'s');
% simulator.Positionfilter.num=num1;
% simulator.Positionfilter.den=den1;

% Butterworth Filter Design for Force Sensor output
F_pass_Force = 10;
[num2, den2] = butter(8, F_pass_Force*2*pi, 's');
simulator.Forcefilter.num = num2;
simulator.Forcefilter.den = den2;


% Filter Design for Motor analog output (Speed)
F_pass_Velocity = 20;
[num3, den3] = besself(2, F_pass_Velocity*2*pi);
simulator.Velocityfilter.num = num3;
simulator.Velocityfilter.den = den3;

% Butterworth Filter Design for Force Stability Observer
F_pass_Stability_Force = 10;
[nhighforce, dhighforce] = butter(2, F_pass_Stability_Force*2*pi, 'high', 's');
simulator.Stabilityforcehigh.num = nhighforce;
simulator.Stabilityforcehigh.den = dhighforce;

[nlowforce, dlowforce] = butter(2, F_pass_Stability_Force*2*pi, 'low', 's');
simulator.Stabilityforcelow.num = nlowforce;
simulator.Stabilityforcelow.den = dlowforce;


[nderivforce, dderiveforce] = butter(2, 0.2*2*pi, 'low', 's');
simulator.Derivativeforce.num = nderivforce;
simulator.Derivativeforce.den = dderiveforce;

% Force Stability Controller weight

simulator.Stabilityforcecontroller.sensitivity = 2;

% Butterworth Filter Design for Speed Stability Observer
F_pass_Stability_Speed = 10;
[nhighspeed, dhighspeed] = butter(2, F_pass_Stability_Speed*2*pi, 'high', 's');
simulator.Stabilityspeedhigh.num = nhighspeed;
simulator.Stabilityspeedhigh.den = dhighspeed;

[nlowspeed, dlowspeed] = butter(2, F_pass_Stability_Speed*2*pi, 'low', 's');
simulator.Stabilityspeedlow.num = nlowspeed;
simulator.Stabilityspeedlow.den = dlowspeed;


[nderivspeed, dderivespeed] = butter(2, 0.2*2*pi, 'low', 's');
simulator.Derivativespeed.num = nderivspeed;
simulator.Derivativespeed.den = dderivespeed;

% Speed Stability Controller weight

simulator.Stabilityspeedcontroller.sensitivity = 2;

% Butterworth Filter Design for Position Stability Observer
F_pass_Stability_Position = 5;
[nhighposition, dhighposition] = butter(2, F_pass_Stability_Position*2*pi, 'high', 's');
simulator.Stabilitypositionhigh.num = nhighposition;
simulator.Stabilitypositionhigh.den = dhighposition;

[nlowposition, dlowposition] = butter(2, F_pass_Stability_Position*2*pi, 'low', 's');
simulator.Stabilitypositionlow.num = nlowposition;
simulator.Stabilitypositionlow.den = dlowposition;


[nderivposition, dderiveposition] = butter(2, 5*2*pi, 'low', 's');
simulator.Derivativeposition.num = nderivposition;
simulator.Derivativeposition.den = dderiveposition;

% Position Stability Controller weight

simulator.Stabilitypositioncontroller.sensitivity = 0.1;

% Controller constants

simulator.MotorctrlR.KP = 7;
simulator.MotorctrlR.KI = 5;
simulator.MotorctrlR.Kd = 0;
simulator.MotorctrlR.Kff = 0;
simulator.MotorR.KT = 4.03; % Motor specification
simulator.Constants.Minspeed = 0.5; %rad/s % Ninimal wheeling speed for activating control loop


simulator.Ctrl.EmergencyStopEnable = 1;


% Geometry Invacare Ultralight A4

simulator.Constants.rcyl = 0.1359; %m
simulator.Constants.rSW = 0.3; %m
simulator.Constants.rH = 0.275; %m

simulator.Constants.WHEEL_RADIUS = 0.350; %m
simulator.Constants.WHEEL_DISTANCE = 0.5325; %m
simulator.Constants.CASTERWHEEL_DISTANCE = 0.455; %m
simulator.Constants.WHEELCHAIR_LENGTH = 0.475; %m
simulator.Constants.CASTER_TRAIL = 0.04; %m


% Calculating Motor to Wheel Speed Constants UQAM
simulator.Constants.MOTOR_RADIUS = 0.115; %m
simulator.Constants.ROLLER_RADIUS = 0.088; %m
simulator.Constants.SHAFT_RADIUS = 0.025; %m
simulator.Constants.MOTOR_TO_WHELL_SPEED = (simulator.Constants.MOTOR_RADIUS * simulator.Constants.ROLLER_RADIUS) / ...
    (simulator.Constants.WHEEL_RADIUS * simulator.Constants.SHAFT_RADIUS);
simulator.Constants.VOLTS_To_RADIAN = 28.3 * 0.10472;


% Three Axis Force Sensor Charactersitics
simulator.Constants.ARM.L = 0.1; %m
simulator.Constants.ARM.R = 0.1; %m
simulator.Constants.Gain.Fx = 145.022116;
simulator.Constants.Gain.Fy = -144.701048;
simulator.Constants.Gain.Mz = 3.58057054;


% Maximal allowed wheeling speed before emergency stop
simulator.Constants.Maxspeed = 20; %rad/s


return
