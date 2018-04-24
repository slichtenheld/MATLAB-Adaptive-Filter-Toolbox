
classdef rls < lms
	properties
		alpha
		R_inv
	end

	methods 
		function self = rls(filterOrder, stepSize)
			self.name = 'RLS';
			self.logger = Logger('RLS');
		end
		function self = train(self,alpha,mu,X,d,val_num)
			%set parameters
			self.alpha = alpha;
			train@lms(self,mu,X,d,val_num);
		end
	end 
	methods (Access = protected)
		function self = init(self,d_vect,X)
			% init Model
			self.w = randn(self.filterOrder,1); % init to random values
			sigma = sqrt(var(d_vect));
			self.R_inv = 100*sigma*eye(self.filterOrder);
		end
		function updateModel(self,d_vect,X,n)
			x_n = X(n,:)';
			y = self.predict(x_n);
			e = d_vect(n)-y; % instantaneous error
			
			Z = self.R_inv*x_n;
			q = x_n'*Z;
			self.w = self.w + e/(self.alpha+q)*Z;
			self.R_inv = (1/self.alpha)	* ( self.R_inv - (Z*Z')/(self.alpha+q) );


			% record metrics
			self.e_hist(n) = e;			
			self.w_hist(n,:) = self.w; 
		end
				function d = params(self)
			d = strcat('Filter Order=', num2str(self.filterOrder),' ,Step Size=', num2str(self.stepSize));
		end
	end 
end




