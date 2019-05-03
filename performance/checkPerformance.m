function [] = checkPerformance()
	% CHECKPERFORMANCE measures the improved speed up from using 'lammpsReader' as
	% opposed to using existing matlab functionality.

	% The methods compared include:
	% (i) lammpsReader
	% (ii) importdata

	addpath('../')

	numHeaderRows = 9;
	numRow = logspace(0, 7, 8);
	time = zeros(length(numRow), 2);
	for i = 1:length(numRow)
		filename = sprintf('file_%d.dump', numRow(i));

		tic
		file1 = importdata(filename, ' ', numHeaderRows);
		time(i, 1) = toc;

		tic
		file2 = lammpsReader(filename);
		time(i, 2) = toc;

		assert(all(all(abs(file1.data - file2.data)<1e-6)))

		fprintf('%d rows: importdata ran in %g sec & lammpsReader ran in %g sec\n', numRow(i), time(i, 1), time(i, 2))
	end

	figure()
	hold on
	plot(numRow, time(:, 1), 'bs-')
	plot(numRow, time(:, 2), 'ro-')
	xlabel('Number of Rows')
	ylabel('Total time')
	set(gca, 'XScale', 'log')
	legend({'importdata', 'lammpsReader'}, 'Location', 'NorthWest')
	print -dpng -r100 -f1 checkPerformance
	close all
end

