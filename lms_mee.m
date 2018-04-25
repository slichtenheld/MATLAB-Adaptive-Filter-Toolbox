% Copyright 2018, Samuel Lichtenheld, All rights reserved.

classdef lms_mee < lms
	properties
		L
		MEE
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
	end 
	methods (Access = protected)

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
		function d = params(self)
			d = strcat('Filter Order=', num2str(self.filterOrder),' ,Step Size=', num2str(self.stepSize));
		end
	end 
end




