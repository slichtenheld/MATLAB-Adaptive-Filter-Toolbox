
classdef lms_mee < AdaptFilt
	properties
		name
		filterOrder
		stepSize
		L
		MEE
		w
		w_hist 
		e_hist 
		nmse_hist 
		logger
		val_num
	end

	methods 
		function self = lms_mee(filterOrder, stepSize)
			self.name = 'LMS MEE';
			self.logger = Logger('LMS MEE');
		end
		function self = train(self,L,MEE,mu,X,d,val_num)
			%set parameters
			self.L = L;
			self.MEE = MEE;
			self.stepSize = mu;
			train@AdaptFilt(self,X,d,val_num);
		end
		function d_hat = predict(self,u_n)
			d_hat = u_n'*self.w;
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

			% compute past L errors
            for j = max(1,n-self.L+1):n
                self.e_hist(j) = d_vect(j) - self.predict(X(j,:)');
            end

            sum = 0;
            for i = max(1,n-self.L+1):n-1
            	for j = max(1,n-self.L+1):n-1
            		sum = sum + ...
            			exp(-(self.e_hist(j)-self.e_hist(i))^2/(2*self.MEE^2)) * ...
            			(self.e_hist(j)-self.e_hist(i)) * ...
            			(X(j,:)-X(i,:))';
            	end
            end

            self.w = self.w+self.stepSize/(2*self.L^2*self.MEE^2)*sum;
            self.w_hist(n,:) = self.w; 

		end
	end 
end




