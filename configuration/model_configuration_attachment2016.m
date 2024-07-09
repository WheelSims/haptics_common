%% Attach a configuration to a model. This code must be run for each new model that is designed.

% load('WheelSimConfigRef2016.mat'); % Load the reference configuration. After
% one load, do not load it again, if want to change the configuration
% parameteres for ll models.

model = 'UQAMSimulatorRacingWheelchair'; % Load the model that we want to attach the configuration

freeConfigSet = 'WheelSimConfiguration2016'; % Load the reference configuration to the accesible configure for all models
ConfigurationRef2016 = Simulink.ConfigSetRef;
set_param(ConfigurationRef2016, 'SourceName', 'WheelSimConfiguration2016')
set_param(ConfigurationRef2016, 'Name', 'WheelSimConfig2016')
attachConfigSet(model, ConfigurationRef2016); % Attach the reference model 'WheelSimConfig' to the desired model
setActiveConfigSet(model, 'WheelSimConfig2016'); % Active the configuration
save_system(model);
% referencedConfigObj = getRefConfigSet(ConfigurationRef);
% set_param(referencedConfigObj,'StopTime','60'); % Change parameters of the configuration
