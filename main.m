
%sift 
octaves=octavegen("samples/brose.png")
disp("generated octaves");
diff_of_blur(octaves);