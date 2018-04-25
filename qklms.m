% Copyright 2018, Samuel Lichtenheld, All rights reserved.

classdef qklms < klms
    properties
        quantize_e
        dis_hist
    end
    methods
        function self = qklms(filterOrder, h, stepSize, quantize_e)
            self.name = 'QKLMS';
            self.logger = Logger('QKLMS');
        end
        function self = train(self,qe,h,mu,X,d,val_num)
            self.quantize_e = qe;
            train@klms(self,h,mu,X,d,val_num);
            self.logger.log(sprintf('Network Size: %d' , self.net_hist(end)));

        end
        function plotAll(self)
            plotAll@AdaptFilt(self);
            self.plotNet(1);
        end
    end
    methods (Access=protected)
        function updateModel(self,d_vect,X,n)
            u_n =  X(n,:)'; % 1xModelOrder 
            d_hat = self.predict(u_n);  % prediction
            e = d_vect(n) - d_hat;      %compute error
            
            [dis,idx] = min(vecnorm(self.U - u_n)); % compute distance to all centers, find minimum and idx thereof
            if dis < self.quantize_e % update a and leave U alone!
                self.a(idx) = self.a(idx) + self.stepSize*e;
            else % same as klms
                self.a(end+1) = self.stepSize*e; % add new center scale
                self.U(:,end+1) = u_n; %add new center
            end 
            self.dis_hist(end+1) = dis;
        end
        function d = params(self)
            d = strcat(params@klms(self),', Quantization Distance=',num2str(self.quantize_e));
        end
    end
end