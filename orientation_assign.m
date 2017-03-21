function [keys,orientation,size1]=orientiation_assign(keypoints,sz)

% %[j,nkey,no]
d=size(keypoints);
% disp(d);
% disp(sz(3));
% keys=1;
% orientation=1;
% size1=2;
% 
% return;
j=d(1);
nkey=d(2);
orient=cell(j,nkey,1);

for (k=1:j)
    idx=0;
    im=imread(strcat('output/scales/scale-',strcat(int2str(k),'.png')));
    %copyimage=imread(strcat('output/scales/scale-',strcat(int2str(k),'.png')));
    [mx,my]=size(im);
    histo=zeros(36);
for g=1:sz(k)

m=keypoints{k,g,1};
n=keypoints{k,g,2};
for bin=1:36
histo(bin)=0;
end
for ff=m-1:m+1
   for gg=n-1:n+1
if(ff~=gg&&ff-2>0&&gg-2>0&&ff+2<=mx&&gg+2<=my)
    %calculae magnitude and orientation
    magsqr=(im((ff-1),gg)-im(ff+1,gg))^2+(im(ff,gg-1)-im(ff,gg+1))^2;
    mag=sqrt(double(magsqr));
angle=atand(double((im((ff-1),gg)-im(ff+1,gg))/(im(ff,gg-1)-im(ff,gg+1))));

bucket=idivide(uint16(angle),10,'ceil');
bucket=bucket+1;
histo(bucket)=histo(bucket)+mag;


end
end

end

[maxmag,indexofmaxelement]=max(histo(1:36));

% adding existing keypoint to liust

sz(k)=sz(k)+1;
keypoints{k,sz(k),1}=ff;
keypoints{k,sz(k),2}=gg;
orient{k,sz(k),1}=indexofmaxelement(1)*10;
r=16;

    %check if any keypoint is more than 0.8
for i=1:36            
    if(histo(i)>0.8*maxmag)
%         disp('over');
%          sz(k)=sz(k)+1;
%          keypoints{k,sz(k),1}=ff;
%          keypoints{k,sz(k),2}=gg;
%          orient{k,sz(k),1}=i*10;

    end
end

end
        
    end
    
    keys=keypoints;
    orientation=orient;
    size1=sz;
    disp(sz);
    



end