n=1
package.path="luascript/?.lua"
require("trim")
local name="knight"
local oldmsg2={}
local oldmsg1={}
reaction={
"�ţ�Ŷ\n�㡭�����Ⱥ�ˣ�",
"����Ŷ\nϹ���ҵĹ��ۣ�",
"����Ŷ\n����",
"����Ŷ\n�㡭�����ǲ��磡",
"����Ŷ\n������Ǹ�ʦ̫��",
"( �� o �� )����\n[buddy_name]�������ˣ�",
"ɶ��\n����С�ġ�����[buddy_name]һ�š�"
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
		if t_msg=="����" then say_qun("����Nice Boat",qun_num) return end
		local word_jie=string.match(l_msg,"����(.*)��")
		if word_jie~=nil and string.match(l_msg,"���Ƕ���.*��ģ�")==nil then say_qun("���Ƕ���"..word_jie.."��ģ�",qun_num) return end
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
			string.match(l_msg,"����") and
				(string.match(l_msg,"��") or string.match(l_msg,"ϲ��") or string.match(l_msg,"�ȽϺ�"))
			)
		)
	) then say_qun("/me ������ס"..buddy_name..":������û�ã���Ȼ�����ʳ����������⡭����",qun_num) return end

	if string.match(l_msg,name)==nil then return end
	if string.match(l_msg,name.."%?")~=nil and tonumber(buddy_num)==241950376 then say_qun("�ţ��һ����ˣ�",qun_num) return end
	if string.match(l_msg,name.."����")~=nil and tonumber(buddy_num)==241950376 then say_qun("����",qun_num) return end
	if string.match(l_msg,name.."%?")~=nil and tonumber(buddy_num)==289828069 then say_qun("�ţ����ӷ���",qun_num) return end
	if string.match(l_msg,name.."%?")~=nil or string.match(l_msg,name.."��")~=nil then
		local choice=math.random(1,3)
		if choice==1 then say_qun("�ţ�",qun_num) return
		elseif choice==2 then say_qun("����",qun_num) return
		elseif choice==3 then say_qun("ɶ��",qun_num) return
		end
	return end
	if string.match(l_msg,"����")~=nil and tonumber(buddy_num)==241950376 then say_qun("����",qun_num) return end

	if string.match(l_msg,"����")~=nil then say_qun("�㲻�±���������",qun_num) return end
	if string.match(l_msg,"����ϲ�����㶮��")~=nil then say_qun("������Զ���",qun_num) return end
	if string.match(l_msg,"�㶮.*��")~=nil then
		if string.match(l_msg,"����")~=nil then say_qun("������\n/me ����",qun_num) return end
		say_qun("/me ���ϱ�ʾ����",qun_num) return
	end
	if string.match(l_msg,"�㶮ô")~=nil then say_qun("/me ���ϱ�ʾ����",qun_num) return end
	if string.match(l_msg,"���㷴Ӧ��")~=nil then
		local result_str=reaction[math.random(1,table.maxn(reaction))]
		result_str=string.gsub(result_str,"%[buddy_name%]",buddy_name)
		say_qun(result_str,qun_num)
		return
	end
end
