local ip=""
local ip_saver=""
function setip(msg,msg_time,buddy_name,buddy_num,qun_name,qun_num)
	if qun_num~=210734129 and qun_num~=2020012687 then return end
	if string.match(msg, "^%d+%.%d+%.%d+%.%d+")==nil then return end
	ip_saver=buddy_name
	ip=msg
	say_qun("/me ³­Ğ´ÖĞ¡­¡­(.ip»ñÈ¡)",qun_num)
end

function readip(msg,msg_time,buddy_name,buddy_num,qun_name,qun_num)
	if qun_num~=210734129 and qun_num~=2020012687 then return end
	if string.match(msg, "^%.ip")==nil then return end
	say_qun(ip_saver..": "..ip,qun_num)
end
