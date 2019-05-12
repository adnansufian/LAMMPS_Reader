function [] = makeDumpFiles()
% MAKEDUMPFILES generates mock dump files to test the performance of
% LAMMPSREADER compared to existing options in matlab and reading in line by
% line. A total of 8 dump files are created with each row containing 10
% entries, and there being 1e0, 1e1, 1e2, ..., 1e7 rows.
	
	numCol = 10;
	numRow = logspace(0, 7, 8);
	assert(mod(numCol,2)==0)
	for i = 1:length(numRow)
		fprintf('Creating file: file_%d.dump\n', numRow(i))
		
		% Create the header information.
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
		
		% Create the data array. This includes random floats and integers mimicking
		% actual dump output.
		data = (rand(numRow(i)*numCol, 1).^5).*rand(numRow(i)*numCol, 1);
		data(randi(length(data), floor(0.2*length(data)), 1)) = randi(length(data), floor(0.2*length(data)), 1);
		fprintf(fid, '%g %g %g %g %g %g %g %g %g %g\n', data);
		fclose(fid);
	end
end
