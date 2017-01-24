function d=octavegen(path)
info=imfinfo(path);
if(info.Width<=240&&info.Height<=180)
    disp('Error Lower Resolution than minimum Required');
    d=-1;
    return;
end
image=rgb2gray(imread(path));


%image=imread(path);
scalef=0.8;
sigmaf=sqrt(2);
noctaves=4;
nblur_levels=5;

j=0;

%figure,imshow(image);


% gen scale spaces
%for i=1:nimages_neg
%j=j+1;

%scaleimage{j}=imresize(image,scalef*i*-1+1);
%s=strcat('samples/',int2str(scalef*i));;
%s=strcat(s,'.png');
%imwrite(scaleimage{j},s);
%figure,imshow(scaleimage{j});


%end



for i=1:noctaves;
    j=j+1;
    scaleimage{j}=imresize(image,scalef^i);
    imwrite(scaleimage{j},strcat('output/scales/scale-',strcat(int2str(j),'.png')));
    
    
    
end


imwrite(image,'output/gray.png');

for k=1:j
    
    [r,c]=size(scaleimage{k});
    
    
    octs{k}=zeros(r,c,nblur_levels);
    DOG{k}=zeros(r,c,nblur_levels-1);
    octave=octs{k};
    
    for p=1:nblur_levels
        %old
        %octave(:,:,p)=conv2((scaleimage{k}),(gaussian2d(4,sigmaf*p)),'same');
        
        octave(:,:,p)=imgaussfilt(scaleimage{k},sigmaf^p);
        
        path=strcat('output/octaves/scale-',strcat(int2str(k),strcat('-',strcat(int2str(p),'.png'))));
        
        %uint8 to convert to range 0,255 else all white is generated
        %octave(:,:,p)=uint8(octave(:,:,p))
        imwrite(uint8(octave(:,:,p)),path);
        
        
        
        
        if(p>1)
            
            % if p >1
            % difference of guassian
            DOG{k}(:,:,p-1)=octave(:,:,p-1)-octave(:,:,p);
            path=strcat('output/dog/dog-',strcat(int2str(k),strcat('-',strcat(int2str(p),'.png'))));
            imwrite( (DOG{k}(:,:,p-1)),path);
        end
        
        
    end
    octs{k}=octave(:,:,:);
    
end
d=[2];

d=DOG;


end

