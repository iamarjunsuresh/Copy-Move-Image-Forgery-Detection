function fvectors= featurevector(keys,size1,orientation)

siz=size(keys);
numofsets=siz(1);
vects=zeros(sum(siz(:)),128);
idx=0;
vn=0;
for k=1:numofsets
    im=imread(strcat('output/scales/scale-',int2str(k),'.png'));
    [height,width]=size(im);
    for i=1:size1(k)
        %disp(size(keys{k,:,:}));
        p=keys{k,i,1};
        q=keys{k,i,2};
        if(p>16&&q>16&&p<=(height-16)&&q<=(width-16))
            for m=-2:2
                for n=-2:2
                    idx=0;
                 histo=zeros(8)
                    for f=p+m*4:p+4+m*4
                        for h=q+n*4:q+4+n*4
                            
                            %calculate gradient in each sub window
                            dy=im(f,h-1)-im(f,h+1);
                            dx=im(f-1,h)-im(f+1,h);
                            
                            angle=atand(double(dy/dx));
                            bin=idivide(uint16(angle),45,'ceil')
                            bin=bin+1;
                            histo(bin)=histo(bin)+(1/sqrt((p-f)^2+(q-h)^2));
                        end
                    end
                    for kk=1:8
                        vn=vn+1;
                    vect(vn,idx*8+kk)=histo(kk);
                    
                    end
                    idx=idx+1;
                    end
            end
        end
        
    end
end



end