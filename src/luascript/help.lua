function help(msg,msg_time,buddy_name,buddy_num,qun_name,qun_num)
	if string.match(msg,"^%.help")==nil then return end
	local result=""
	for i=1 , table.maxn(main_help_table) do
		result=result..main_help_table[i].."\n"
		if string.len(result..main_help_table[i])>600 then
			say_qun(result,qun_num)
		end
	end
	say_qun(result,qun_num)
end
