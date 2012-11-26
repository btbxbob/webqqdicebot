n=1
package.path="luascript/?.lua"
require("trim")
local name="knight"
local oldmsg2={}
local oldmsg1={}
reaction={
"嗯？哦\n你……你错群了！",
"啊？哦\n瞎了我的狗眼！",
"啊？哦\n……",
"啊？哦\n你……你们叉叉界！",
"啊？哦\n快放下那个师太！",
"( ⊙ o ⊙ )啊！\n[buddy_name]最厉害了！",
"啥？\n“不小心”踩了[buddy_name]一脚。"
}
function knight(msg,msg_time,buddy_name,buddy_num,qun_name,qun_num)
	print(qun_num)
	if qun_num~=2111751848 and qun_num~=2020012687 then return end
	math.randomseed(os.time()+n)
	math.random()
	--result=0
	if n<10000 then n=n+1 else n=1 end
	local l_msg=string.lower(msg)
    l_msg=string.gsub(l_msg,"%[image%]","")
	if l_msg=="" then return end
	local t_msg=trim(msg)
	if oldmsg2[qun_num]==oldmsg1[qun_num] and oldmsg1[qun_num]==t_msg then
		if t_msg=="……" then say_qun("……Nice Boat",qun_num) return end
		local word_jie=string.match(l_msg,"你们(.*)界")
		if word_jie~=nil and string.match(l_msg,"你们都是.*界的！")==nil then say_qun("你们都是"..word_jie.."界的！",qun_num) return end
		oldmsg1[qun_num]="[Somethingthatwillnotrepeat]"
		oldmsg2[qun_num]="[Somethingthatwillnotrepeat]"
		say_qun(msg,qun_num)
	end
	oldmsg2[qun_num]=oldmsg1[qun_num]
	oldmsg1[qun_num]=t_msg

	if ((string.match(l_msg,"%.fate") or string.match(l_msg,"%.zhan") )
	and
		(
			(
			string.match(l_msg,"还是") and
				(string.match(l_msg,"爱") or string.match(l_msg,"喜欢") or string.match(l_msg,"比较好"))
			)
		)
	) then say_qun("/me 紧紧抱住"..buddy_name..":“我真没用，居然让你问出这样的问题……”",qun_num) return end

	if string.match(l_msg,name)==nil then return end
	if string.match(l_msg,name.."%?")~=nil and tonumber(buddy_num)==241950376 then say_qun("嗯？我回来了！",qun_num) return end
	if string.match(l_msg,name.."讨厌")~=nil and tonumber(buddy_num)==241950376 then say_qun("……",qun_num) return end
	if string.match(l_msg,name.."%?")~=nil and tonumber(buddy_num)==289828069 then say_qun("嗯？不嫌烦吗？",qun_num) return end
	if string.match(l_msg,name.."%?")~=nil or string.match(l_msg,name.."？")~=nil then
		local choice=math.random(1,3)
		if choice==1 then say_qun("嗯？",qun_num) return
		elseif choice==2 then say_qun("啊？",qun_num) return
		elseif choice==3 then say_qun("啥？",qun_num) return
		end
	return end
	if string.match(l_msg,"给我")~=nil and tonumber(buddy_num)==241950376 then say_qun("哎！",qun_num) return end

	if string.match(l_msg,"给我")~=nil then say_qun("你不怕被安仔揍吗？",qun_num) return end
	if string.match(l_msg,"安仔喜欢你你懂吗")~=nil then say_qun("这个可以懂。",qun_num) return end
	if string.match(l_msg,"你懂.*吗")~=nil then
		if string.match(l_msg,"安仔")~=nil then say_qun("这个嘛……\n/me 遁了",qun_num) return end
		say_qun("/me 果断表示不懂",qun_num) return
	end
	if string.match(l_msg,"你懂么")~=nil then say_qun("/me 果断表示不懂",qun_num) return end
	if string.match(l_msg,"给点反应！")~=nil then
		local result_str=reaction[math.random(1,table.maxn(reaction))]
		result_str=string.gsub(result_str,"%[buddy_name%]",buddy_name)
		say_qun(result_str,qun_num)
		return
	end
end
