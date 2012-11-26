//convert utf8 string into gbk
//just a windows workaround
//--btbxbob

#include <iconv.h>
#include "string.h"
#include "malloc.h"

//convert from utf8 2 gbk, return string
char * utf82gbk(char * in_string)
{
	//printf("utf82gbk: debug: in_string1: %s\n", in_string);
	char * out_string;
	char * out_string_startpoint;
	char * in_string_startpoint;
	//out_string_startpoint=out_string;
	in_string_startpoint=in_string;
	//1. init iconv
	iconv_t iconv_stat;
	iconv_stat=iconv_open ("GBK","UTF-8");
	if ((int)iconv_stat==-1){
		printf("%s\n", "iconv init failed");
		return out_string;
	}
	//2. process in_string
	unsigned int in_len;
	unsigned int out_len;
	in_len=strlen(in_string);
	if(!in_len)
	{
		printf("%s\n","utf82gbk:input string is empty");
		return out_string;
	}
	//2.1 assign out_string space
	out_len=in_len;
	out_string=calloc(out_len,1);
	out_string_startpoint=out_string;
	//2.2 begin convert
	size_t iconv_result;
	iconv_result=iconv(iconv_stat, &in_string, &in_len, &out_string, &out_len);
	if (iconv_result == (size_t) -1)
	{
		printf("%s\n", "utf82gbk: convert failed");
		return out_string;
	}
	//3. close iconv
	int v;
	v=iconv_close(iconv_stat);
	if (v!=0)
	{
		printf("%s\n", "utf82gbk: iconv close failed.");
		return out_string;
	}
	return out_string_startpoint;
	//4. return out_string
}

char * gbk2utf8(char * in_string)
{
	//printf("utf82gbk: debug: in_string1: %s\n", in_string);
	char * out_string;
	char * out_string_startpoint;
	char * in_string_startpoint;
	//out_string_startpoint=out_string;
	in_string_startpoint=in_string;
	//1. init iconv
	iconv_t iconv_stat;
	iconv_stat=iconv_open ("UTF-8","GBK");
	if ((int)iconv_stat==-1){
		printf("%s\n", "iconv init failed");
		return out_string;
	}
	//2. process in_string
	unsigned int in_len;
	unsigned int out_len;
	in_len=strlen(in_string);
	if(!in_len)
	{
		printf("%s\n","gbk2utf8:input string is empty");
		return out_string;
	}
	//2.1 assign out_string space
	out_len=in_len*2;
	out_string=calloc(out_len,1);
	out_string_startpoint=out_string;
	//2.2 begin convert
	size_t iconv_result;
	iconv_result=iconv(iconv_stat, &in_string, &in_len, &out_string, &out_len);
	if (iconv_result == (size_t) -1)
	{
		printf("%s\n", "gbk2utf8: convert failed");
		return out_string;
	}
	//3. close iconv
	int v;
	v=iconv_close(iconv_stat);
	if (v!=0)
	{
		printf("%s\n", "gbk2utf8: iconv close failed.");
		return out_string;
	}
	return out_string_startpoint;
	//4. return out_string
}