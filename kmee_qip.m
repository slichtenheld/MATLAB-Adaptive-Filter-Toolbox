classdef kmee_qip < klms
    properties
        L % window size
        MEE % mee kernel size
    end
    methods
        function self = kmee_qip(filterOrder, h, stepSize,L,MEE)
            self.name = 'KMEE QIP';
            self.logger = Logger('KMEE QIP');
        end
        function self = train(self,L,MEE,h,mu,X,d_vect,val_num)
            self.L = L;
            self.MEE = MEE;
            train@klms(self,h,mu,X,d_vect,val_num);
        end
    end
    methods (Access = protected)
        function updateModel(self,d_vect,X,n) % d is a vector!

            % compute past L errors
            for j = max(1,n-self.L+1):n
                self.e_hist(j) = d_vect(j) - self.predict(X(j,:)');
            end
            
            % update n-L+1:n-1 center weights
            for j = max(1,n-self.L+1):n-1
                %self.e_hist(j) = d_vect(j) - self.predict(X(j,:)');
                d = self.e_hist(n) - self.e_hist(j);
                self.a(j) = self.a(j) ...
                            - (self.stepSize/self.L) * (d/self.MEE^2) ...
                            * exp(-d^2/(2*self.MEE^2));
            end

            % update most recent weight
            sum = 0;
            for j = max(1,n-self.L+1):n-1 % change to l
                d = self.e_hist(n) - self.e_hist(j);
                sum = sum + d*exp(-d^2/(2*self.MEE^2));
            end 
            self.a(end+1)=self.stepSize/(self.L*self.MEE^2)*sum;
            
            self.U(:,end+1) = X(n,:)'; %add new center

        end
        function d = params(self)
            d = strcat(params@klms(self),', MEE Kernel=',num2str(self.MEE),', L=',num2str(self.L));
        end
    end
end

