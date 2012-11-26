require("rex_pcre")

n=1
--.w 500a8,6 测试
table.insert(main_help_table,".w (dp)(a加骰)(.成功DC) (理由) wod骰子,没有加骰的临时版本")
function woddice(msg,msg_time,buddy_name,buddy_num,qun_name,qun_num)
	--if string.match(msg, "^%.w ")==nil then return end
	------------rex
	local rex="^.w\\s(\\d*)(?:a(\\d*))?(?:,(\\d*))?(?:\\s(.*))?$"
	dice,add,dc,reason=rex_pcre.match(msg,rex,1,"i")
	if (dice==nil) then return end
	if (dice==false) then return end
	dice=tonumber(dice)
	if (dice>100 or dice<0) then say("骰池最大100",qun_num,buddy_num) return end
	if (add==false) then add=10 end
	if (dc==false) then dc=8 end
	if (reason==false) then reason="" end
	add=tonumber(add)
	dc=tonumber(dc)
	if (add<2 or add>12) then say("加骰数错误",qun_num,buddy_num) return end
	if (dc <1 or dc>10) then say("DC错误",qun_num,buddy_num) return end
	------------random init
	math.randomseed(os.time()+n)
	math.random()
	result=0
	if n<10000 then n=n+1 else n=1 end
	------------init
	result={}
	local i=0
	local again=dice
	local success=0
	------------roll
	while(again>0) do
		i=i+1
		_success,again,result[i]=wod_roll(again,add,dc)
		success=success+_success
	end
	------------result
	result_string=p_result(result)
	if(string.len(result_string)>512) then
		result_string=string.sub(result_string,1,512).."..."
	end
	------------say
	msg=buddy_name.."在"..msg_time.."进行"..reason.."检定:\n"..dice.."a"..add..","..dc..":"..result_string.." = "..success.."成功"
	for i=1,string.len(msg),700 do
		say(string.sub(msg,i,i+699),qun_num,buddy_num)
	end
	result=nil
end

function p_result(r)
	s=""
	for _time,t_r in ipairs(r) do
		if(_time>1) then
			s=s.."+("
		else
			s=s.."("
		end
		for __time,num in ipairs(t_r) do
			if(__time>1) then
				s=s..","
			end
			s=s..num
		end
		s=s..")"
	end
	return s
end

function wod_roll(dice,add,dc)
	local i=1
	suc=0
	a=0
	r={}
	for i=1,dice do
		local this_throw=math.random(1,10)
		table.insert(r,this_throw)
		--print(this_throw)
		if(this_throw>=dc) then suc=suc+1 end
		if(this_throw>=add) then a=a+1 end
	end
	return suc,a,r
end

function say(msg,qun_num,buddy_num)
	if qun_num==nil then
		say_buddy(msg,buddy_num)
	else
		say_qun(msg,qun_num)
	end
end
