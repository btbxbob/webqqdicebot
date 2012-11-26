--say_qun(msg,qun_num)
function random(msg,msg_time,buddy_name,buddy_num,qun_name,qun_num)
	if string.match(msg, "^random")~=nil then
		math.randomseed(os.time())
		math.random()
		say_qun(tostring(math.random()),qun_num)
	end
end
