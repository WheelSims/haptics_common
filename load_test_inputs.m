%%load_test_inputs
% This code loads all the necessary predefined input signals that will be used in test
% blocks, tuning, and calibration
% This could be run by typing load_test_inputs
% It will load the inputs with the same name as listed below that will be
% used by test blocks

%% Test ForceBlock

load('Force_input1.mat');
load('Force_input2.mat');

%% Test TestDynamicModelRealForce

load('FORCE_TEST_DYNAMIC.mat');

%% Test TestCompleteDynamicModelRealForce

load('TEST_DYNAMIC_Mz_RIGHT.mat')
load('TEST_DYNAMIC_Mz_LEFT.mat')

load('TEST_DYNAMIC_VELOCITY_RIGHT.mat')
load('TEST_DYNAMIC_VELOCITY_LEFT.mat')

load('TEST_DYNAMIC_DESIRED_VELOCITY_RIGHT.mat')
load('TEST_DYNAMIC_DESIRED_VELOCITY_LEFT.mat')

%% Test StabilityController

load('DYNAMIC_DESIRED_ANGLE.mat')
