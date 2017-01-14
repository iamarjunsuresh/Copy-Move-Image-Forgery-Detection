function d=octavegen(path)
image=rgb2gray(imread(path));

scalef=0.2;
sigmaf=sqrt(0.1);
nimages_neg=2;
nimages_pos=3;
noctaves=5;

j=0;

%figure,imshow(image);


% gen scale spaces
for i=1:nimages_neg
j=j+1;

scaleimage{j}=imresize(image,scalef*i*-1+1);
%s=strcat("samples/",int2str(scalef*i));;
%s=strcat(s,".png");
%imwrite(scaleimage{j},s);
%figure,imshow(scaleimage{j});


end



for i=1:nimages_pos
j=j+1;
scaleimage{j}=imresize(image,scalef*i+1);




end
disp(j);

imwrite(image,"output/gray.png");
for k=1:j 
%disp(k);
[r,c]=size(scaleimage{k});

disp(r);
disp(c);

octave(:,:,:)=matrix(r,c,j);
for p=1:5
guass=fspecial("gaussian",4,sigmaf^p);
octave(:,:,p)=imfilter(scaleimage{k},guass,'same');
path=strcat("output/scale-",strcat(int2str(k),strcat("-",strcat(int2str(p),".png"))));
imwrite(octave(:,:,p),path);

%disp(p);
end
octs{k}=octave(:,:,:);

end


endfunction

