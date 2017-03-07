pred = stackedAERecognition('data/11.png', 1);
fprintf('检测结果: %d\n', pred);

A = zeros(46,46);
pred = stackedAERecognition(A, 2);
fprintf('检测结果: %d\n', pred);