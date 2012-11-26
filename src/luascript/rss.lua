require("curl")
--require("LuaXML")
--require("bit")
--require("lanes")
sites={}
sites["mydrivers"]="http://rss.mydrivers.com/rss.aspx?Tid=1"
sites["solidot"]="http://feeds.feedburner.com/solidot"



function rss(msg,msg_time,buddy_name,buddy_num,qun_name,qun_num)
	if string.match(msg,"^%.rss")==nil then return end
	command=string.match(msg,"^%.rss (.*)")
	if command=="refresh" or command=="更新" then
		for i,j in pairs(sites) do
			get_rss(i,j)
		end
		say_qun("开始更新rss",qun_num)
	return end
	if command=="read" or command=="显示" then
		local result=""
		for i,j in pairs(sites) do
			result=result.."-=="..i.."==-"..":\n"..read_rss(i)
		end
		for i=1,string.len(result),513 do

			--if string.byte(result,i+512)>127 then

			--end

			result_piece=string.sub(result,i,i+512)
						if qun_num==nil then
				say_buddy(result_piece,buddy_num)
			else
				say_qun(result_piece,qun_num)
			end
		end
	return end
end

lock=0
function get_rss(name,url)
	lock=1
	co=coroutine.create(function()
		print("start")
		rssfile=io.open(name.."_rss.xml","w+")
		connection=curl.easy_init()
		connection:setopt(curl.OPT_URL,url)
		--connection:setopt(curl.OPT_TIMEOUT,3)
		connection:setopt(curl.OPT_USERAGENT,"MyQqDicebot/4.0")
		connection:setopt(curl.OPT_WRITEFUNCTION, function(buffer) rssfile:write(buffer) return #buffer  end)
		connection:perform()
		print("done")
		lock=0
	end)
	--result=co()
	--print("yes?")
	--co()
	--print("yes?")
	coroutine.resume(co)
end

function read_rss(name)
	--print(lock)
	local items={}
	local result=""
	while(lock==1) do end
	local xfile=io.open(name.."_rss.xml","r")
	local xcontent=xfile:read("*a")
	if is_utf8(xcontent) then xcontent=to_gb(xcontent) end
	--xml.registerCode("一","一")
	for item in string.gmatch(xcontent,"%<item%>.-%<%/item%>") do
		--print(item)
		table.insert(items,item)
	end
	local i=1
	while items[i]~=nil do
		item=items[i]
		if item~=nil then
			if string.match(item,"%<title%>%<%!%[CDATA%[(.-)%]%]%>%<%/title%>")~=nil then
			result=result..string.match(item,"%<title%>%<%!%[CDATA%[(.-)%]%]%>%<%/title%>").."\n"
			else result=result..string.match(item,"%<title%>(.-)%<%/title%>").."\n"
			end
		end
		i=i+1
		if i>4 then break end
	end
	--print(result)
	return result
end

function is_utf8(html_string) --获取编码方式
	--for a,html in pairs(html_string) do
		charset=string.match(html_string,"[uU][tT][fF]%-8")
		if charset~=nil then return true end
	--end
	return false
end

--get_rss("mydrivers","http://rss.mydrivers.com/rss.aspx?Tid=1")
--print(read_rss("solidot"))
