classdef kmee_shannon < klms
    properties
        L % window size
        MEE % mee kernel size
    end
    methods
        function self = kmee_shannon(filterOrder, h, stepSize,L,MEE)
            self.name = 'KMEE (Shannon)';
            self.logger = Logger('KMEE (Shannon)');
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
            quot = 0;
            for l = max(1,n-self.L+1):n
                quot = quot + exp(-(self.e_hist(n)-self.e_hist(l))^2/(2*self.MEE^2));
            end 
            for j = max(1,n-self.L+1):n-1
                %self.e_hist(j) = d_vect(j) - self.predict(X(j,:)');
                d = self.e_hist(n) - self.e_hist(j);
                self.a(j) = self.a(j) ...
                            - ( self.stepSize * (d/self.MEE^2) ...
                            * exp(-d^2/(2*self.MEE^2))) ...
                            /quot;
            end

            % update most recent weight
            top = 0; % until n-1
            bot = 0; % until n
            for l = max(1,n-self.L+1):n-1
                d = self.e_hist(n) - self.e_hist(l);
                temp = exp(-d^2/(2*self.MEE^2));
                
                bot = bot + temp;
                top = top + d*temp; 
            end 
            bot = bot + 1; % exp( e(n) - e(n) ) = 1; 
            
            self.a(end+1)=(self.stepSize/self.MEE^2)*top/bot;
            
            self.U(:,end+1) = X(n,:)'; %add new center

        end
        function d = params(self)
            d = strcat(params@klms(self),', MEE Kernel=',num2str(self.MEE),', L=',num2str(self.L));
        end
    end
end

