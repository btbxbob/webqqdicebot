require("curl")
table.insert(main_help_table,".dict 查询内容 查询金山i词霸")
function dictionary(msg,msg_time,buddy_name,buddy_num,qun_name,qun_num)
	if string.match(msg,"^.dict ")==nil then return end
	word=string.match(msg,"^.dict (.+)")
	word2=string.gsub(word," ","%%20")
	if word==nil then return end
	url="http://dict-co.iciba.com/api/dictionary.php?w="..word2
	htmlresult={}
	local connection=curl.easy_init()
	connection:setopt(curl.OPT_URL,url)
	connection:setopt(curl.OPT_TIMEOUT,3)
	connection:setopt(curl.OPT_WRITEFUNCTION, function(buffer) table.insert(htmlresult,buffer) return #buffer  end)
	connection:perform()
	print(get_txt("trans",htmlresult))
	local result="查询:"..word.."\n".."结果:"..to_gb(get_txt("acceptation",htmlresult)).."\n".."发音:"..get_txt("pron",htmlresult)
	if qun_num==nil then
		say_buddy(result,buddy_num)
	else
		say_qun(result,qun_num)
	end
end

function get_txt(keyword,html_string)
	if keyword==nil then return end
	if html_string==nil then return end
	for a,html in pairs(html_string) do
		--print(html)
		txt=string.match(html,"<"..keyword..">(.-)<%/"..keyword..">")
		if txt~=nil then return txt end
	end
	return "无结果"
end

--dictionary(".dictionary take two")
