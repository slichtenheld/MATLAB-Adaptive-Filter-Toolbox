

classdef (Abstract) AdaptFilt < handle
	properties(Abstract)
		name
		nmse_hist
		val_num
		e_hist
		logger
	end
	methods (Abstract)
		self = test(self,x,d)
		d_hate = predict(self,u_n)
	end
	methods (Abstract, Access=protected)
		d = params(self)
		self = reset(self)
		self = init(self,d_vect,X)
		self = updateModel(self,d_vect,X,n);
	end
	methods
		function self = train(self,X,d_vect,val_num)
			self.logger.clear();
			self.val_num = val_num;
			self.filterOrder = size(X,2);
			num_datapts = length(d_vect);
			
			%empty tracking history and clear model
			self.reset();

			% init Model
			self.init(d_vect,X);

			for n = 1:num_datapts % for each output
				
				self.updateModel(d_vect,X,n);

				% FIXME: add if val_num=0 continue
				
				% Learning NMSE = only test on data trained so far
				if mod(n,val_num)==0
					self.nmse_hist(int16(n/val_num)+mod(n,val_num)) = self.test(X(1:n,:),d_vect(1:n));
					self.logger.log(sprintf('Learning NMSE on training iteration: %i| NMSE = %.3f' , n,self.nmse_hist(end)));
				elseif n==num_datapts
					self.nmse_hist(int16(n/val_num)+1) = self.test(X(1:n,:),d_vect(1:n));
					self.logger.log(sprintf('Learning NMSE on training iteration: %i| NMSE = %.3f' , n,self.nmse_hist(end)));
				end
				self.updateNetHist();
			end
			self.logger.log(sprintf('Final Learning NMSE: %.4f' , self.nmse_hist(end)));
			disp(strcat('Final Learning NMSE: ', num2str(self.nmse_hist(end))))
		end
		function plotVal(self, newFig)
			if nargin > 1
				figure;
			end
			plot([1:self.val_num:self.val_num*length(self.nmse_hist)],self.nmse_hist);
			title({strcat(self.name, ' Learning NMSE History'),self.params()});
			xlabel('Training Iteration');
			ylabel('NMSE');
		end
		function plotErr(self, newFig)
			if nargin > 1
				figure;
			end
			plot(self.e_hist);
			title({strcat(self.name, ' Error History'),self.params()});
			xlabel('Training Iteration');
			ylabel('Error');
		end
		function plotAll(self)
			self.plotVal(1);
			self.plotErr(1);
		end
		function logs(self, string)
			self.logger.print()
		end
	end
	methods (Access=protected)
		function updateNetHist(self) % callback for kernel methods
		end
	end
end
