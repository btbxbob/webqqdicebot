n=1
table.insert(main_help_table,".tishen ��֪�Լ������� ������")
t1={
"������������",
"������������",
"������������",
"Զ���������",
"Զ���������",
"Զ���������",
"Զ�����Զ�������",
"Զ�����Զ�������",
"Զ�����Զ�������",
""
}
--say_qun=print

function tishen(msg,msg_time,buddy_name,buddy_num,qun_name,qun_num)
	l_msg=string.lower(msg)
	l_msg=string.gsub(l_msg,"%[image%]","")
	if string.match(l_msg, "^%.tishen")==nil then return end
	math.randomseed(os.time()+n)
	math.random()
	if n<10000 then n=n+1 else n=1 end
----------------------------��������
	local tishen_leixing=""
	local i=0
	i=math.random(1,10)
	tishen_leixing=t1[i]
	if i==10 then
		local i1,i2
		i1=math.random(1,10)
		i2=math.random(1,10)
		while t1[i1]==t1[i2] do
			i2=math.random(1,10)
		end
		if i1==10 or i2==10 then
			tishen_leixing="������̬��"..t1[1].." "..t1[4].." "..t1[7]
		else
			tishen_leixing="�����̬��"..t1[i1].." "..t1[i2]
		end
	end
-----------------------------������״
	i=0
	local tishen_xingzhuang=""
	i=math.random(1,100)
	if i<=50 then tishen_xingzhuang="��һ����"
	elseif i<=70 then tishen_xingzhuang="װ����"
	elseif i<=80 then tishen_xingzhuang="����������"
	elseif i<=85 then tishen_xingzhuang="������ͬ����"
	elseif i<=90 then tishen_xingzhuang="������"
	elseif i<=95 then tishen_xingzhuang="һ�廯��"
	else tishen_xingzhuang="������"
	end
	tishen_xingzhuang=tishen_xingzhuang.."("..i..")"
-----------------------------��������
	i=0
	local tishen_shuxing=""
----�ƻ���
	i=math.random(1,100)
	if string.match(tishen_leixing,"������������")~=nil then
		i=i+10
	end
	if string.match(tishen_leixing,"Զ�����Զ�������")~=nil then
		i=i+10
	end
	tishen_pohuaili=i
	tishen_shuxing=tishen_shuxing.."�ƻ���:"..grade(i).."("..i..") "
----�ٶ�
	i=math.random(1,100)
	if string.match(tishen_leixing,"������������")~=nil then
		i=i+10
	end
	if string.match(tishen_leixing,"Զ�����Զ�������")~=nil then
		i=i+10
	end
	if string.match(tishen_leixing,"Զ���������")~=nil then
		i=i-20
	end
	tishen_shuxing=tishen_shuxing.."�ٶ�:"..grade(i).."("..i..") "
----���
	i=math.random(1,100)
	if tishen_pohuaili<=30 then
		i=i+10
	end
	if string.match(tishen_leixing,"Զ�����Զ�������")~=nil then
		i=i+20
	end
	if string.match(tishen_leixing,"������������")~=nil then
		i=i-40
	end
	tishen_shuxing=tishen_shuxing.."���:"..grade(i).."("..i..") "
----������
	i=math.random(1,100)
	if string.match(tishen_leixing,"Զ�����Զ�������")~=nil then
		i=i+20
	end
	tishen_shuxing=tishen_shuxing.."������:"..grade(i).."("..i..") "
----���ܶ�����
	i=math.random(1,100)
	tishen_shuxing=tishen_shuxing.."���ܶ�����:"..grade(i).."("..i..") "
----�ɳ���
	i=math.random(1,100)
	tishen_shuxing=tishen_shuxing.."�ɳ���:"..grade(i).."("..i..") "
