function [nmse] = nmse(e_vect,in_vect)
	% calculates the mean square error normalized by the power of the input
	% NMSE = 1/N * sum(e^2) / ( 1/N * sum(in^2) )
	% NMSE = sum(e^2)/sum(in^2)


	if size(e_vect) ~= size(in_vect)
		error('error and input length needs to be same size')
	end

	nmse = sum(e_vect.^2)/sum(in_vect.^2);
	% [n,m] = size(w_hist);
	% num_datapts = length(x)-m;

	% % populate X
	% for k = 1:num_datapts
	% 	X(k,:) = x(k:k+m-1);
	% end

	% % shift d & x
	% d = d(m+1:end); % d(N-m x 1)
	% x = x(1:end-m); % input

	% for i = 1:length(w_hist)
	% 	e = d- X*w_hist(i,:)';% generate error vector
	% 	nmse_hist(i) = (e'*e) / (x'*x);
	% end
	
	% nmse = nmse_hist(end)

end


