function SD = MyCloud( IM,CLOUD )
%MYCLOUD Summary of this function goes here
%   Detailed explanation goes here

row=30;
line=30;
p=0.18;




[h, w, c] = size(IM);

%获取原图三通道
R= IM(:,:,1);
G= IM(:,:,2);
B= IM(:,:,3);
%获取原图三通道结束



%每个像素取三通道最小值
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



%将M中值滤波
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
%中值滤波Am-M	
median=medfilt2(temp,[row,line]);


%计算B(x,y)
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

%显示
% subplot(row,line,1) 
% imshow(IM);
% title('原图'); 

% subplot(row,line,2);  
% imshow(R)
% title('原图红色通道');  

% subplot(row,line,3);  
% imshow(G)
% title('原图绿色通道');  

% subplot(row,line,4);  
% imshow(B)
% title('原图蓝色通道');  

% subplot(row,line,5);  
% imshow(M);
% title('取三通道最小值后的图像');  

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
%Dark为暗通道图 
Dark=MyDark( IM ,h, w, c,CLOUD);

%countDark为0.1%的点的个数
countDark=floor(h*w/1000);

%IMtoGray为原图的灰度图像
IMtoGray=rgb2gray(IM);

CopyDark=Dark;
%ic矩阵横坐标存的是亮点的序号, Dcoordinate存亮点的位置
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

