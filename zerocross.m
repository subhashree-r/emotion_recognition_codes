function f = zerocross(vector)
len = length(vector);
currsum = 0;
prevsign = 0;

for i = 1:len
  currsign = sign(vector(i));
  if (currsign * prevsign) == -1 
    currsum = currsum + 1;
  end
  if currsign ~= 0
    prevsign = currsign;
  end
end

f = currsum;
end


