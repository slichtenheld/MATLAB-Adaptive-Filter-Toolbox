# MATLAB Adaptive Filter Framework

The benefits of this code is that it allows you to train
your machine learning models from within the MATLAB command line.
This project not only makes it super easy to implement
new filters, but also implements many new algorithms.

One example is the KMEE algorithm described in 
[7]	S. Zhao, B. Che, and J. Principe, “Kernel Adaptive Filtering with Maximum Correntropy Criterion,” Proceedings of International Joint Conference on Neural Networks, pp. 2012–2017.

## How to use the framework
From within Matlab command line
'''
>> l = lms(); % declare object
>> l.train(.001,X,d,1); % train model (stepsize, input Matrix, output, how often to check learning nmse)
>> l.test(Xtest,dtest); % test data
>> l.plotVal; % will plot learning curve
>> l.plotW; % will plot weights % only applicable to linear models
'''



## Included Algorithms
* lms
* rls
* lmee
* klms
* kmcc
* kmee qip
* kmee shannon
* qklms
* qkmcc
* qkmee qip
