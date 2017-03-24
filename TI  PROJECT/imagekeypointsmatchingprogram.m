%% ***************This program finds the key points and their descriptors of two images and matches them************
%% *******************Output of this program will give you the matching percentage of key points********************
%% **********************Submitted to Texas Instruments on October 1st 2013*****************************************
%% ****************************************By:Ch.Naveen*************************************************************
%% Important Variables
% a : Input image
% kpmag : keypoints magnitude
% kpori : keypoints orientation
% kpd   : key point descriptors
% kp    : keypoints
% kpl   : keypoint locations
% Extension of 2 for above variable indicates,it is used for second image for matching
% mp    : matching percentage


clc;
close all;
clear all;
fprintf('Some of the images available for checking are:\n');
fprintf('1.lena.jpg(512x512)\n2.lena1.jpg(256x256)\n3.peppers256.png(256x256)\n4.testfi.png(256x256)\n5.baboon.bmp(256x256)\n6.testfile.jpg(color)(1920x1200)\n');
image=input('Choose and enter the image name from above       :      ','s');
a=imread(image);
imshow(a);
title('Selected image');
[row,col,plane]=size(a);
if plane==3
a=rgb2gray(a);
end
a=im2double(a);
original=a;
store1=[];
store2=[];
store3=[];
tic
%% 1st octave generation
k2=0;
[m,n]=size(a);
a(m:m+6,n:n+6)=0;
clear c;
for k1=0:3
    k=sqrt(2);
sigma=(k^(k1+(2*k2)))*1.6;
for x=-3:3
    for y=-3:3
        h(x+4,y+4)=(1/((2*pi)*((k*sigma)*(k*sigma))))*exp(-((x*x)+(y*y))/(2*(k*k)*(sigma*sigma)));
    end
end
for i=1:m
    for j=1:n
        t=a(i:i+6,j:j+6)'.*h;
        c(i,j)=sum(sum(t));
    end
end
store1=[store1 c];
end
return;
clear a;
a=imresize(original,1/2);

%% 2nd level pyramid generation
k2=1;
[m,n]=size(a);
a(m:m+6,n:n+6)=0;
clear c;
for k1=0:3
    k=sqrt(2);
sigma=(k^(k1+(2*k2)))*1.6;
for x=-3:3
    for y=-3:3
        h(x+4,y+4)=(1/((2*pi)*((k*sigma)*(k*sigma))))*exp(-((x*x)+(y*y))/(2*(k*k)*(sigma*sigma)));
    end
end
for i=1:m
    for j=1:n
        t=a(i:i+6,j:j+6)'.*h;
        c(i,j)=sum(sum(t));
    end
end
store2=[store2 c];
end
clear a;
a=imresize(original,1/4);

%% 3rd level pyramid generation
k2=2;
[m,n]=size(a);
a(m:m+6,n:n+6)=0;
clear c;
for k1=0:3
    k=sqrt(2);
sigma=(k^(k1+(2*k2)))*1.6;
for x=-3:3
    for y=-3:3
        h(x+4,y+4)=(1/((2*pi)*((k*sigma)*(k*sigma))))*exp(-((x*x)+(y*y))/(2*(k*k)*(sigma*sigma)));
    end
end
for i=1:m
    for j=1:n
        t=a(i:i+6,j:j+6)'.*h;
        c(i,j)=sum(sum(t));
    end
end
store3=[store3 c];
end

%% Obtaining key point from the image
i1=store1(1:row,1:col)-store1(1:row,col+1:2*col);
i2=store1(1:row,col+1:2*col)-store1(1:row,2*col+1:3*col);
i3=store1(1:row,2*col+1:3*col)-store1(1:row,3*col+1:4*col);
[m,n]=size(i2);
kp=[];
kpl=[];
for i=2:m-1
    for j=2:n-1
        x=i1(i-1:i+1,j-1:j+1);
        y=i2(i-1:i+1,j-1:j+1);
        z=i3(i-1:i+1,j-1:j+1);
        y(1:4)=y(1:4);
        y(5:8)=y(6:9);
        mx=max(max(x));
        mz=max(max(z));
        mix=min(min(x));
        miz=min(min(z));
        my=max(max(y));
        miy=min(min(y));
        if (i2(i,j)>mz && i2(i,j)>my) || (i2(i,j)<miz && i2(i,j)<miy)
            kp=[kp i2(i,j)];
            kpl=[kpl i j];
        end
    end
