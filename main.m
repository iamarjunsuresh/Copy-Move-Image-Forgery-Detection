
%sift 
dog=octavegen('samples/prave.bmp')
if(iscell(dog)==0)
   disp('error');
end
disp('generated octaves');
[keys,sz]=localextrema(dog);

[keys,orientations,size1]=orientation_assign(keys,sz);

siftvector=featurevector(keys,size1,orientations);