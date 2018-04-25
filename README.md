# MATLAB Adaptive Filter Framework

The benefits of this code is that it allows you to train
your machine learning models from within the MATLAB command line.
This project not only makes it super easy to implement
new filters, but also implements many new algorithms.

One example is the KMEE algorithm described in 
[7]	S. Zhao, B. Che, and J. Principe, “Kernel Adaptive Filtering with Maximum Correntropy Criterion,” Proceedings of International Joint Conference on Neural Networks, pp. 2012–2017.

## How to use the given filters
From within Matlab command line

```
>> l = lms(); % declare object
>> l.train(.001,X,d,1); % train model (stepsize, input Matrix, output, how often to check learning nmse)
>> l.test(Xtest,dtest); % test data
>> l.plotVal; % will plot learning curve
>> l.plotW; % will plot weights % only applicable to linear models
```

## data format
X in the following is the input matrix, d is the output vector
```
>> l.train(.001,X,d,1);
```
X is an input matrix shaped where each row represents the data sample and the column is the filter order
For example with N samples with a filter order of 4
```
s1.f1 s1.f2 s1.f3 s1.f4
s2.f1 s2.f1 s2.f3 s2.f4
...
sN.f1 sN.f2 sN.f3 nN.f4
```
The included readDataStream converts a stream of data into this format.

## How to add new filters
* Look to LMS or KLMS to see how to implement a new filter type
* If a variant of LMS or KLMS, extend from LMS or QKLMS and follow filter that does the same


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
