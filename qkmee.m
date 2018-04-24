classdef qkmee < kmee
    properties
        quantize_e
        past_centers
    end
    methods
        function self = qkmee(filterOrder, h, stepSize,L,MEE)
            self.name = 'QKMEE';
            self.logger = Logger('QKMEE');
        end
        function self = train(self,qe,L,MEE,h,mu,X,d_vect,val_num)
            self.past_centers = zeros(1,L);
            self.past_centers(L) = 1;
            self.quantize_e = qe;
            train@kmee(self,L,MEE,h,mu,X,d_vect,val_num);
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
                % find closest center for past jth input
                d = self.e_hist(n) - self.e_hist(j);
                pc = j-n+self.L+1;
                self.a(self.past_centers(pc)) = self.a(self.past_centers(pc)) ...
                            - (self.stepSize/self.L) * (d/self.MEE^2) ...
                            * exp(-d^2/(2*self.MEE^2));
            end

            % Quantization of newest (nth) input
            [dis,idx] = min(vecnorm(self.U - X(n,:)')); % compute distance to all centers, find minimum and idx thereof
            self.past_centers(1:self.L-1) = self.past_centers(2:self.L);
            
            % Calculate a(newest)
            sum = 0;
            for j = max(1,n-self.L+1):n-1 % change to l
                d = self.e_hist(n) - self.e_hist(j);
                sum = sum + d*exp(-d^2/(2*self.MEE^2));
            end 
            newA = self.stepSize/(self.L*self.MEE^2)*sum;

            % Either add new center or update old weight with a(newest)
            if dis < self.quantize_e % update a and leave U alone!
                self.a(idx)=self.a(idx) + newA;
                self.past_centers(self.L) = idx;
            else % same as kmee, update U
                self.a(end+1)=newA;
                self.U(:,end+1) = X(n,:)'; %add new center
                self.past_centers(self.L) = length(self.a);
            end
        end
        function d = params(self)
            d = strcat(params@kmee(self),', Quantization Thresh=', num2str(self.quantize_e)); 
        end
    end
end

