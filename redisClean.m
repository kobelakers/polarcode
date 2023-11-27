function [R, S] = redisClean(R)

S = 'OK';

% Check if the connection is open
if ~strcmp(R.Status, 'open')
  S = 'ERROR - NO CONNECTION';
  return;
end

% Send the FLUSHALL command to clear all data in Redis
[Response, R, S] = redisCommand(R, redisCommandString('FLUSHALL'));

% Check if the operation was successful
if strcmp(Response, '+OK')
  S = Response;
  return
else
  S = 'ERROR - CLEAN FAILED';
end

end
