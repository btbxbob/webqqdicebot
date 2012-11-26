n=1
table.insert(main_help_table,".r (1)d(20)(+xxx) (理由) dnd骰子")
function dnddice(msg,msg_time,buddy_name,buddy_num,qun_name,qun_num)
	------------------
	msg=string.lower(msg)
	msg=string.gsub(msg,"%[image%]","")
	if string.match(msg, "^%.r ")==nil then return end
	math.randomseed(os.time()+n)
	math.random()
	result=0
	if n<10000 then n=n+1 else n=1 end
	------------------
	dice=string.match(msg,"^%.r (.+)")
	reason=string.match(dice, ".- (.+)")
	if dice==nil then return end
	if reason==nil then
		reason=""
	else
		dice=string.match(dice,"(.-) .+")
	end
	if string.match(dice, "[%+%-]")==nil then
		--(a)d(b)
		a=0
		b=0
		a,b=string.match(dice,"(%d*)d(%d*)")
		if b=="" then b=20 end
		if a=="" then a=1 end
		if tonumber(a)>9999 then return end
		if tonumber(b)>9999 then return end
		for i=1,a do
			result=result+math.random(1,b)
		end
		if qun_num==nil then
		say_buddy(buddy_name.."在"..msg_time.."进行"..reason.."检定:\n"..dice.." = "..result,buddy_num)
		else
		say_qun(buddy_name.."在"..msg_time.."进行"..reason.."检定:\n"..dice.." = "..result,qun_num)
		end
	else
		--first dice
		--(a)d(b)

		multiresult={}
		this_result=0
		result=0
		a=0
		b=0
		isnum=""
		a,isnum,b=string.match(dice,"^(%d*)(d?)(%d*)")
		if isnum=="d" then
			if b=="" then b=20 end
			if a=="" then a=1 end
			if tonumber(a)>9999 then return end
			if tonumber(b)>9999 then return end
			for i=1,a do
				this_result=this_result+math.random(1,b)
			end
		else this_result=a end
		table.insert(multiresult,this_result)
		result=result+this_result
		--other dices
		symb=""
		for symb,a,isnum,b in string.gmatch(dice,"([%+%-])(%d*)(d?)(%d*)") do
			print(symb,a,isnum,b)
			this_result=0
			if isnum=="d" then
				if b=="" then b=20 end
				if a=="" then a=1 end
				if tonumber(a)>9999 then return end
				if tonumber(b)>9999 then return end
				for i=1,a do
					this_result=this_result+math.random(1,b)
				end
			else this_result=tonumber(a) end
			if symb=="-" then
				this_result=-this_result
				table.insert(multiresult,tostring(this_result))
			else
				table.insert(multiresult,"+"..tostring(this_result))
			end
			result=result+this_result
		end
		detailstring=""
		for i=1,table.maxn(multiresult) do
			detailstring=detailstring..tostring(multiresult[i])
		end
		if qun_num==nil then
			say_buddy(buddy_name.."在"..msg_time.."进行"..reason.."检定:\n"..dice.." = "..detailstring.." = "..result,buddy_num)
		else
			say_qun(buddy_name.."在"..msg_time.."进行"..reason.."检定:\n"..dice.." = "..detailstring.." = "..result,qun_num)
		end

	end
end
