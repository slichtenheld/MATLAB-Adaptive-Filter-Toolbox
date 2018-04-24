classdef kmcc < klms
    properties
        mcc
    end
    methods
        function self = kmcc()
            self.name = 'KMCC';
            self.logger = Logger('KMCC');
        end
        function self = train(self,mcc,h,mu,X,d_vect,val_num)
            self.mcc = mcc;
            train@klms(self,h,mu,X,d_vect,val_num);
        end
    end
    methods (Access = protected)
        function updateModel(self,d_vect,X,n) % d is a vector!
            u_n =  X(n,:)'; % 1xModelOrder 
            d_hat = self.predict(u_n);  % prediction
            e = d_vect(n) - d_hat;          %compute error

            self.e_hist(n) = e;        %store error_history
            self.a(end+1) = self.stepSize  ... %
                    * exp(-(e^2)/(2*self.mcc^2))*e; % add new center scale
            self.U(:,end+1) = u_n; %add new center
        end
    end
end

