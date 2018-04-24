

function [input_mtrx,output] = readDataStream(stream,filterOrder)

	% takes in data stream x1;x2;x3;x4;x5...xN where stream is a column vector
	% returns in(1),in(2),in(3) and out1, out2, out3 
	% where in() represents a vector, so in is a matrix

	% make sure stream is column vector, if not make it column vector
	if size(stream,2) ~= 1
		stream = stream';
	end 

	% calculate number of datapoints
	num_datapts = length(stream) - filterOrder;

	input_mtrx = zeros(num_datapts,filterOrder);

	for i = 1:filterOrder
		input_mtrx(:,i) = stream(i:num_datapts+i-1);
	end

	output = stream(filterOrder+1:end);

end





