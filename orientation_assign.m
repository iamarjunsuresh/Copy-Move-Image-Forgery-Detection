function [keys,orientation]=orientiation_assign(keypoints)

[j,nkey,no]=size(keypoints);
orient=cell(j,nkey,2);

for (i=1:j)
    im=imread(strcat('output/scales/scale-',strcat(int2str(i),'.png')));
    
    [mx,my]=size(im);
    
    disp(size(keypoints{i}));
    
end


end