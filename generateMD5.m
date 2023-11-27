function hash = generateMD5(inputStr)
    md = java.security.MessageDigest.getInstance('MD5');
    hashArray = md.digest(uint8(inputStr));
    hash = sprintf('%02x', typecast(hashArray, 'uint8'));
end
