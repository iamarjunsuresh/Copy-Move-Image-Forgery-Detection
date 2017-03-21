function [ d ,sz] = localextrema( DOG )
%LOCALEXTREMA SIFT -step 2 
%   Determine the local extrema of DOG images 

[venda,j]=size(DOG);
[venda,venda1,nblur_levels]=size(DOG{1});

keypoints=cell(j,1,2);
sz=zeros(j);
idx=0;

for k=1:j
    disp(strcat('finding local extrema for octave ',int2str(k)));
    
   
   idx=0; 
    copyimage=imread(strcat('output/scales/scale-',strcat(int2str(k),'.png')));
    disp(size(copyimage));
    copyimage=uint8(copyimage);
    copyimage=cat(3,copyimage,copyimage,copyimage);
%     hold off
%     image(DOG{k}(:,:,1));
   for l=2:nblur_levels-1
         im=DOG{k};
         [r,c]=size(im(:,:,1));
         
         for m=2:r-1
             for n=2:c-1
                uppermat=im(m-1:m+1,n-1:n+1,l-1);
                lowermat=im(m-1:m+1,n-1:n+1,l+1);
                neighbour8=im(m-1:m+1,n-1:n+1,l);
                largest=max(uppermat(:));
                
                largest2=max(lowermat(:));
                largestinsame=max(neighbour8(:));
                
                
                smallest=min(uppermat(:));
                smallest2=min(lowermat(:));
                smallestinsame=min(neighbour8(:));
                %disp(largest);
                if(smallestinsame<0)
                    
               % disp(smallestinsame);
                %return;
                end
                dogmax=5;
                if((largestinsame>=largest&&largestinsame>=largest2)&&largestinsame==im(m,n,1))
                   
                    idx=idx+1;
                    keypoints{k,idx,1}=m;

                    
                    keypoints{k,idx,2}=n;
                                      copyimage(m,n,1)=255;
                                      copyimage(m,n,2)=0;
                                      copyimage(m,n,3)=0;
                                      
                                      try
                                      
                                      for ui=-3:3
                                          copyimage(m+ui,n,1)=255;
                                      copyimage(m+ui,n,2)=0;
                                      copyimage(m+ui,n,3)=0;
                                      copyimage(m,n+ui,1)=255;
                                      copyimage(m,n+ui,2)=0;
                                      copyimage(m,n+ui,3)=0;
                                      end
                                      
                                      catch me
                                          
                                      end
                                          
                   
                   
                end
                
                if(smallestinsame<=smallest&&smallestinsame<=smallest2&&smallestinsame==im(m,n,l))%%&&im(m,n,l)<-dogmax)
                   idx=idx+1;
                    keypoints{k,idx,1}=m;

                    
                    keypoints{k,idx,2}=n;

                    
                    
                    copyimage(m,n,1)=255;
                
                    copyimage(m,n,2)=0;
                    copyimage(m,n,3)=0;
                     try
                                      
                                      for ui=-4:4
                                          copyimage(m+ui,n,1)=255;
                                      copyimage(m+ui,n,2)=0;
                                      copyimage(m+ui,n,3)=0;
                                      copyimage(m,n+ui,1)=255;
                                      copyimage(m,n+ui,2)=0;
                                      copyimage(m,n+ui,3)=0;
                                      end
                                      
                                      catch me
                                          
                                      end
             end
         end
           
        
   end
   
   imwrite(copyimage,strcat('output/keypoints/key',strcat(int2str(k),'.png')));
   end
sz(k)=idx;


end



d=keypoints;
end