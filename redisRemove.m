function [R, S] = redisRemove(R, key)

S = 'OK';

% Check if the connection is open
if ~strcmp(R.status, 'open')
  S = 'ERROR - NO CONNECTION';
  return;
end

% Use the DEL command to remove the key
[Response, R, S] = redisCommand(R, redisCommandString(sprintf('DEL %s', key)));

% Check the response. DEL command returns the number of keys that were removed.
% Since we're trying to delete just one key, a response of ':1' means the key was successfully removed.
% If the key does not exist, it will return ':0'.
if strcmp(Response, ':1')
  S = 'KEY REMOVED SUCCESSFULLY';
  return
elseif strcmp(Response, ':0')
  S = 'ERROR - KEY DOES NOT EXIST';
  return
else
  S = Response;
  return
end

end
