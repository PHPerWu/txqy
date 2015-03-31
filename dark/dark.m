function dark(img_name,CLOUD)
%��Ӱȥ���㷨
%filename------�ļ������ļ�����·��
%�÷���dark('7.png')
close all
clc

tt = cputime; 

% ԭʼͼ��
I = double(imread(img_name)) / 255;
% ��ȡͼ���С
[h,w,c] = size(I);
win_size = 7;
%ȥ��ϵ��
w0  = 1.2;
img_size = w * h;
%��ʼ�����ͼ��
dehaze = zeros(h,w,c);
%��ʼ����Ӱͨ��ͼ��
win_dark = ones(h,w);

%����ֿ�darkchannel
 for j=1+win_size:w-win_size
    for i=win_size+1:h-win_size
        win_dark(i,j)=min(I(i,j,:));
        for n=j-win_size:j+win_size
            for m=i-win_size:i+win_size
                if(win_dark(m,n)>win_dark(i,j))
                    win_dark(m,n)=win_dark(i,j);
                end
            end
        end      
    end
 end
 

%�����������A
dark_channel = win_dark;
times = round(img_size * 0.001);
A = 0;

for m=1:times
    most_bright=max(max(dark_channel));
    [i,j]=find(dark_channel==most_bright);
    i=i(1);j=j(1);
    average=mean(I(i,j,:));
    if average > A
        A=average;
    end
    dark_channel(i,j)=0;
end

%����transmission map
transmission = 1 - w0 * win_dark / A;

%����ԭͼ��ĻҶ�ͼ
gray_I = zeros(img_size ,1);
gray_I = reshape(gray_I,h,w);
for i=1:h
    for j=1:w
        gray_I(i,j) = mean(I(i,j,:));
    end
end
%��guided filter��trasmission map��soft matting
p = transmission;
r = 60;
eps = 10^-6;
transmission_filter = guidedfilter(gray_I, p, r, eps);

%ƽ������
r = 8;
eps = 0.2^2;
transmission_smooth = guidedfilter(transmission_filter, transmission_filter, r, eps);


t0=0.1;
for i=1:c
    for j=1:h
        for l=1:w
			if CLOUD(j,l)==255
            dehaze(j,l,i)=(I(j,l,i)-A)/max(t0,transmission_smooth(j,l))+A;
			else
			dehaze(j,l,i)=I(j,l,i);
			end
        end
    end
end

figure,
imshow(I);
figure,
imshow(dehaze);

time=cputime-tt;
disp(time);

