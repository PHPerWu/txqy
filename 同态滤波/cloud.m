function SC = cloud(f)
k=4;
f1=log(1+double(f));
pq=paddedsize(size(f1));
d0=0.05*pq(1);
H=1-lpfilter('btw',pq(1),pq(2),d0,3);
H=fftshift(H);
F=fft2(f1,size(H,1),size(H,2));
J=ifft2(k.*F);
G=real(ifft2(k.*F));
G=G(1:size(f,1),1:size(f,2));
G=exp(double(G))-1;
G=im2uint8(mat2gray(G,[min(G(:)),max(G(:))]));
figure,imshow(G);

end

