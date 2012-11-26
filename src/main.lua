package.cpath=".\\luascript\\?.dll"
package.path=".\\luascript\\?.lua"

main_help_table={
"qqdicebot,第4版。开发者：BX。\n免责声明：本机器人提供的内容要么来自网上，要么来自一些会打字的大猩猩。对这些内容的真实可信性开发者概不负责。\n帮助链接：http://trow.cc/forum/index.php?showtopic=19753"
}
--loadfile("luascript\\random.lua")()
--loadfile("luascript\\bet.lua")()
--2月5日改用require
require"dnddice"
require"woddice"
require"roll"
require"getlink"
require"dictionary"
require"wiki"
require"knight"
require"godmachine"
require"zhan"
require"fate"
require"fruit"
require"help"
require"dnddice_detail"
require"tishen"
require"escape"
require"rememberip"
require"TALK"
require"seventhsea"
require"scp"
--loadfile("luascript\\router.lua")()
--loadfile("luascript\\rss.lua")()


function main(msg,msg_time,buddy_name,buddy_num,qun_name,qun_num)
	if msg==nil then return end
	escape(msg,msg_time,buddy_name,buddy_num,qun_name,qun_num)
	--bet(msg,msg_time,buddy_name,buddy_num,qun_name,qun_num)
	getlink(msg,msg_time,buddy_name,buddy_num,qun_name,qun_num)
	roll(msg,msg_time,buddy_name,buddy_num,qun_name,qun_num)
	dnddice(msg,msg_time,buddy_name,buddy_num,qun_name,qun_num)
	woddice(msg,msg_time,buddy_name,buddy_num,qun_name,qun_num)
	seventhsea(msg,msg_time,buddy_name,buddy_num,qun_name,qun_num)
	dictionary(msg,msg_time,buddy_name,buddy_num,qun_name,qun_num)
	wiki(msg,msg_time,buddy_name,buddy_num,qun_name,qun_num)
	knight(msg,msg_time,buddy_name,buddy_num,qun_name,qun_num)
	godmachine(msg,msg_time,buddy_name,buddy_num,qun_name,qun_num)
	zhan(msg,msg_time,buddy_name,buddy_num,qun_name,qun_num)
	fate(msg,msg_time,buddy_name,buddy_num,qun_name,qun_num)
	fruit(msg,msg_time,buddy_name,buddy_num,qun_name,qun_num)
	help(msg,msg_time,buddy_name,buddy_num,qun_name,qun_num)
	dnddice_detail(msg,msg_time,buddy_name,buddy_num,qun_name,qun_num)
	tishen(msg,msg_time,buddy_name,buddy_num,qun_name,qun_num)
	--ronind10(msg,msg_time,buddy_name,buddy_num,qun_name,qun_num)
	readip(msg,msg_time,buddy_name,buddy_num,qun_name,qun_num)
	setip(msg,msg_time,buddy_name,buddy_num,qun_name,qun_num)
	talk(msg,msg_time,buddy_name,buddy_num,qun_name,qun_num)
	scp(msg,msg_time,buddy_name,buddy_num,qun_name,qun_num)
	--router(msg,msg_time,buddy_name,buddy_num,qun_name,qun_num)
	--rss(msg,msg_time,buddy_name,buddy_num,qun_name,qun_num)
end

function main_buddy(msg,msg_time,buddy_name,buddy_num)
	escape(msg,msg_time,buddy_name,buddy_num)
	dnddice(msg,msg_time,buddy_name,buddy_num)
	wiki(msg,msg_time,buddy_name,buddy_num)
	getlink(msg,msg_time,buddy_name,buddy_num)
	dictionary(msg,msg_time,buddy_name,buddy_num)
	dnddice_detail(msg,msg_time,buddy_name,buddy_num)
end

print("main.lua载入成功")
