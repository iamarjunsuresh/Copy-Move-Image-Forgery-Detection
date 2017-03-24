function d=octavegen(path)
info=imfinfo(path);
if(info.Width<=240&&info.Height<=180)
    disp('Error Lower Resolution than minimum Required');
    d=-1;
    return;
end
colorimage=imread(path)
image=rgb2gray(colorimage);


%image=imread(path);
scalef=1;
sigmaf=sqrt(2);
noctaves=1;
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



for j=1:noctaves;
%     j=j+1;
%     
%     
%     %%%
%     
%     
% 
%     %%%
%     scaleimage{j}=imresize(image,scalef^(2*j+i)*1.6);
%     imwrite(scaleimage{j},strcat('output/scales/scale-',strcat(int2str(j),'.png')));
%     imwrite(imresize(colorimage,scalef^i),strcat('output/scales/color-scale-',strcat(int2str(j),'.png')));
%     
%     
end


imwrite(image,'output/gray.png');

for k=1:noctaves
    
 
    [r,c]=size(image);
    scaleimage{k}=imresize(image,scalef^(k));
       r=(scalef^k)*r;
       c=(scalef^k)*c;
       
    imwrite(scaleimage{k},strcat('output/scales/scale-',strcat(int2str(k),'.png')));
    imwrite(imresize(colorimage,scalef^k),strcat('output/scales/color-scale-',strcat(int2str(k),'.png')));
    octs{k}=zeros(r,c,nblur_levels);
    DOG{k}=zeros(r,c,nblur_levels-1);
    octave=octs{k};
    
    for p=1:nblur_levels
        clear cc;
    cc=zeros(r,c);
        %old
        %octave(:,:,p)=conv2((scaleimage{k}),(gaussian2d(4,sigmaf*p)),'same');
      sigma=sigmaf^(1/nblur_levels)^((p-1)*nblur_levels+k);
         
for x=-3:3
    for y=-3:3
        h(x+4,y+4)=(1/((2*pi)*((sigmaf*sigma)*(sigmaf*sigma))))*exp(-((x*x)+(y*y))/(2*(sigmaf*sigmaf)*(sigmaf*sigma)));
    end
end
for ii=1:r-6
    for jj=1:c-6
        llo=imresize(image,scalef^(k));
        t=double(llo(ii:ii+6,jj:jj+6)').*h;
        cc(ii,jj)=sum(sum(t));
    end
end

      
octave(:,:,p)=cc(:,:);
%%
      
%       
%       %octave(:,:,p)=imgaussfilt(scaleimage{k},sigmaf^p);
%         f=fspecial('gaussian',[1,floor(6*sigmaf^p)],sigmaf0);
%         octave(:,:,p)=conv2(conv2(scaleimage{k},f,'same'),f,'same');
%         path=strcat('output/octaves/scale-',strcat(int2str(k),strcat('-',strcat(int2str(p),'.png'))));
%         
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

