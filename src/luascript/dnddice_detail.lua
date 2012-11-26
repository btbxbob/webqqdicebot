n=1
table.insert(main_help_table,".rr (1)d(20)(+xxx) (理由) dnd细节骰子")
function dnddice_detail(msg,msg_time,buddy_name,buddy_num,qun_name,qun_num)
	------------------
	msg=string.lower(msg)
	msg=string.gsub(msg,"%[image%]","")
	if string.match(msg, "^%.rr ")==nil then return end
	math.randomseed(os.time()+n)
	math.random()
	result=0
	if n<10000 then n=n+1 else n=1 end
	------------------
	dice=string.match(msg,"^%.rr (.+)")
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

		if tonumber(a)>200 then return end
		if tonumber(b)>9999 then return end
		--
		local resultdetail=""
		resultdetail=resultdetail.."("
		for i=1,a do
			local this_rand=math.random(1,b)
			result=result+this_rand
			if i==1 then
				resultdetail=resultdetail..tostring(this_rand)
			else
				resultdetail=resultdetail..","..tostring(this_rand)
			end
		end
		resultdetail=resultdetail..")"
		--
		local result_string=buddy_name.."在"..msg_time.."进行"..reason.."检定:\n"..dice..":"..resultdetail.." = "..result
		for i=1,string.len(result_string),513 do
			if qun_num==nil then
				say_buddy(string.sub(result_string,i,i+512),buddy_num)
			else
				say_qun(string.sub(result_string,i,i+512),qun_num)
			end
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
		local resultdetail=""
		resultdetail=resultdetail.."("
		a,isnum,b=string.match(dice,"^(%d*)(d?)(%d*)")
		if isnum=="d" then
			if b=="" then b=20 end
			if a=="" then a=1 end
			if tonumber(a)>200 then return end
			if tonumber(b)>9999 then return end
			for i=1,a do
				local this_rand=math.random(1,b)
				this_result=this_result+this_rand
				if i==1 then
					resultdetail=resultdetail..tostring(this_rand)
				else
					resultdetail=resultdetail..","..tostring(this_rand)
				end
			end
		else
			this_result=a
			resultdetail=a
		end
		resultdetail=resultdetail..")"
		table.insert(multiresult,this_result)
		result=result+this_result
		--other dices
		symb=""
		for symb,a,isnum,b in string.gmatch(dice,"([%+%-])(%d*)(d?)(%d*)") do
			print(symb,a,isnum,b)
			this_result=0
			t_resultdetail=""
			t_resultdetail=t_resultdetail.."("
			if isnum=="d" then
				if b=="" then b=20 end
				if a=="" then a=1 end
				if tonumber(a)>200 then return end
				if tonumber(b)>9999 then return end
				for i=1,a do
					local this_rand=math.random(1,b)
					this_result=this_result+this_rand
					if i==1 then
						t_resultdetail=t_resultdetail..tostring(this_rand)
					else
						t_resultdetail=t_resultdetail..","..tostring(this_rand)
					end
				end
			else
				this_result=a
				t_resultdetail=t_resultdetail..a
			end
			t_resultdetail=t_resultdetail..")"
			if symb=="-" then
				this_result=-this_result
				table.insert(multiresult,tostring(this_result))
				resultdetail=resultdetail.."-"..t_resultdetail
			else
				table.insert(multiresult,"+"..tostring(this_result))
				resultdetail=resultdetail.."+"..t_resultdetail
			end
			result=result+this_result
		end
		--resultdetail=
		detailstring=""
		for i=1,table.maxn(multiresult) do
			detailstring=detailstring..tostring(multiresult[i])
		end
		local result_string=buddy_name.."在"..msg_time.."进行"..reason.."检定:\n"..dice..":"..resultdetail.." = "..detailstring.." = "..result
		for i=1,string.len(result_string),513 do
			if qun_num==nil then
				say_buddy(string.sub(result_string,i,i+512),buddy_num)
			else
				say_qun(string.sub(result_string,i,i+512),qun_num)
			end
		end
	end
end
