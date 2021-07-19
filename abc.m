function[]= abc(I,a,b,c)
% Inputs: I is image, theta is angles as theta-0:10:170(a:b:c)
[R,z]=radon(I,a:b:c);
figure, imagesc(a:b:c,z,R); colormap(hot); colorbar
xlabel('\theta'); ylabel('x\prime');

IR=iradon(R,b);
figure, imshow(IR);
