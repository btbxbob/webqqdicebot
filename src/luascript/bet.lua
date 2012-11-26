require("curl")
--require("icu")
--local U=require(icu.ustring)
table.insert(main_help_table,"获取投注功能，测试中")
--say_qun=print

function bet(msg,msg_time,buddy_name,buddy_num,qun_name,qun_num)
	--if qun_num~=210734129 and qun_num~=2020012687 and qun_num~=2111751848 then return end
	if string.match(msg,"^.bet")==nil then return end
	local htmlresult=""
	local url="http://trow.cn/misc/forbx.php"
	connection=curl.easy_init()
	connection:setopt(curl.OPT_URL,url)
	connection:setopt(curl.OPT_TIMEOUT,3)
	connection:setopt(curl.OPT_COOKIE,"pass_hash=855ff5e457cd5f8aec8b9cd365deb407;member_id=38557")
	connection:setopt(curl.OPT_USERAGENT,"MyQqDicebot/4.0")
	connection:setopt(curl.OPT_WRITEFUNCTION, function(buffer) htmlresult=htmlresult..buffer return #buffer  end)
	connection:perform()
	--htmlresult=icu.convert(htmlresult,"utf8","gb2312")
	htmlresult=to_gb(htmlresult)
	local bet_table={}
	--print(htmlresult)
	for p_name,p_date,p_content in string.gmatch(htmlresult,"%<div% class=[%'%\"]posttopbar[%'%\"]%>.-name[%'%\"]%>(.-)%<%/div%>.-postdate[%'%\"]%>(.-)%<%/div%>.-content[%'%\"]%>(.-)%<%/div%>") do
		p_content=string.gsub(p_content,"；"," ")
		p_content=string.gsub(p_content,"<br %/>","\n")
		--print(p_name,p_date)
		for team,win,bets in string.gmatch(p_content,".* (.- VS .-) (.-) (.-)注.-\n") do
			--team=string.match(team,".* (.- VS .-) ")
			if bets~=nil and p_name~="inthel" then
				if bets=="公益" then bets=1 end
				print(p_name,team,win,bets)
				if bet_table[team]==nil then bet_table[team]={} end
				if bet_table[team][win]==nil then bet_table[team][win]=0 end
				bet_table[team][win]=bet_table[team][win]+(tonumber(bets) or 1)
				print(bet_table[team][win])
			end
		end
	end
	local result="http://trow.cn/forum/index.php?showtopic=19841\n"
	for i,j in pairs(bet_table) do
		result=result.."==="..i..":\n"
		for k,l in pairs(j) do
			result=result..k.."  共"..l.."注\n"
			print(k,l)
		end
	end
	say_qun(result,qun_num)
	return
end

--bet(".bet ")
