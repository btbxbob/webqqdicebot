require("curl")
table.insert(main_help_table,".escape (url) 获取编码后的url")
require("trim")
function escape(msg,msg_time,buddy_name,buddy_num,qun_name,qun_num)
	if string.match(msg,"%.escape ")==nil then return end
	url=string.match(msg,"^%.escape (.+)$")
	url=trim(url)
	new_url=string.gsub(url,"[^%p]",function(s) return curl.escape(s) end)
	--print(new_url)
	if qun_num==nil then
		say_buddy(new_url,buddy_num)
	else
		say_qun(new_url,qun_num)
	end
end
