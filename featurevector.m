function fvectors= featurevector(keys,size1,orientation)

siz=size(keys);
numofsets=siz(1);
vect=cell(numofsets,max(size1(:)),128);

idx=0;
vn=0;
disp(size1);

for k=1:numofsets
    
    disp(size1(k));
%     if(size1(k)~=size(keys(k,:,:)))
% disp('error');
% input('error','s');
%     end
    im=imread(strcat('output/scales/scale-',int2str(k),'.png'));
    [height,width]=size(im);
    for i=1:size1(k)
        %disp(size(keys{k,:,:}));1
        for ki=1:128
            vect{k,i,ki}=0;
        end
        p=double(keys{k,i,1});
        q=keys{k,i,2};
        disp(p);
        disp(q);
        idx=0;
        
%                     disp('s')
%                     disp(i);
%                         input('d','s');
        if((p>16&q>16)&(p<=(height-16)&q<=(width-16)))
            for m=-2:2
                for n=-2:2
                   if(m==0||n==0)
                       continue;
                   end
                       
                       
                 histo=zeros(8);
                    for f=p+m*4:p+4+m*4-1
                        for h=q+n*4:q+4+n*4-1
                            
                            %calculate gradient in each sub window
                            dy=double(im(f,h-1)-im(f,h+1));
                            dx=double(im(f-1,h)-im(f+1,h));
                            disp(dy);disp(dx);
                           
                            angle=atand(double(dy/dx));
                            
                            if(dx<0&&dy<0)
                                
                            angle =angle+180;
                            elseif(dx<0)
                                angle=angle+180;
                            
                                
                            elseif(dy<0)
                                angle=angle +360;
                            end
                            bin=idivide(uint16(angle),45,'ceil')
                            bin=bin+1;
                            
                            
                            vect{k,i,idx*8+bin}=vect{k,i,idx*8+bin} +sqrt(dx^2+dy^2);
                            disp(vect{k,i,idx*8+bin});
                            disp(idx*8+bin);
                            %input('same','s');
                        end
                    end

             
%                     for kk=1:8
%                         vn=vn+1;
%                     vect{i,vn,idx*8+kk}=histo(kk);
%                     
%                     end
                     idx=idx+1;
                       end 
            end
                    end
            end
        end
        
  disp(vect)
  %input('vect','s');

fvectors=vect;


end