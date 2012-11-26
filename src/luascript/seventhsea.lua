--7th sea投骰
--格式：.7 5k3+1
require("rex_pcre")
n=1
table.insert(main_help_table,".7 (dp)(k保留)(+加值) (理由) 7海投骰")
function seventhsea(msg,msg_time,buddy_name,buddy_num,qun_name,qun_num)
	--entrance
	local rex="^.7\\s(\\d*)(?:k(\\d*))?(?:\\+(\\d*))?(?:\\s(.*))?$"
	dice,hold,addup,reason=rex_pcre.match(msg,rex,1,"i")
	if (not dice) then return end

	--init
	dice=tonumber(dice)
	if (hold) then
		hold=tonumber(hold)
	else
		hold=dice
	end
	if (addup) then
		addup=tonumber(addup)
	else
		addup=0
	end
	if reason==false then reason="" end
	--处理保留部分
	if hold>10 or hold>dice then say("保留数需要比dp小且小于10",qun_num,buddy_num) return end
	--处理dp部分，根据7海规则，大于10的每个先算进保留里
	if dice>10 then
		hold=hold+dice-10
		dice=10
		--比10k10还大就放加值里
		if hold>10 then
			addup=addup+(hold-10)*10
			hold=10
		end
	end
	--proccess done

	--random init
	math.randomseed(os.time()+n)
	math.random()
	if n<10000 then n=n+1 else n=1 end
	--begin throw
	throw_result_table=seven_throw(dice)
	--end throw
	--process result
	taked_result,taked_result_table=seven_take(throw_result_table,hold)
	msg=buddy_name.."在"..msg_time.."进行"..reason.."检定:\n"
		..dice.."K"..hold.."+"..addup..":("..seven_process_result(throw_result_table)..")->("
			..seven_process_result(taked_result_table)..")="..taked_result.."+"..addup.."="..(taked_result+addup)
	for i=1,string.len(msg),700 do
		say(string.sub(msg,i,i+699),qun_num,buddy_num)
	end
	result=nil
end

function seven_process_result(r)
	s=""
	for _time,t_r in ipairs(r) do
		if(_time>1) then
			s=s..","
		end
		s=s..t_r

	end
	return s
end

function seven_take(result_table,hold)
	table.sort(result_table, function(a,b) if a>b then return true else return false end end)
	this_result_table={}
	this_result=0
	for i=1,hold do
		--print(i,this_result,result_table[i])
		this_result_table[i]=result_table[i]
		this_result=this_result+result_table[i]
	end
	return this_result,this_result_table
end

function seven_throw(dice)
	r={}
	for i=1,dice do
		local total_throw=0
		a=true
		while a do
			local this_throw=math.random(1,10)
			n=n+1
			if this_throw==10 then
				a=true
			else
				a=false
			end
			total_throw=total_throw+this_throw
		end
		--print(total_throw)
		table.insert(r,total_throw)
	end
	return r
end

function say(msg,qun_num,buddy_num)
	if qun_num==nil then
		say_buddy(msg,buddy_num)
	else
		say_qun(msg,qun_num)
	end
end

