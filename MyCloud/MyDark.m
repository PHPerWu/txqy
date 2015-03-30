function M = MyCloud( IM , h, w, c )
%定义一个3*3的模板
moodX=3;
moodY=3;

%获取原图三通道
R= IM(:,:,1);
G= IM(:,:,2);
B= IM(:,:,3);
%获取原图三通道结束



%每个像素取三通道最小值
for i=4:h-4
	for j=4:w-4
	%每个像素四周三排的最小值存在M1中
		for i1=i-3:i+3
			for j1=j-3:j+3
				if R(i1,j1)<G(i1,j1)
					if R(i1,j1)<B(i1,j1)
						M1(i1,j1)=R(i1,j1);
					else
						M1(i1,j1)=B(i1,j1);
					end
				else
					if G(i1,j1)<B(i1,j1)
						M1(i1,j1)=G(i1,j1);
					else
						M1(i1,j1)=B(i1,j1);
					end
				end
			end
		end	
		M(i,j)=M1(i,j);
		for i1=i-3:i+3
			for j1=j-3:j+3
				if M(i,j)>M1(i1,j1);
					M(i,j)=M1(i1,j1);
				%----获取M1中最小值存在M中
				end
			end
		end	
		
		
	end
end

imshow(M);

end