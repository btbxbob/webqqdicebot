require("curl")
--table.insert(main_help_table,"获取链接功能，目前有乱码问题。")
function getlink(msg,msg_time,buddy_name,buddy_num,qun_name,qun_num)
	if string.match(msg,"http:%/%/")==nil then return end
	if string.match(msg,"%.escape ") then return end
	url=string.match(msg,"(http:%/%/[%w%p]+)%c*.*$")
	if url==nil then return end
	local htmlresult={}
	if string.match(url,"web%.qq%.com") then return end
	if string.match(url,"web2%.qq%.com") then return end
	if string.match(url,"web3%.qq%.com") then return end
	if string.match(url,"apple%.qq%.com") then return end
	if string.match(url,"mobile%.qq%.com") then return end
	if string.match(url,"www%.anobii%.com") then return end
	if string.match(url,"youtube") then return end
	if string.match(url,"220%.170%.79%.48") then return end
	if string.match(url,"bbs%.saraba1st%.com") then return end
	local connection=curl.easy_init()
	connection:setopt(curl.OPT_URL,url)
	connection:setopt(curl.OPT_TIMEOUT,3)
	if string.match(url,"trow%.cn") then connection:setopt(curl.OPT_COOKIE,"pass_hash=855ff5e457cd5f8aec8b9cd365deb407;member_id=38557") end
	if string.match(url,"trow%.cc") then connection:setopt(curl.OPT_COOKIE,"pass_hash=855ff5e457cd5f8aec8b9cd365deb407;member_id=38557") end
	--if string.match(url,"bbs%.saraba1st%.com") then connection:setopt(curl.OPT_COOKIE,"cdb_sid=ai36iI;cdb_auth=b029jgssTZPEtwPeSF2qBRcmOl7DdKf16Vs4WDp1DcwuMgvQFlqjyD9lPr599wxp%2FxomBXkMhm%2Fix%2By%2BKwMNo%2BCJscYN") end
	connection:setopt(curl.OPT_USERAGENT,"MyQqDicebot/4.0")
	--connection:setopt(curl.OPT_LOCALPORT,54461)
	connection:setopt(curl.OPT_WRITEFUNCTION, function(buffer) table.insert(htmlresult,buffer) return #buffer  end)
	connection:perform()
	--connection:cleanup()
	title=get_title(htmlresult)
	--print(title)
	if title then
		if is_utf8(htmlresult) then title=to_gb(title) end
		title=string.gsub(title,"\n","")
		print(title)
		if qun_num==nil then
			say_buddy(title,buddy_num)
		else
			say_qun(title,qun_num)
		end
	else return end
	connection=nil
end

function is_utf8(html_string) --获取编码方式
	for a,html in pairs(html_string) do
		charset=string.match(html,"[cC][hH][Aa][Rr][Ss][Ee][Tt]=[uU][tT][fF]")
		if charset~=nil then return true end
	end
	return false
end

function get_title(html_string) --获取网页标题
	for a,html in pairs(html_string) do
		title=string.match(html,"<[Tt][Ii][Tt][Ll][Ee]>(.-)<%/[Tt][Ii][Tt][Ll][Ee]>")
		if title~=nil then return title end
	end
	return false
end

--print(is_utf8({1,"charset=utf8"}))
--getlink("看这个http://www.baidu.com\nxxxxxx\nyesyesyes")

