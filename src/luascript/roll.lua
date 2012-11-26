n=1
table.insert(main_help_table,".roll (数字) 大概就和魔兽一样吧。")
function roll(msg,msg_time,buddy_name,buddy_num,qun_name,qun_num)
	if string.match(msg, "^%.roll")==nil then return end
	math.randomseed(os.time()+n)
	math.random()
	if n<10000 then n=n+1 end
	max=string.match(msg, "^%.roll (%d+)")
	if max==nil then return end
	if tonumber(max)>10000 then return end
	result=msg_time.."\n"..buddy_name.."进行投掷（最大"..max.."点）："..math.random(1,max)
	say_qun(result,qun_num)
end