end

%% Key points plotting on to the image
for i=1:2:length(kpl);
    k1=kpl(i);
    j1=kpl(i+1);
    i2(k1,j1)=1;
end
figure, imshow(i2);
title('Image with key points mapped onto it');

%% Magnitude and orientation assignment to the key points
for i=1:m-1
    for j=1:n-1
         mag(i,j)=sqrt(((i2(i+1,j)-i2(i,j))^2)+((i2(i,j+1)-i2(i,j))^2));
         oric(i,j)=atan2(((i2(i+1,j)-i2(i,j))),(i2(i,j+1)-i2(i,j)))*(180/pi);
    end
end

%% Forming key point neighbourhooods
kpmag=[];
kpori=[];
for x1=1:2:length(kpl)
    k1=kpl(x1);
    j1=kpl(x1+1);
    if k1 > 2 && j1 > 2 && k1 < m-2 && j1 < n-2
    p1=mag(k1-2:k1+2,j1-2:j1+2);
    q1=oric(k1-2:k1+2,j1-2:j1+2);
    else
        continue;
    end
    %% Finding orientation and magnitude for the key point
[m1,n1]=size(p1);
magcounts=[];
for x=0:10:359
    magcount=0;
for i=1:m1
    for j=1:n1
        ch1=-180+x;
        ch2=-171+x;
        if ch1<0  ||  ch2<0
        if abs(q1(i,j))<abs(ch1) && abs(q1(i,j))>=abs(ch2)
            ori(i,j)=(ch1+ch2+1)/2;
            magcount=magcount+p1(i,j);
        end
        else
        if abs(q1(i,j))>abs(ch1) && abs(q1(i,j))<=abs(ch2)
            ori(i,j)=(ch1+ch2+1)/2;
            magcount=magcount+p1(i,j);
        end
        end
    end
end
magcounts=[magcounts magcount];
end
[maxvm maxvp]=max(magcounts);
kmag=maxvm;
kori=(((maxvp*10)+((maxvp-1)*10))/2)-180;
kpmag=[kpmag kmag];
kpori=[kpori kori];
% maxstore=[];
% for i=1:length(magcounts)
%     if magcounts(i)>=0.8*maxvm
%         maxstore=[maxstore magcounts(i) i];
%     end
% end
% 
% if maxstore > 2
%     kmag=maxstore(1:2:length(maxstore));
%     maxvp1=maxstore(2:2:length(maxstore));
%     temp=(countl((2*maxvp1)-1)+countl(2*maxvp1)+1)/2;
%     kori=temp;
% end
end


%% Forming key point Descriptors
kpd=[];
%% Forming key point neighbourhooods
for x1=1:2:length(kpl)
    k1=kpl(x1);
    j1=kpl(x1+1);
    if k1 > 7 && j1 > 7 && k1 < m-8 && j1 < n-8
    p2=mag(k1-7:k1+8,j1-7:j1+8);
    q2=oric(k1-7:k1+8,j1-7:j1+8);
    else
        continue;
    end
    kpmagd=[];
    kporid=[];
