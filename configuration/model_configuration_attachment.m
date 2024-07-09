%% Attach a configuration to a model. This code must be run for each new model ( the ones containing sub-blocks) that is designed.

% load('WheelSimConfigRef.mat'); % Load the reference configuration. After
% one load, do not load it again, if want to change the configuration
% parameteres for ll models.

model = 'IRGLMSimulatorSimple'; % Load the model that we want to attach the configuration

% Load the reference configuration to the accesible configure for all models
ConfigurationRef = Simulink.ConfigSetRef;
set_param(ConfigurationRef, 'SourceName', 'WheelSimConfiguration')
set_param(ConfigurationRef, 'Name', 'WheelSimConfig')

attachConfigSet(model, ConfigurationRef); % Attach the reference model 'WheelSimConfig' to the desired model
setActiveConfigSet(model, 'WheelSimConfig'); % Active the configuration
% referencedConfigObj = getRefConfigSet(ConfigurationRef);
% set_param(referencedConfigObj,'StopTime','60'); % Change parameters of the configuration

Simulink.BlockDiagram.propagateConfigSet(model) % Propagate the configuration to the Referenced Models.
