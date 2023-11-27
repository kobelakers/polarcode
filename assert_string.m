function assert_string(s1, s2, msg)

if nargin == 2,
  msg = 'Error!';
end

if (iscell(s1))
    assert(strcmp(s1, s2) ~= 0, sprintf('Expected %s == %s', s1{1}, s2))
else
    assert(strcmp(s1, s2) ~= 0, sprintf('Expected %s == %s', s1, s2))
end

function assert(cond, msg)

global R;

if nargin == 1,
  msg = 'Error!';
end

if ~cond,
  fclose(R);
  error(msg)
end
