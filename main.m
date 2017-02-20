echo off;
%sift 
dog=octavegen('samples/lighthouse.bmp')
if(iscell(dog)==0)
   disp('error');
end
disp('generated octaves');
[keys,sz]=localextrema(dog);

[keys,orientations,size1]=orientation_assign(keys,sz);
[octaves,v]=size(size1);


siftvector=featurevector(keys,size1,orientations);
disp(siftvector);
input('sd','s');
[octaves,v]=size(size1);
for a=1:octaves
    ima=imread(strcat('output/scales/scale-',int2str(a),'.png'))
    [w,h]=size(ima)
     ima=uint8(ima);
    imacopy=cat(3,ima,ima,ima);
    no_of_siftvectors=size1(a);
    for i=1:no_of_siftvectors-1
        for j=i+1:no_of_siftvectors
            v1=siftvector{a,i,:};
            v2=siftvector{a,j,:};
            if(v1==v2)
                disp('match found');
                x1=keys{a,i,1};
                y1=keys{a,i,2};
                x2=keys{a,j,1};
                y2=keys{a,j,2};
                %imacopy(x1,y1,1)=255;
                %imacopy(x2,y2,1)=255;
                %apreadout
                surr=1;
                while(surr<25&((x1-surr)>0)&((x2-surr)>0)&((y1-surr)>0)&((y2-surr)>0)&((x1+surr)<w)&((x2+surr)<w)&((y1+surr)<h)&((y2+surr)<h)&(imacopy(x1-surr:x1+surr,y1-surr:y1+surr,:)==imacopy(x2-surr:x2+surr,y2-surr:y2+surr,:)))
                    surr=surr+1;
                end
                surr=surr-1;
                color=255*rand
                colorm=mod(j,3)+1;
                for t1=-surr:surr
                    for t2=-surr:surr
                        imacopy(x1+t1,y1+t2,colorm)=color;
                        imacopy(x2+t1,y2+t2,colorm)=color;
                    end
                end
                
                
            end
        end
        disp(strcat('completed:',int2str(i/no_of_siftvectors*100)));
    end
    imwrite(imacopy,strcat('output/forgery/result',int2str(a),'.png'));

end