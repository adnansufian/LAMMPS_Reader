function [] = checkPerformance()
% CHECKPERFORMANCE measures the improved speed up from using 'lammpsReader' as
% opposed to using existing matlab functionality (e.g importdata).

	% Add lammpsReader to path
	addpath('../')

	% Set the number of header rows (required for importdata) and the number of
	% data rows and columns (which should be the same as the makeDumpFiles.m
	% script). Set the number of times each case is repeated.
	numHeaderRows = 9;
	numCol = 10;
	numRow = logspace(0, 7, 8);
	numRepeat = 3;

	% Using tic-toc command, extract the time taken to read the dump file using
	% both importdata and lammpsReader.
	time_importdata = zeros(length(numRow), numRepeat);
	time_lammpsReader = zeros(length(numRow), numRepeat);
	for i = 1:length(numRow)
		filename = sprintf('file_%d.dump', numRow(i));

		for j = 1:numRepeat
			tic
			file1 = importdata(filename, ' ', numHeaderRows);
			time_importdata(i, j) = toc;
		end

		for j = 1:numRepeat
			tic
			file2 = lammpsReader(filename);
			time_lammpsReader(i, j) = toc;
		end

		% Check that the data matches between the two methods.
		assert(all(all(abs(file1.data - file2.data)<1e-6)))

		% Display the average time required in each case.
		fprintf('%d rows: importdata ran in %g sec & lammpsReader ran in %g sec\n', ...
			numRow(i), mean(time_importdata(i, :)), mean(time_lammpsReader(i, :)))
	end

	% Generate figure
	figure()
	hold on
	errorbar(numRow*numCol, ...
		mean(time_importdata, 2), ...
		mean(time_importdata, 2) - min(time_importdata, [], 2), ...
		max(time_importdata, [], 2) - mean(time_importdata, 2), ...
		'LineWidth', 1.5)
	errorbar(numRow*numCol, ...
		mean(time_lammpsReader, 2), ...
		mean(time_lammpsReader, 2) - min(time_lammpsReader, [], 2), ...
		max(time_lammpsReader, [], 2) - mean(time_lammpsReader, 2), ...
		'LineWidth', 1.5)
	xlabel('Number of Elements')
	ylabel('Total time (s)')
	set(gca, 'XScale', 'log')
	set(gca, 'YScale', 'log')
	legend({'importdata', 'lammpsReader'}, 'Location', 'SouthEast')
	print -dpng -r150 -f1 checkPerformance
	close all
end

