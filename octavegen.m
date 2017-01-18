function d=octavegen(path)
image=rgb2gray(imread(path));
%image=imread(path);
scalef=0.5;
sigmaf=sqrt(2);
noctaves=4;
nblur_levels=5;

j=0;

%figure,imshow(image);


% gen scale spaces
%for i=1:nimages_neg
%j=j+1;

%scaleimage{j}=imresize(image,scalef*i*-1+1);
%s=strcat("samples/",int2str(scalef*i));;
%s=strcat(s,".png");
%imwrite(scaleimage{j},s);
%figure,imshow(scaleimage{j});


%end



for i=1:noctaves;
j=j+1;
scaleimage{j}=imresize(image,scalef^i);




end
disp(j);

imwrite(image,"output/gray.png");
for k=1:j 
%disp(k);
[r,c]=size(scaleimage{k});

disp(r);
disp(c);
octs{k}=zeros(r,c,nblur_levels);
DOG{k}=zeros(r,c,nblur_levels-1);
octave=octs{k};
for p=1:nblur_levels
%guass=fspecial("gaussian",4,sigmaf^p);
%octave(:,:,p)=imfilter(scaleimage{k},guass,'same');
octave(:,:,p)=conv2(scaleimage{k},gaussian2d(4,sigmaf*p),"same");

path=strcat("output/octaves/scale-",strcat(int2str(k),strcat("-",strcat(int2str(p),".png"))));

%uint8 to convert to range 0,255 else all white is generated
octave(:,:,p)=uint8(octave(:,:,p))
imwrite(uint8(octave(:,:,p)),path);


%disp(octave(:,:,p));

%disp(p);

if(p>1)

% if p >1 
% difference of guassian

DOG{k}(:,:,p-1)=octave(:,:,p-1)-octave(:,:,p);
path=strcat("output/dog/dog-",strcat(int2str(k),strcat("-",strcat(int2str(p),".png")))
imwrite(uint8(DOG{k}(:,:,p-1)),path);
end

end
octs{k}=octave(:,:,:);

end



endfunction

