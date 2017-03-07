function labels = loadMYLabels(filename)

fp = fopen(filename, 'rb');
assert(fp ~= -1, ['Could not open ', filename, '']);

numLabels = 3410;
i = 0;
while ~feof(fp)                                                 
   fgetl(fp); 
   i = i + 1;
end

fclose(fp);

assert(i == numLabels, 'Mismatch in label count');

labels = zeros(numLabels, 1);

num_per_class = 55; 
i = 1;
class = 1;
for j = 1:numLabels
    labels(j, 1) = class;
    if i == num_per_class
        i = 1;
        class = class + 1;
    else
        i = i + 1;
    end
end

end
