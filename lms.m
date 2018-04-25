% Copyright 2018, Samuel Lichtenheld, All rights reserved.

classdef lms < AdaptFilt
	properties
		name
		filterOrder
		stepSize
		w
		w_hist 
		e_hist 
		nmse_hist 
		logger
		val_num
	end

	methods 
		function self = lms(filterOrder, stepSize)
			self.name = 'LMS';
			self.logger = Logger('LMS');

			if nargin == 0
				stepSize=.1;
				filterOrder=1;
			end
		end
		function self = train(self,mu,X,d,val_num)
			%set parameters
			self.stepSize = mu;
			train@AdaptFilt(self,X,d,val_num);
		end
		function d_hat = predict(self,u_n)
			d_hat = u_n'*self.w;
		end 
		function d_vect = predictVect(self,X)
			d_vect = X*self.w;
		end
		function nmse = test(self,X,d)
			e = d - X*self.w;% generate error vector
			nmse = nmse_func(e,X(:,1)); % normalize by inputs
		end
		function plotW(self, newFig)
			if nargin > 1
				figure;
			end
			plot(self.w_hist);
			title({strcat(self.name, ' Weight Tracking'),self.params()});
			xlabel('Training Iteration');
			ylabel('Weight Value');
		end
	end 
	methods (Access = protected)
		function d = params(self)
			d = strcat('Filter Order=', num2str(self.filterOrder),' ,Step Size=', num2str(self.stepSize));
		end
		function self = reset(self)
			%empty tracking history and clear model
			self.nmse_hist = []; % empty old nmse_hist
			self.w_hist = [];
			self.e_hist = [];
		end
		function self = init(self,d_vect,X)
			% init Model
			self.w = randn(self.filterOrder,1); % init to random values
		end
		function updateModel(self,d_vect,X,n)
			x_n = X(n,:)';
			y = self.predict(x_n);
				
			e = d_vect(n)-y; % instantaneous error
			self.e_hist(n) = e;
			self.w = self.w + 2*self.stepSize*e*x_n;
			self.w_hist(n,:) = self.w; 
		end
	end 
end




