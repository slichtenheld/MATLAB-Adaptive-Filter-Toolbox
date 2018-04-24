
classdef qkmcc <   qklms
    properties
        mcc
    end
    methods
        function self = qkmcc(filterOrder, h, stepSize, quantize_e)
            % self@klms(filterOrder,stepSize,h);
            % self.quantize_e = quantize_e;
            self.name = 'QKMCC';
            self.logger = Logger('QKMCC');
        end
        function self = train(self,mcc,qe,h,mu,X,d,val_num)
            self.mcc = mcc;
            train@qklms(self,qe,h,mu,X,d,val_num);
        end

    end
    methods (Access=protected)
        % function initCenter(self,d1,u_n)
        % end
        function updateModel(self,d_vect,X,n)
            u_n =  X(n,:)'; % 1xModelOrder 
            d_hat = self.predict(u_n);  % prediction
            e = d_vect(n) - d_hat;          %compute error


            
            [dis,idx] = min(vecnorm(self.U - u_n)); % compute distance to all centers, find minimum and idx thereof
            if dis < self.quantize_e % update a and leave U alone!
                self.a(idx) = self.a(idx) + self.stepSize ... %/ ( ((2*pi())^(1/2)) * (self.mcc^3) ) ...
                    * exp(-(e^2)/(2*self.mcc^2))*e;
            else % same as klms
                self.a(end+1) = self.stepSize ...% /  ( ((2*pi())^(1/2)) * (self.mcc^3) ) ...
                    * exp(-(e^2)/(2*self.mcc^2))*e; % add new center scale
                self.U(:,end+1) = u_n; %add new center
            end 
            self.dis_hist(end+1) = dis;
        end
        function d = params(self)
            d = strcat(params@qklms(self),', MCC Variance=',num2str(self.mcc));
        end
    end
end