%% Dividing into 4x4 blocks
    for k1=1:4
        for j1=1:4
            p1=p2(1+(k1-1)*4:k1*4,1+(j1-1)*4:j1*4);
            q1=q2(1+(k1-1)*4:k1*4,1+(j1-1)*4:j1*4);
            
        %% Finding orientation and magnitude for the key point
        [m1,n1]=size(p1);
        magcounts=[];
        for x=0:45:359
            magcount=0;
        for i=1:m1
            for j=1:n1
                ch1=-180+x;
                ch2=-180+45+x;
                if ch1<0  ||  ch2<0
                if abs(q1(i,j))<abs(ch1) && abs(q1(i,j))>=abs(ch2)
                    ori(i,j)=(ch1+ch2+1)/2;
                    magcount=magcount+p1(i,j);
                end
                else
                if abs(q1(i,j))>abs(ch1) && abs(q1(i,j))<=abs(ch2)
                    ori(i,j)=(ch1+ch2+1)/2;
                    magcount=magcount+p1(i,j);
                end
                end
            end
        end
        magcounts=[magcounts magcount];
        end
        kpmagd=[kpmagd magcounts];
        end
    end
    kpd=[kpd kpmagd];
end
fprintf('\n\nTime taken for calculating the SIFT keys and their desccriptors is :%f\n\n',toc);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% 2ng image for comparision
a=original;
fprintf('Calculation of key points has been finished for the given image\n\n');
fprintf('If you want to check the robustness of the program by changing some of the properties..\nyou can check them here\n\n');
fprintf('Note: Run only one condition at a time\n\nSelect\n\n');
fprintf('1.Change intensity\n2.Change scale i.e., sigma\n3.Rotate image(Select only for 2,3,4,5 images mentioned above)\n');
ev=input('\nEnter the choice          ');
if ev==1
    disp('Select');
    disp('1.Increase intensity        2.Decrease Intensity           ');
    eis=input('Enter choice      ');
    if eis==1
        p1=input('Enter the level of increase in intensity      ');
        a=a*p1;
        figure, imshow(a);
        title('Image after changing the intensity');
        sigmae=1.6;
    elseif eis==2
        p1=input('Enter the level of decrease in intensity      ');
        a=a/p1;
        figure, imshow(a);
        title('Image after changing the intensity');
        sigmae=1.6;
    else
        disp('Wrong choice');
        
    end
elseif ev==2
    sigmae=input('Enter sigma value :');
elseif ev==3
    thetai=input('Enter the angle at which image is to be rotated         ');
    theta=thetai*(pi/180);
    b=imrotate(a,thetai);
    fprintf('Rotated image is     \n');
    figure, imshow(b);
    title('Rotate image')
    [m,n]=size(original);
    old=[];
    map=[];
    for i=1:m
        for j=1:n
            i1=(cos(theta)*(i-m/2))-(sin(theta)*(j-n/2))+m/2;
            j1=(sin(theta)*(i-m/2))+(cos(theta)*(j-n/2))+n/2;
            old((i-1)*m+j,1:2)=[i j];
            map((i-1)*m+j,1:2)=[round(i1) round(j1)];
        end
    end
    [m1,n1]=size(b);
    marginr=floor((m1-m)/2);
    marginc=floor((n1-n)/2);
    if thetai==90
        for i=1:m
        for j=1:n
            new((i-1)*m+j,1:2)=[map((i-1)*m+j,1)+marginr+1 map((i-1)*m+j,2)+marginc];
        end
        end
    elseif thetai==180
        for i=1:m
        for j=1:n
            new((i-1)*m+j,1:2)=[map((i-1)*m+j,1)+marginr+1 map((i-1)*m+j,2)+marginc+1];
        end
        end
    else
    for i=1:m
        for j=1:n
            new((i-1)*m+j,1:2)=[map((i-1)*m+j,1)+marginr+1 map((i-1)*m+j,2)+marginc+1];
        end
    end
    end
    clear a;
    for i=1:m
        for j=1:n
            a(i,j)=b(new((i-1)*m+j,1),new((i-1)*m+j,2));
        end
    end
    figure, imshow(a);
    title('straitened version of rotated image using coordinate mapping');
    sigmae=1.6;
else
    disp('entered wrong choice');
    disp('No changes in parameters is done');
        sigmae=1.6;
end
[row,col]=size(a);
store1=[];
store2=[];
store3=[];
tic
%% 1st octave generation
k2=0;
[m,n]=size(a);
a(m:m+6,n:n+6)=0;
clear c;
for k1=0:3
    k=sqrt(2);
