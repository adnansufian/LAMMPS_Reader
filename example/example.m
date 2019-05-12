clear
close all

% Add directory containing lammpsReader.m to path
addpath('../')

% Read dump file
file = lammpsReader('example.dump');