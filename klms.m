% Copyright 2018, Samuel Lichtenheld, All rights reserved.

classdef klms < AdaptFilt
	properties
		name
		filterOrder % int
		stepSize    % float
		h           % kernel parameter (float)
		a   % struct with params u(vector) and a(scaled value)
		U
		e_hist
		nmse_hist
		val_num
		net_hist
		logger
	end
	methods
		function self = klms(filterOrder, h, stepSize)
			self.name = 'KLMS';
			self.logger = Logger('KLMS');
		end
		% filter Order = Matrix Width, h = KernelSize, mu = StepSize
		function [self, returnval] = train(self,h,mu,X,d,val_num)
			% set parameters
			self.h = h;
			self.stepSize = mu;

			train@AdaptFilt(self,X,d,val_num);
		end 
		function nmse = test(self,X,d)
			num_datapts = length(d); 
			for n = 1:num_datapts
				u_n = X(n,:)'; 
				d_hat = self.predict(u_n);
				e(n) = d(n) - d_hat; %compute error
			end 
			nmse = nmse_func(e,X(:,1)'); % normalize by inputs
		end 
		function plotNet(self, newFig)
			if nargin > 1
				figure;
			end
			plot(self.net_hist);
			title({strcat(self.name, ' Validation Network Size History'),self.params()});
			xlabel('Training Iteration');
			ylabel('Network Size');
		end
		function d_hat = predict(self,u_n)
			if length(u_n) ~= self.filterOrder
				error('input needs to be of length filterOrder')
			end
			d_hat = self.a*(exp(-self.h*vecnorm(self.U - u_n)))';
		end 

	end
	methods (Access = protected)
		function self = reset(self)
			self.a = [];
			self.U = [];
			self.e_hist = [];
			self.nmse_hist = []; % empty old nmse_hist
			self.net_hist = [];
		end
		function init(self,d_vect,X)
			self.a(1) = self.stepSize*d_vect(1); % need initial a
			self.U(:,1) = X(1,:)'; % first input
			self.e_hist(1) = d_vect(1);
		end
		function updateModel(self,d_vect,X,n) % d is a vector!
			u_n =  X(n,:)'; % 1xModelOrder 
			d_hat = self.predict(u_n); 	% prediction
			e = d_vect(n) - d_hat; 			%compute error

			self.e_hist(n) = e; 		%store error_history
			self.a(end+1) = self.stepSize*e; % add new center scale
			self.U(:,end+1) = u_n; %add new center
		end
		function updateNetHist(self) % callback for kernel methods
			self.net_hist(end+1)=length(self.a); 
		end
		function d = params(self)
			d = strcat('Filter Order=', num2str(self.filterOrder),' ,Step Size=', num2str(self.stepSize),', Kernel Param=', num2str(self.h));
		end
		
	end 
end