sigma=(k^(k1+(2*k2)))*sigmae;
for x=-3:3
    for y=-3:3
        h(x+4,y+4)=(1/((2*pi)*((k*sigma)*(k*sigma))))*exp(-((x*x)+(y*y))/(2*(k*k)*(sigma*sigma)));
    end
end
for i=1:m
    for j=1:n
        t=a(i:i+6,j:j+6)'.*h;
        c(i,j)=sum(sum(t));
    end
end
store1=[store1 c];
end
clear a;
a=imresize(original,1/2);

%% 2nd level pyramid generation
k2=1;
[m,n]=size(a);
a(m:m+6,n:n+6)=0;
a=im2double(a);
clear c;
for k1=0:3
    k=sqrt(2);
sigma=(k^(k1+(2*k2)))*sigmae;
for x=-3:3
    for y=-3:3
        h(x+4,y+4)=(1/((2*pi)*((k*sigma)*(k*sigma))))*exp(-((x*x)+(y*y))/(2*(k*k)*(sigma*sigma)));
    end
end
for i=1:m
    for j=1:n
        t=a(i:i+6,j:j+6)'.*h;
        c(i,j)=sum(sum(t));
    end
end
store2=[store2 c];
end
clear a;
a=imresize(original,1/4);

%% 3rd level pyramid generation
k2=2;
[m,n]=size(a);
a(m:m+6,n:n+6)=0;
a=im2double(a);
clear c;
for k1=0:3
    k=sqrt(2);
sigma=(k^(k1+(2*k2)))*sigmae;
for x=-3:3
    for y=-3:3
        h(x+4,y+4)=(1/((2*pi)*((k*sigma)*(k*sigma))))*exp(-((x*x)+(y*y))/(2*(k*k)*(sigma*sigma)));
    end
end
for i=1:m
    for j=1:n
        t=a(i:i+6,j:j+6)'.*h;
        c(i,j)=sum(sum(t));
    end
end
store3=[store3 c];
end

%% Obtaining key point from the image
i1=store1(1:row,1:col)-store1(1:row,col+1:2*col);
i2=store1(1:row,col+1:2*col)-store1(1:row,2*col+1:3*col);
i3=store1(1:row,2*col+1:3*col)-store1(1:row,3*col+1:4*col);
if ev==2
    figure, imshow(i2);
    title('Image after change in the sigma value')
end
[m,n]=size(i2);
kp2=[];
kpl2=[];
for i=2:m-1
    for j=2:n-1
        y=[];
        x=i1(i-1:i+1,j-1:j+1);
        y=i2(i-1:i+1,j-1:j+1);
        z=i3(i-1:i+1,j-1:j+1);
        y(1:4)=y(1:4);
        y(5:8)=y(6:9);
        mx=max(max(x));
        mz=max(max(z));
        mix=min(min(x));
        miz=min(min(z));
        my=max(max(y));
        miy=min(min(y));
        if (i2(i,j)>mz && i2(i,j)>my) || (i2(i,j)<miz && i2(i,j)<miy)
            kp2=[kp2 i2(i,j)];
            kpl2=[kpl2 i j];
        end
    end
end

%% Key points plotting on to the image
for i=1:2:length(kpl2);
    i1=kpl2(i);
    j1=kpl2(i+1);
    i2(i1,j1)=1;
end
figure, imshow(i2);
title('2nd image with key points mapped onto it');

%% Magnitude and orientation assignment to the key points
for i=1:m-1
    for j=1:n-1
         mag(i,j)=sqrt(((i2(i+1,j)-i2(i,j))^2)+((i2(i,j+1)-i2(i,j))^2));
         oric(i,j)=atan2(((i2(i+1,j)-i2(i,j))),(i2(i,j+1)-i2(i,j)))*(180/pi);
    end
end

