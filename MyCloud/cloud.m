function SD = MyCloud( IM,CLOUD )
%MYCLOUD Summary of this function goes here
%   Detailed explanation goes here

row=30;
line=30;
p=0.18;




[h, w, c] = size(IM);

%��ȡԭͼ��ͨ��
R= IM(:,:,1);
G= IM(:,:,2);
B= IM(:,:,3);
%��ȡԭͼ��ͨ������



%ÿ������ȡ��ͨ����Сֵ
for i=1:h
	for j=1:w
		if R(i,j)<G(i,j)
			if R(i,j)<B(i,j)
				M(i,j)=R(i,j);
			else
				M(i,j)=B(i,j);
			end
		else
			if G(i,j)<B(i,j)
				M(i,j)=G(i,j);
			else
				M(i,j)=B(i,j);
			end
		end
	end
end



%��M��ֵ�˲�
Am=medfilt2(M,[row,line]);
%Am=M;


%Am-M
%Am=im2double(Am);
%M=im2double(M);
   
for i=1:h
	for j=1:w
        if Am(i,j)>M(i,j)
         temp(i,j)=Am(i,j)-M(i,j);   
        else
         temp(i,j)=M(i,j)-Am(i,j);
        end
		%temp(i,j)=abs(Am(i,j)-M(i,j));
	end
end

%temp=im2uint8(temp);
%Am=im2uint8(Am);
%M=im2uint8(M);
%��ֵ�˲�Am-M	
median=medfilt2(temp,[row,line]);


%����B(x,y)
for i=1:h
	for j=1:w
		B(i,j)=Am(i,j)-median(i,j);
	end
end

%F=max(min(p*B,M),0);
for i=1:h
	for j=1:w
		F(i,j)=max(min(p*B(i,j),M(i,j)),0);
        %F(i,j)=M(i,j);
	end
end

%��ʾ
% subplot(row,line,1) 
% imshow(IM);
% title('ԭͼ'); 

% subplot(row,line,2);  
% imshow(R)
% title('ԭͼ��ɫͨ��');  

% subplot(row,line,3);  
% imshow(G)
% title('ԭͼ��ɫͨ��');  

% subplot(row,line,4);  
% imshow(B)
% title('ԭͼ��ɫͨ��');  

% subplot(row,line,5);  
% imshow(M);
% title('ȡ��ͨ����Сֵ���ͼ��');  

%imshow(rgb2gray(IM));
%imshow(M);
 % subplot(row,line,1) 
 % imshow(Am);
 % title('Am'); 
 
 % subplot(row,line,2) 
 % imshow(B);
 % title('B'); 

% subplot(row,line,3) 
% imshow(F);
% title('F');
%DarkΪ��ͨ��ͼ 
Dark=MyDark( IM ,h, w, c,CLOUD);

%countDarkΪ0.1%�ĵ�ĸ���
countDark=floor(h*w/1000);

%IMtoGrayΪԭͼ�ĻҶ�ͼ��
IMtoGray=rgb2gray(IM);

CopyDark=Dark;
%ic���������������������, Dcoordinate�������λ��
Dcoordinate=zeros(floor(countDark/1),1);
for ic=1:countDark
	temp=find(CopyDark==max(max(CopyDark)));
	Dcoordinate(ic,1)=temp(1,1);
	CopyDark(temp(1,1))=0;
end

LuvIM=colorspace('Luv<-RGB',IM);

  LightIM=zeros(floor(countDark/1),1);
for ic=1:countDark
    x=ceil(Dcoordinate(ic,1)/w);
    y=rem(Dcoordinate(ic,1),w);
    if y<1
        y=w;
    end
   
    LightIM(ic,1)=LuvIM(x,y,1);
end
J=LuvIM;
A=max(max(LightIM));

%J=(IM-F)/(1-F/A);

for i=1:h
	for j=1:w
		if CLOUD(i,j)==255
		J(i,j,1)=(LuvIM(i,j,1)-F(i,j))/(1-F(i,j)/A);
		else
		J(i,j,1)=LuvIM(i,j,1);
		end
	end
end

resultIM=colorspace('RGB<-Luv',J);
imshow(resultIM);
end