-----------------------------����ԭ��
	tishen_yuanli="��һԭ��:"
	i=math.random(1,100)
	if i<=30 then tishen_yuanli=tishen_yuanli.."1��"
	elseif i<= 75 then tishen_yuanli=tishen_yuanli.."2��"
	elseif i<=85 then tishen_yuanli=tishen_yuanli.."3��"
	elseif i<=99 then tishen_yuanli=tishen_yuanli.."4��"
	elseif i==100 then tishen_yuanli=tishen_yuanli.."5��"
	end
	tishen_yuanli=tishen_yuanli.."("..i..") "
	i=math.random(1,100)
	if i<=10 then tishen_yuanli=tishen_yuanli.."����"
		local ii=math.random(1,100)
		if ii<=90 then  tishen_yuanli=tishen_yuanli.." ����������"
		elseif ii<=95 then tishen_yuanli=tishen_yuanli.." �������"
		elseif ii<=100 then tishen_yuanli=tishen_yuanli.." ����ȡ"
		end
	elseif i<=20 then tishen_yuanli=tishen_yuanli.."����"
	elseif i<=30 then tishen_yuanli=tishen_yuanli.."����"
	elseif i<=40 then tishen_yuanli=tishen_yuanli.."����"
		local ii=math.random(1,100)
		if ii<=90 then  tishen_yuanli=tishen_yuanli.." ����������"
		elseif ii<=95 then tishen_yuanli=tishen_yuanli.." �������"
		elseif ii<=100 then tishen_yuanli=tishen_yuanli.." ��Ⱦ"
		end
	elseif i<=50 then tishen_yuanli=tishen_yuanli.."����"
	elseif i<=60 then tishen_yuanli=tishen_yuanli.."ʱ��"
		local ii=math.random(1,100)
		if ii<=90 then  tishen_yuanli=tishen_yuanli.." ����������"
		elseif ii<=95 then tishen_yuanli=tishen_yuanli.." ʱ�侲ֹ"
		elseif ii<=100 then tishen_yuanli=tishen_yuanli.." ʱ���и�"
		end
	elseif i<=70 then tishen_yuanli=tishen_yuanli.."����"
		local ii=math.random(1,100)
		if ii<=97 then  tishen_yuanli=tishen_yuanli.." ����������"
		elseif ii<=98 then tishen_yuanli=tishen_yuanli.." ����ȡ"
		elseif ii<=99 then tishen_yuanli=tishen_yuanli.." ������ȡ"
		elseif ii<=100 then tishen_yuanli=tishen_yuanli.." ����Ĩ��"
		end
	else tishen_yuanli=tishen_yuanli.."��������������һ�����"
	end
----------------------------------------------
	tishen_yuanli=tishen_yuanli.."("..i..")\n�ڶ�ԭ��:"
	i=math.random(1,100)
	if i<=10 then tishen_yuanli=tishen_yuanli.."����"
		local ii=math.random(1,100)
		if ii<=90 then  tishen_yuanli=tishen_yuanli.." ����������"
		elseif ii<=95 then tishen_yuanli=tishen_yuanli.." �������"
		elseif ii<=100 then tishen_yuanli=tishen_yuanli.." ����ȡ"
		end
	elseif i<=20 then tishen_yuanli=tishen_yuanli.."����"
	elseif i<=30 then tishen_yuanli=tishen_yuanli.."����"
	elseif i<=40 then tishen_yuanli=tishen_yuanli.."����"
		local ii=math.random(1,100)
		if ii<=90 then  tishen_yuanli=tishen_yuanli.." ����������"
		elseif ii<=95 then tishen_yuanli=tishen_yuanli.." �������"
		elseif ii<=100 then tishen_yuanli=tishen_yuanli.." ��Ⱦ"
		end
	elseif i<=50 then tishen_yuanli=tishen_yuanli.."����"
	elseif i<=60 then tishen_yuanli=tishen_yuanli.."ʱ��"
		local ii=math.random(1,100)
		if ii<=90 then  tishen_yuanli=tishen_yuanli.." ����������"
		elseif ii<=95 then tishen_yuanli=tishen_yuanli.." ʱ�侲ֹ"
		elseif ii<=100 then tishen_yuanli=tishen_yuanli.." ʱ���и�"
		end
	elseif i<=70 then tishen_yuanli=tishen_yuanli.."����"
		local ii=math.random(1,100)
		if ii<=97 then  tishen_yuanli=tishen_yuanli.." ����������"
		elseif ii<=98 then tishen_yuanli=tishen_yuanli.." ����ȡ"
		elseif ii<=99 then tishen_yuanli=tishen_yuanli.." ������ȡ"
		elseif ii<=100 then tishen_yuanli=tishen_yuanli.." ����Ĩ��"
		end
	else tishen_yuanli=tishen_yuanli.."��������������һ�����"
	end
	tishen_yuanli=tishen_yuanli.."("..i..")"
----------------------------
	local result=msg_time.."\n"..buddy_name.."Ͷ����\n"..tishen_leixing.."\n"..tishen_xingzhuang.."\n"..tishen_shuxing.."\n"..tishen_yuanli
	say_qun(result,qun_num)
end

function grade(input_number)
	local j=input_number
	if j==100 then return "����"
	else
		j=math.floor((j-1)/20)
		if j<1 then return "E"
		elseif j==1 then return "D"
		elseif j==2 then return "C"
		elseif j==3 then return "B"
		else return "A"
		end
	end
end


