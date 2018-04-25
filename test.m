% Copyright 2018, Samuel Lichtenheld, All rights reserved.

[in,out]=datGen(1000,2);


d = out(6:end); % shift because model order 5

X = readDataStream(in,5);

fprintf('training LMS...')
lms = lms();
lms.train(.001,X,d,1);
lms.plotVal(1)
lms.plotW(1)

fprintf('training RLS...')
rls = rls();
rls.train(.99,.001,X,d,1);

fprintf('training LMEE...')
lmee = lms_mee();
lmee.train(10,5,.1,X,d,1);

fprintf('training KLMS...')
klms = klms();
klms.train(.5,.1,X,d,10);

fprintf('training KMCC...')
kmcc = kmcc();
kmcc.train(1,.5,.1,X,d,10);

fprintf('training KMEE QIP...')
kmeeq = kmee_qip();
kmeeq.train(50,1,.5,.5,X,d,10);

fprintf('training KMEE Shannon...')
kmees = kmee_shannon();
kmees.train(50,1,.5,.5,X,d,10);

fprintf('training QKLMS...')
q = qklms();
q.train(1,.5,.1,X,d,10);
q.plotNet(1)

fprintf('training QKMCC...')
qkmcc = qkmcc();
qkmcc.train(3,2,.5,.1,X,d,10);

fprintf('training QKMEE...')
qkmee = qkmee();
qkmee.train(2,50,1,.5,.5,X,d,10);

kmees.plotVal(1)

% q.train(4,.1,.04,trainIN,trainOUT,10);
%Final Learning NMSE:0.15148