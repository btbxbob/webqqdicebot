n=1
table.insert(main_help_table,".tishen 得知自己的替身 测试中")
t1={
"近距离力量型",
"近距离力量型",
"近距离力量型",
"远距离操纵型",
"远距离操纵型",
"远距离操纵型",
"远距离自动操纵型",
"远距离自动操纵型",
"远距离自动操纵型",
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
----------------------------替身类型
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
			tishen_leixing="三种形态！"..t1[1].." "..t1[4].." "..t1[7]
		else
			tishen_leixing="混合形态："..t1[i1].." "..t1[i2]
		end
	end
-----------------------------替身形状
	i=0
	local tishen_xingzhuang=""
	i=math.random(1,100)
	if i<=50 then tishen_xingzhuang="单一类型"
	elseif i<=70 then tishen_xingzhuang="装备型"
	elseif i<=80 then tishen_xingzhuang="包覆本体型"
	elseif i<=85 then tishen_xingzhuang="与物质同化型"
	elseif i<=90 then tishen_xingzhuang="复数型"
	elseif i<=95 then tishen_xingzhuang="一体化型"
	else tishen_xingzhuang="分裂型"
	end
	tishen_xingzhuang=tishen_xingzhuang.."("..i..")"
-----------------------------替身属性
	i=0
	local tishen_shuxing=""
----破坏力
	i=math.random(1,100)
	if string.match(tishen_leixing,"近距离力量型")~=nil then
		i=i+10
	end
	if string.match(tishen_leixing,"远距离自动操纵型")~=nil then
		i=i+10
	end
	tishen_pohuaili=i
	tishen_shuxing=tishen_shuxing.."破坏力:"..grade(i).."("..i..") "
----速度
	i=math.random(1,100)
	if string.match(tishen_leixing,"近距离力量型")~=nil then
		i=i+10
	end
	if string.match(tishen_leixing,"远距离自动操纵型")~=nil then
		i=i+10
	end
	if string.match(tishen_leixing,"远距离操纵型")~=nil then
		i=i-20
	end
	tishen_shuxing=tishen_shuxing.."速度:"..grade(i).."("..i..") "
----射程
	i=math.random(1,100)
	if tishen_pohuaili<=30 then
		i=i+10
	end
	if string.match(tishen_leixing,"远距离自动操纵型")~=nil then
		i=i+20
	end
	if string.match(tishen_leixing,"近距离力量型")~=nil then
		i=i-40
	end
	tishen_shuxing=tishen_shuxing.."射程:"..grade(i).."("..i..") "
----持续力
	i=math.random(1,100)
	if string.match(tishen_leixing,"远距离自动操纵型")~=nil then
		i=i+20
	end
	tishen_shuxing=tishen_shuxing.."持续力:"..grade(i).."("..i..") "
----精密动作性
	i=math.random(1,100)
	tishen_shuxing=tishen_shuxing.."精密动作性:"..grade(i).."("..i..") "
----成长性
	i=math.random(1,100)
	tishen_shuxing=tishen_shuxing.."成长性:"..grade(i).."("..i..") "
-----------------------------替身原理
	tishen_yuanli="第一原理:"
	i=math.random(1,100)
	if i<=30 then tishen_yuanli=tishen_yuanli.."1级"
	elseif i<= 75 then tishen_yuanli=tishen_yuanli.."2级"
	elseif i<=85 then tishen_yuanli=tishen_yuanli.."3级"
	elseif i<=99 then tishen_yuanli=tishen_yuanli.."4级"
	elseif i==100 then tishen_yuanli=tishen_yuanli.."5级"
	end
	tishen_yuanli=tishen_yuanli.."("..i..") "
	i=math.random(1,100)
	if i<=10 then tishen_yuanli=tishen_yuanli.."心灵"
		local ii=math.random(1,100)
		if ii<=90 then  tishen_yuanli=tishen_yuanli.." 无特殊能力"
		elseif ii<=95 then tishen_yuanli=tishen_yuanli.." 记忆操纵"
		elseif ii<=100 then tishen_yuanli=tishen_yuanli.." 灵魂抽取"
		end
	elseif i<=20 then tishen_yuanli=tishen_yuanli.."能量"
	elseif i<=30 then tishen_yuanli=tishen_yuanli.."物质"
	elseif i<=40 then tishen_yuanli=tishen_yuanli.."生命"
		local ii=math.random(1,100)
		if ii<=90 then  tishen_yuanli=tishen_yuanli.." 无特殊能力"
		elseif ii<=95 then tishen_yuanli=tishen_yuanli.." 记忆操作"
		elseif ii<=100 then tishen_yuanli=tishen_yuanli.." 传染"
		end
	elseif i<=50 then tishen_yuanli=tishen_yuanli.."力场"
	elseif i<=60 then tishen_yuanli=tishen_yuanli.."时空"
		local ii=math.random(1,100)
		if ii<=90 then  tishen_yuanli=tishen_yuanli.." 无特殊能力"
		elseif ii<=95 then tishen_yuanli=tishen_yuanli.." 时间静止"
		elseif ii<=100 then tishen_yuanli=tishen_yuanli.." 时间切割"
		end
	elseif i<=70 then tishen_yuanli=tishen_yuanli.."特质"
		local ii=math.random(1,100)
		if ii<=97 then  tishen_yuanli=tishen_yuanli.." 无特殊能力"
		elseif ii<=98 then tishen_yuanli=tishen_yuanli.." 灵魂抽取"
		elseif ii<=99 then tishen_yuanli=tishen_yuanli.." 能力夺取"
		elseif ii<=100 then tishen_yuanli=tishen_yuanli.." 概念抹除"
		end
	else tishen_yuanli=tishen_yuanli.."重骰，并额外获得一种类别"
	end
----------------------------------------------
	tishen_yuanli=tishen_yuanli.."("..i..")\n第二原理:"
	i=math.random(1,100)
	if i<=10 then tishen_yuanli=tishen_yuanli.."心灵"
		local ii=math.random(1,100)
		if ii<=90 then  tishen_yuanli=tishen_yuanli.." 无特殊能力"
		elseif ii<=95 then tishen_yuanli=tishen_yuanli.." 记忆操纵"
		elseif ii<=100 then tishen_yuanli=tishen_yuanli.." 灵魂抽取"
		end
	elseif i<=20 then tishen_yuanli=tishen_yuanli.."能量"
	elseif i<=30 then tishen_yuanli=tishen_yuanli.."物质"
	elseif i<=40 then tishen_yuanli=tishen_yuanli.."生命"
		local ii=math.random(1,100)
		if ii<=90 then  tishen_yuanli=tishen_yuanli.." 无特殊能力"
		elseif ii<=95 then tishen_yuanli=tishen_yuanli.." 记忆操作"
		elseif ii<=100 then tishen_yuanli=tishen_yuanli.." 传染"
		end
	elseif i<=50 then tishen_yuanli=tishen_yuanli.."力场"
	elseif i<=60 then tishen_yuanli=tishen_yuanli.."时空"
		local ii=math.random(1,100)
		if ii<=90 then  tishen_yuanli=tishen_yuanli.." 无特殊能力"
		elseif ii<=95 then tishen_yuanli=tishen_yuanli.." 时间静止"
		elseif ii<=100 then tishen_yuanli=tishen_yuanli.." 时间切割"
		end
	elseif i<=70 then tishen_yuanli=tishen_yuanli.."特质"
		local ii=math.random(1,100)
		if ii<=97 then  tishen_yuanli=tishen_yuanli.." 无特殊能力"
		elseif ii<=98 then tishen_yuanli=tishen_yuanli.." 灵魂抽取"
		elseif ii<=99 then tishen_yuanli=tishen_yuanli.." 能力夺取"
		elseif ii<=100 then tishen_yuanli=tishen_yuanli.." 概念抹除"
		end
	else tishen_yuanli=tishen_yuanli.."重骰，并额外获得一种类别"
	end
	tishen_yuanli=tishen_yuanli.."("..i..")"
----------------------------
	local result=msg_time.."\n"..buddy_name.."投替身：\n"..tishen_leixing.."\n"..tishen_xingzhuang.."\n"..tishen_shuxing.."\n"..tishen_yuanli
	say_qun(result,qun_num)
end

function grade(input_number)
	local j=input_number
	if j==100 then return "特殊"
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


