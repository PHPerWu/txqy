function M = MyCloud( IM , h, w, c,CLOUD )
%����һ��3*3��ģ��
moodX=3;
moodY=3;

%��ȡԭͼ��ͨ��
R= IM(:,:,1);
G= IM(:,:,2);
B= IM(:,:,3);
%��ȡԭͼ��ͨ������



%ÿ������ȡ��ͨ����Сֵ
for i=4:h-4
	for j=4:w-4
	%�ж��Ƿ�Ϊ������
		if CLOUD(i,j)==255
	%ÿ�������������ŵ���Сֵ����M1��
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
					%----��ȡM1����Сֵ����M��
					end
				end
			end	
		else
			M(i,j)=0;
		end
		
	end
end

%imshow(M);

end