%% Forming key point neighbourhooods
kpmag2=[];
kpori2=[];
for x1=1:2:length(kpl2)
    k1=kpl2(x1);
    j1=kpl2(x1+1);
    if k1 > 2 && j1 > 2 && k1 < m-2 && j1 < n-2
    p1=mag(k1-2:k1+2,j1-2:j1+2);
    q1=oric(k1-2:k1+2,j1-2:j1+2);
    else
        continue;
    end
    %% Finding orientation and magnitude for the key point
[m1,n1]=size(p1);
magcounts=[];
for x=0:10:359
    magcount=0;
for i=1:m1
    for j=1:n1
        ch1=-180+x;
        ch2=-171+x;
        if ch1<0  ||  ch2<0
        if abs(q1(i,j))<abs(ch1) && abs(q1(i,j))>=abs(ch2)
            ori(i,j)=(ch1+ch2+1)/2;
            magcount=magcount+p1(i,j);
        end
        else
        if abs(q1(i,j))>abs(ch1) && abs(q1(i,j))<=abs(ch2)
            ori(i,j)=(ch1+ch2+1)/2;
            magcount=magcount+p1(i,j);
        end
        end
    end
end
magcounts=[magcounts magcount];
end
[maxvm maxvp]=max(magcounts);
kmag=maxvm;
kori=(((maxvp*10)+((maxvp-1)*10))/2)-180;
kpmag2=[kpmag2 kmag];
kpori2=[kpori2 kori];
% maxstore=[];
% for i=1:length(magcounts)
%     if magcounts(i)>=0.8*maxvm
%         maxstore=[maxstore magcounts(i) i];
%     end
% end
% 
% if maxstore > 2
%     kmag=maxstore(1:2:length(maxstore));
%     maxvp1=maxstore(2:2:length(maxstore));
%     temp=(countl((2*maxvp1)-1)+countl(2*maxvp1)+1)/2;
%     kori=temp;
% end
end

%% Forming key point Descriptors
kpd2=[];
for x1=1:2:length(kpl2)
    k1=kpl2(x1);
    j1=kpl2(x1+1);
    if k1 > 7 && j1 > 7 && k1 < m-8 && j1 < n-8
    p2=mag(k1-7:k1+8,j1-7:j1+8);
    q2=oric(k1-7:k1+8,j1-7:j1+8);
    else
        continue;
    end
    kpmagd=[];
%% Dividing into 4x4 blocks
    for k1=1:4
        for j1=1:4
            p1=p2(1+(k1-1)*4:k1*4,1+(j1-1)*4:j1*4);
            q1=q2(1+(k1-1)*4:k1*4,1+(j1-1)*4:j1*4);
            
        %% Finding orientation and magnitude for the key point
        [m1,n1]=size(p1);
        magcounts=[];
        for x=0:45:359
            magcount=0;
        for i=1:m1
            for j=1:n1
                ch1=-180+x;
                ch2=-180+45+x;
                if ch1<0  ||  ch2<0
                if abs(q1(i,j))<abs(ch1) && abs(q1(i,j))>=abs(ch2)
                    ori(i,j)=(ch1+ch2+1)/2;
                    magcount=magcount+p1(i,j);
                end
                else
                if abs(q1(i,j))>abs(ch1) && abs(q1(i,j))<=abs(ch2)
                    ori(i,j)=(ch1+ch2+1)/2;
                    magcount=magcount+p1(i,j);
                end
                end
            end
        end
        magcounts=[magcounts magcount];
        end
        kpmagd=[kpmagd magcounts];
        end
    end
    kpd2=[kpd2 kpmagd];
end
fprintf('\n\nTime taken for calculating the SIFT keys and their desccriptors for 2nd image is :%f\n\n',toc);

%% Two images key point comparision
tic
count=0;
for i=1:2:length(kpl)
    for j=1:2:length(kpl2)
        if (kpl(i)==kpl2(j))  &&   (kpl(i+1)==kpl2(j+1))
            count=count+1;
            break;
        end
    end
end
mp=(count/length(kp))*100;
fprintf('Time taken for calculating the matching percentage is :%f\n\n',toc);
fprintf('Matching percentage between 2 images by key point location is :%f \n\n',mp);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%         END OF THE PROGRAM        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%