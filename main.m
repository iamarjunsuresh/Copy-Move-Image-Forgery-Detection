
%sift 
dog=octavegen('samples/nat.jpg')
if(iscell(dog)==0)
   disp('error');
end
disp('generated octaves');
localextrema(dog);

