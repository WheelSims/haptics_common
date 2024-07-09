% Run code formatter and unit tests to prepare for code review.
%
% This function uses the MBeautifer project to harmonize the spacings and
% blank lines in all m-files of the project. For example, it aligns for,
% while and if statements with their corresponding end statements, it
% ensures that quote levels match, it fixes missing or double spaces
% between operators, etc.
%
% https://github.com/davidvarga/MBeautifier
%
% It also runs all unit tests using run_testblocks().

init();

disp('Running code formatter...');
addpath('../external/formatter');
MBeautify.formatFiles('.', '*.m');

disp('Running unit tests...');
testblocks();

disp('Preparing for code review done.');
