router_stat=0
function router(msg,msg_time,buddy_name,buddy_num,qun_name,qun_num)
	--from test qun to trow
	if router_stat==1 then
		if qun_num==204925640 then
			o_msg="["..qun_name.."]"..buddy_name..":\n"..msg
			say_qun(o_msg,210734129)
		end
	end
	if qun_num~=210734129 then return end
	if string.match(msg,"%.router on")~=nil then 
		router_stat=1
		say_qun("开始转播八卦了！不看八卦会死星人们！",210734129)
	end
	if string.match(msg,"%.router off")~=nil then 
		router_stat=0 
		say_qun("散了散了，没八卦了!",210734129)
	end
end

