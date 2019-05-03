function [] = makeDumpFiles()
% MAKEDUMPFILES generates mock dump files to test the performance of
% LAMMPSREADER compared to existing options in matlab and reading in line by
% line. A total of 10 dump files are created with each row containing 10
% entries, and there being 1e0, 1e1, 1e2, ..., 1e9 rows.
	
	numCol = 10;
	numRow = logspace(0, 7, 8);
	for i = 1:length(numRow)
		fid = fopen(sprintf('file_%d.dump', numRow(i)), 'w+');
		fprintf(fid, 'ITEM: TIMESTEP\n');
		fprintf(fid, '7000000\n');
		fprintf(fid, 'ITEM: NUMBER OF ENTRIES\n');
		fprintf(fid, '%d\n', numRow(i));
		fprintf(fid, 'ITEM: BOX BOUNDS pp pp pp\n');
		fprintf(fid, '0 0.0131809\n');
		fprintf(fid, '0 0.0131534\n');
		fprintf(fid, '0 0.0131559\n');
		fprintf(fid, 'ITEM: ENTRIES c_pair[1] c_pair[2] c_pair[3] c_pair[4] c_pair[5] c_pair[6] c_pair[7] c_pair[8] c_pair[9] c_pair[10]\n');
		fprintf(fid, '%f %f %f %f %f %f %f %f %f %f\n', rand(numRow(i), numCol));
		fclose(fid);
	end
end
