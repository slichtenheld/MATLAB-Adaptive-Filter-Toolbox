% Copyright 2018, Samuel Lichtenheld, All rights reserved.

function [x,y,q] = datGen(numDataPts,delay)

	% input signal is Gaussian random with zero mean and unit variance
	y = randn(numDataPts,1);

	% linear filter
	t = -0.8*y+0.7*[0;y(1:end-1)];

	% non linear filter
	q = t + 0.25*t.^2 + 0.11*t.^3;

	% q is corrupted by 15dB AWGN
	x = awgn(q,15);

	% desired response is delayed
	y = [zeros(delay,1);y(1:end-delay)];