
classdef Logger < handle 
	properties
		name
		loghist
	end
	methods 
		function self = Logger(name) % takes in name of log
			self.loghist = strings(1,1);
			self.name = name;
			self.loghist(1) = name;
		end
		function log(self, string) % adds string to self.loghist
			self.loghist(end+1) = string;
		end
		function print(self)
			for str = self.loghist
				disp(str)
			end
		end
		function clear(self)
			self.loghist = strings(1,1);
			self.loghist(1) = self.name;
		end
	end
end
