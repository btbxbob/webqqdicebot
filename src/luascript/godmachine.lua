local name="天枢"
local oldmsg2={}
local oldmsg1={}
lanstat=0
package.path="luascript/?.lua"
require("trim")
function godmachine(msg,msg_time,buddy_name,buddy_num,qun_name,qun_num)
	--print(qun_num)
	if qun_num~=210734129 and qun_num~=2020012687 then return end
	local l_msg=string.lower(msg)
	l_msg=string.gsub(l_msg,"%[image%]","")
	l_msg=string.gsub(l_msg,"【","[")
	l_msg=string.gsub(l_msg,"】","]")
	local t_msg=trim(msg)
	-----
	if oldmsg2[qun_num]==oldmsg1[qun_num] and oldmsg1[qun_num]==t_msg then
		if t_msg=="%[image%]" then return end
		if t_msg=="……" then 	say_qun("……Nice Boat",qun_num)
		else say_qun(msg,qun_num)
		end
		oldmsg1[qun_num]="[Somethingthatwillnotrepeat]"
	end
	oldmsg2[qun_num]=oldmsg1[qun_num]
	oldmsg1[qun_num]=t_msg
	------------------------
	--吐槽
	------------------------
	if string.match(l_msg,"%[学姐%]")~=nil then say_qun("其实……我也有很多学姐。",qun_num) return end
	if string.match(l_msg,"%[aow%]")~=nil then say_qun("不给力啊！",qun_num) return end
	if string.match(l_msg,"%[魔囧%]")~=nil then say_qun("要掉线啦！",qun_num) return end
	if string.match(l_msg,"杀不？")~=nil then say_qun("杀！",qun_num) return end
	if string.match(l_msg,"睡觉")~=nil then say_qun("88",qun_num) return end
	if string.match(l_msg,"bx在么")~=nil then say_qun("在吧",qun_num) return end
	------------------------------------
	if string.match(l_msg,"爆菊")~=nil then say_qun("不要烂。",qun_num) return end
	if string.match(l_msg,"菊爆")~=nil then say_qun("不要烂。",qun_num) return end
	if string.match(l_msg,"插忽")~=nil then say_qun("不要烂。",qun_num) return end
	if string.match(l_msg,"搅基")~=nil then say_qun("不要烂。",qun_num) return end
	if string.match(l_msg,"基")~=nil or string.match(l_msg,"忽")~=nil then lanstat=lanstat+2 return else lanstat=lanstat-1 end
	if lanstat>=10 then say_qun("不要烂。\n    ——银色",qun_num) return end
	-----
	--以下部分需要包含机器人名称name
	-----
	if string.match(l_msg,name)==nil then return end
	if string.match(l_msg,name.."%?")~=nil then say_qun("嗯？",qun_num) return end
	if string.match(l_msg,name.."？")~=nil then say_qun("嗯？",qun_num) return end
	if string.match(l_msg,"抽打"..name)~=nil then say_qun("哇……只好给你骰个1",qun_num) return end
	if string.match(l_msg,"你懂.*吗")~=nil or string.match(l_msg,"你懂.*么")~=nil or string.match(l_msg,"你知道.*吗")~=nil then
		if string.match(l_msg,"占卜")~=nil then say_qun("这个可以懂",qun_num) return end
		say_qun("/me 果断表示不懂",qun_num) return
	end
	if string.match(l_msg,"贿赂")~=nil then say_qun("卢瑟，快贡献些代码来啊！",qun_num) return end

end
