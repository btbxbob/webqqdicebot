n=1
table.insert(main_help_table,".rw (dp)(理由) 给ronin老爷做的d10骰子。规则复杂。")
function ronind10(msg,msg_time,buddy_name,buddy_num,qun_name,qun_num)
	if string.match(msg, "^%.rw ")==nil then return end
	--else say_qun("wod骰子，还在建设中",qun_num) end
	math.randomseed(os.time()+n)
	math.random()
	result={}
	if n<10000 then n=n+1 else n=1 end
	--------------------------------------
	dice=string.match(msg,"^%.rw (.+)")
	reason=string.match(dice, ".- (.+)")
	if reason==nil then
		reason=""
	else
		dice=string.match(dice,"(.-) .+")
	end
	-----------------------------------
	a=tonumber(dice)
	if a==nil then a=1 end
	if tonumber(a)>200 then return end
	b=10

	local resultdetail=""
	resultdetail=resultdetail.."("
	for i=1,a do
		local this_rand=math.random(1,b)
			table.insert(result,this_rand)
		if i==a then
				resultdetail=resultdetail..tostring(this_rand)
		else
				resultdetail=resultdetail..tostring(this_rand)..","
		end
	end
	resultdetail=resultdetail..")"



	local result_string=buddy_name.."在"..msg_time.."进行"..reason.."检定:\n"..dice..":"..resultdetail.." : "..process_result(result)
		for i=1,string.len(result_string),513 do
			if qun_num==nil then
				say_buddy(string.sub(result_string,i,i+512),buddy_num)
			else
				say_qun(string.sub(result_string,i,i+512),qun_num)
			end
		end
end

function process_result(result)
	a=maxof(result)
	b=restof(result)
	c=mostof(result)
	return maxof({a,b,c})
end

function maxof(result)
	table.sort(result)
	return result[#result]
end

function restof(result)
	table.sort(result)
	local output=0
	for i=1,#result-1 do
		output=output+result[i]
	end
	return output
end

function mostof(result)
	local table1={}
	for i=1,#result do
		if table1[result[i]]==nil then table1[result[i]]=0 end
		table1[result[i]]=table1[result[i]]+1
	end
	k=0
	max_i=0
	for i,j in pairs(table1) do
		if j>k then k=j max_i=i end
	end
	return max_i*k
end
