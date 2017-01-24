
%sift 
dog=octavegen('samples/prave.bmp')
if(iscell(dog)==0)
   disp('error');
end
disp('generated octaves');
localextrema(dog);

