local name="����"
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
	l_msg=string.gsub(l_msg,"��","[")
	l_msg=string.gsub(l_msg,"��","]")
	local t_msg=trim(msg)
	-----
	if oldmsg2[qun_num]==oldmsg1[qun_num] and oldmsg1[qun_num]==t_msg then
		if t_msg=="%[image%]" then return end
		if t_msg=="����" then 	say_qun("����Nice Boat",qun_num)
		else say_qun(msg,qun_num)
		end
		oldmsg1[qun_num]="[Somethingthatwillnotrepeat]"
	end
	oldmsg2[qun_num]=oldmsg1[qun_num]
	oldmsg1[qun_num]=t_msg
	------------------------
	--�²�
	------------------------
	if string.match(l_msg,"%[ѧ��%]")~=nil then say_qun("��ʵ������Ҳ�кܶ�ѧ�㡣",qun_num) return end
	if string.match(l_msg,"%[aow%]")~=nil then say_qun("����������",qun_num) return end
	if string.match(l_msg,"%[ħ��%]")~=nil then say_qun("Ҫ��������",qun_num) return end
	if string.match(l_msg,"ɱ����")~=nil then say_qun("ɱ��",qun_num) return end
	if string.match(l_msg,"˯��")~=nil then say_qun("88",qun_num) return end
	if string.match(l_msg,"bx��ô")~=nil then say_qun("�ڰ�",qun_num) return end
	------------------------------------
	if string.match(l_msg,"����")~=nil then say_qun("��Ҫ�á�",qun_num) return end
	if string.match(l_msg,"�ձ�")~=nil then say_qun("��Ҫ�á�",qun_num) return end
	if string.match(l_msg,"���")~=nil then say_qun("��Ҫ�á�",qun_num) return end
	if string.match(l_msg,"����")~=nil then say_qun("��Ҫ�á�",qun_num) return end
	if string.match(l_msg,"��")~=nil or string.match(l_msg,"��")~=nil then lanstat=lanstat+2 return else lanstat=lanstat-1 end
	if lanstat>=10 then say_qun("��Ҫ�á�\n    ������ɫ",qun_num) return end
	-----
	--���²�����Ҫ��������������name
	-----
	if string.match(l_msg,name)==nil then return end
	if string.match(l_msg,name.."%?")~=nil then say_qun("�ţ�",qun_num) return end
	if string.match(l_msg,name.."��")~=nil then say_qun("�ţ�",qun_num) return end
	if string.match(l_msg,"���"..name)~=nil then say_qun("�ۡ���ֻ�ø�������1",qun_num) return end
	if string.match(l_msg,"�㶮.*��")~=nil or string.match(l_msg,"�㶮.*ô")~=nil or string.match(l_msg,"��֪��.*��")~=nil then
		if string.match(l_msg,"ռ��")~=nil then say_qun("������Զ�",qun_num) return end
		say_qun("/me ���ϱ�ʾ����",qun_num) return
	end
	if string.match(l_msg,"��¸")~=nil then say_qun("¬ɪ���칱��Щ����������",qun_num) return end

end
