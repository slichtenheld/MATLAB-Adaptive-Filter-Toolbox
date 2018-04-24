function [nmse] = nmse(e_vect,in_vect)
	% calculates the mean square error normalized by the power of the input
	% NMSE = 1/N * sum(e^2) / ( 1/N * sum(in^2) )
	% NMSE = sum(e^2)/sum(in^2)

	if size(e_vect) ~= size(in_vect)
		size(e_vect)
		size(in_vect)
		error('error and input length needs to be same size')
	end

	nmse = sum(e_vect.^2)/sum(in_vect.^2);

end


