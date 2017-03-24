echo off;
%sift 
dog=octavegen('samples/face5.bmp')
if(iscell(dog)==0)
   disp('error');
end
disp('generated octaves');
[keys,sz]=localextrema(dog);

[keys,orientations,size1]=orientation_assign(keys,sz);
[octaves,v]=size(size1);


siftvector=featurevector(keys,size1,orientations);
disp(siftvector);
[octaves,v]=size(size1);
figure;
hold on;

for a=1:octaves
    ima=imread(strcat('output/scales/color-scale-',int2str(a),'.png'))
    [w,h]=size(ima)
    flag=0;
   %  ima=uint8(ima);
    imacopy=ima;
    imacopy1=ima;
    imagesc(ima);
    no_of_siftvectors=size1(a);
% no_of_siftvectors=100;
    for i=1:no_of_siftvectors-1
        for j=i+1:no_of_siftvectors
            matchfo=1;
            allzero=1;
            for m=1:128
                v1=siftvector{a,i,m};
                v2=siftvector{a,j,m};
                if(v1~=0|v2~=0)
                    allzero=0;
                end
                if( abs(v1-v2)<5)
                    matchfo=matchfo+1;
                   
                    

                end
                
            end
            %disp(matchfo);
            %zzz=input('ps');
            if(matchfo>110&allzero==0)%&~(keys{a,i,1}==keys{a,j,1}&keys{a,i,2}==keys{a,j,2}))
                disp('match found');
               
                x1=keys{a,i,1};
                y1=keys{a,i,2};
                x2=keys{a,j,1};
                y2=keys{a,j,2};
               
                imacopy(x1,y1,1)=255;
                imacopy(x2,y2,1)=255;
              %  apreadout
                surr=1;
                while(surr<8&((x1-surr)>0)&((x2-surr)>0)&((y1-surr)>0)&((y2-surr)>0)&((x1+surr)<w)&((x2+surr)<w)&((y1+surr)<h)&((y2+surr)<h)&(imacopy(x1,y1,1)==imacopy(x1,y1,2)&imacopy(x1,y1,2)==imacopy(x1,y1,3))&(imacopy(x1-surr:x1+surr,y1-surr:y1+surr,1)==imacopy(x2-surr:x2+surr,y2-surr:y2+surr,1)))
                    surr=surr+1;
                end
                surr=surr-1;
                disp(surr);
            
                color=255*rand;
                colorm=mod(i,3)+1;
                for t1=-surr:surr
                        imacopy1(x1+t1,y1,:)=[0,0,0];
                        imacopy1(x1,y1+t1,:)=[0,0,0];
                        imacopy1(x2,y2+t1,:)=[0,0,0];
                        imacopy1(x2+t1,y2,:)=[0,0,0];
                        imacopy1(x1+t1,y1,colorm)=mod(i,255);
                        imacopy1(x1,y1+t1,colorm)=mod(i,255);
                        imacopy1(x2+t1,y2,colorm)=mod(i,255);
                        imacopy1(x2,y2+t1,colorm)=mod(i,255);
                end
                 line([x1,x2],[y1,y2],'LineWidth',1);
                 imacopy1 = insertShape(imacopy1,'Line',[y1 x1 y2 x2],'LineWidth',1);
                        disp(x1);

                        disp(y1);
                        disp(x2); 
                        disp(y2);
                        disp(i);
                        disp(j);
                        if(x1~=x2)
                         %      sd=input('pause:');
                        end;
                

            end
        end
        disp(strcat('completed:',int2str(i/no_of_siftvectors*100))); 
        
end
    
    imwrite(imacopy1,strcat('output/forgery/result',int2str(a),'.png'));
  
    
end
