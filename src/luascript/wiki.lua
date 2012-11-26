require("curl")
table.insert(main_help_table,".wiki ��ѯ���� ��ѯά��")
function wiki(msg,msg_time,buddy_name,buddy_num,qun_name,qun_num)
	if string.match(msg,"^.wiki ")==nil then return end
	word=string.match(msg,"^.wiki (.+)")
	word2=string.gsub(word," ","%%20")
	if word==nil then return end
	url="http://zh.wikipedia.org/w/index.php?action=raw&title="..word2
	htmlresult={}
	local connection=curl.easy_init()
	connection:setopt(curl.OPT_URL,url)
	connection:setopt(curl.OPT_TIMEOUT,3)
	connection:setopt(curl.OPT_USERAGENT,"MyQqDicebot/4.0")
	connection:setopt(curl.OPT_WRITEFUNCTION, function(buffer) table.insert(htmlresult,buffer) return #buffer  end)
	connection:perform()
	--print(htmlresult)
	local result="��ѯ:"..word.."\n".."���:"..to_gb(remove_lable(htmlresult))
	for i=1,string.len(result),513 do
		if qun_num==nil then
			say_buddy(string.sub(result,i,i+512),buddy_num)
		else
			say_qun(string.sub(result,i,i+512),qun_num)
		end
	end

end

function remove_lable(html_string)
	--if keyword==nil then return end
	if html_string==nil then return end
	for a,html in pairs(html_string) do
		result=string.gsub(html,"%{%{.-%}%}","")
		result=string.gsub(result,"<.->","")
		result=string.gsub(result,"<.-&","")
		result=string.gsub(result,"^.->","")
		result=string.gsub(result,"%|.-\n","")
		result=string.gsub(result,"%=%=.+","")
		result=string.gsub(result,"%[%[","[")
		result=string.gsub(result,"%]%]","]")
		result=string.gsub(result,"%'%'%'","'")
		result=string.gsub(result,"\r\n","\n")
		result=string.gsub(result,"\n\n","\n")
		result=string.gsub(result,"\n\n","\n")
		result=string.gsub(result,"\n\n","\n")
		if string.match(result,"错误") then return "错误" end
		return result
	end
	return "无匹配结果"
end

--wiki(".wiki ������")
