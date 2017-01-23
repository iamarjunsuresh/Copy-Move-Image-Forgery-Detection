function [ keypoints ] = localextrema( DOG )
%LOCALEXTREMA SIFT -step 2 
%   Determine the local extrema of DOG images 

[venda,j]=size(DOG);
[venda,venda1,nblur_levels]=size(DOG{1});




for k=1:j
    image(DOG{k}(:,:,1));
   for l=2:nblur_levels-1
         im=DOG{k};
         [r,c]=size(im(:,:,1));
         
         for m=2:r-1
             for n=2:c-1
                uppermat=im(m-1:m+1,n-1:n+1,l-1);
                lowermat=im(m-1:m+1,n-1:n+1,l+1);
                neighbour8=im(m-1:m+1,n-1:n+1,l);
                largest=max([max(uppermat(:)),max(lowermat(:))]);
                largestinsame=max(neighbour8(:));
                %disp(largest);
                %disp(largestinsame);
                if(largest>largestinsame)
                   lrge=largest ;
                else
                    lrge=largestinsame;
                end
                if(lrge==im(m,n,l))
                    hold on
                   plot(m,n,'r.','MarkerSize',2);
                   
                   
                end
                
             end
         end
           
        
   end
   
   saveas(gcf,strcat('keypoints',int2str(k)),'png') 
end


end

