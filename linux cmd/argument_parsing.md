
# 参数解析
+ 最近有个想法想要写一个命令行小工具，顺便练习c语言下的参数解析。
## getopt函数
```c
#include <unistd.h>
int getopt(int argc, char* const argv[]. const char* optstring)   //optstring为指定各参数的缺省模式
extern char* optarg;    // 用于存放当前选项参数字符串
extern int optind;      // 用于存放argv的当前的索引值
```
+ 调用该函数将返回解析到的当前选项，将该选项的参数赋值给optarg。如果该选项没有参数，则optarg为NULL

```c
#include <stdio.h>
#include <unistd.h>
#include <string.h>

int main(int argc,char *argv[])
{
    int opt=0;
    int a=0;
    int b=0;
    char s[50];
    while((opt=getopt(argc,argv,"ab:"))!=-1)
    {
        switch(opt)
        {
            case 'a':a=1;break;
            case 'b':b=1;strcpy(s,optarg);break; 
        }
    }
    if(a)
        printf("option a\n");
    if(b)
        printf("option b:%s\n",s);
    return 0;
}
```

## getopt_long函数
```c
#include <getopt.h>
int getopt_long(int argc, char* const argv[], const char* optstring, const struct option* longopts, int* longindex);

struct option {
    const char* name;    // 参数名
    int has_arg;         // 参数缺省选项。no_argument表示无参数,required_argument表示一定跟一个参数，optional_argument表示参数可选
    int* flag;           // 如果为NULL，返回val；如果不为NULL，返回0并将val放在flag内存处
    int val;             // 用法如上
};
```
+ 一个例子

```c
#include <stdio.h>
#include <string.h>
#include <getopt.h>

int learn=0;
static const struct option long_option[]={
   {"name",required_argument,NULL,'n'},
   {"learn",no_argument,&learn,1},
   {NULL,0,NULL,0}
};

int main(int argc,char *argv[])
{
    int opt=0;
    while((opt=getopt_long(argc,argv,"n:l",long_option,NULL))!=-1)
    {
        switch(opt)
        {
            case 0:break;
            case 'n':printf("name:%s ",optarg);                             
        }
    }
    if(learn)
        printf("learning\n");
}
```
## 综合用例
+ unistd库中给出的关于函数解析的综合用例
```c

#include<stdio.h>
#include <getopt.h>
#include<iostream>
#include<string>
#include<stdlib.h>
using namespace std;
 
void showUsage() {
  //cout << "Usage: " << PACKAGE_NAME << " [options] URL ..." << endl;
  cout << "Options:" << endl;
  cout << " -d, --dir=DIR              The directory to store downloaded file." << endl;
  cout << " -o, --out=FILE             The file name for downloaded file." << endl;
  cout << " -l, --log=LOG              The file path to store log. If '-' is specified," << endl;
  cout << "                            log is written to stdout." << endl;
  cout << " -D, --daemon               Run as daemon." << endl;
  cout << " -s, --split=N              Download a file using s connections. s must be" << endl;
  cout << "                            between 1 and 5. If this option is specified the" << endl;
  cout << "                            first URL is used, and the other URLs are ignored." << endl;
  cout << " --http-proxy=HOST:PORT     Use HTTP proxy server. This affects to all" << endl;
  cout << "                            URLs." << endl;
  cout << " --http-user=USER           Set HTTP user. This affects to all URLs." << endl;
  cout << " --http-passwd=PASSWD       Set HTTP password. This affects to all URLs." << endl;
  cout << " --http-proxy-user=USER     Set HTTP proxy user. This affects to all URLs" << endl;
  cout << " --http-proxy-passwd=PASSWD Set HTTP proxy password. This affects to all URLs." << endl;
  cout << " --http-auth-scheme=SCHEME  Set HTTP authentication scheme. Currently, BASIC" << endl;
  cout << "                            is the only supported scheme." << endl;
  cout << " -v, --version              Print the version number and exit." << endl;
  cout << " -h, --help                 Print this message and exit." << endl;
  cout << "URL:" << endl;
  cout << " You can specify multiple URLs. All URLs must point to the same file" << endl;
  cout << " or a download fails." << endl;
  cout << "Examples:" << endl;
  cout << " Download a file by 1 connection:" << endl;
  cout << "  aria2c http://AAA.BBB.CCC/file.zip" << endl;
  cout << " Download a file by 2 connections:" << endl;
  cout << "  aria2c -s 2 http://AAA.BBB.CCC/file.zip" << endl;
  cout << " Download a file by 2 connections, each connects to a different server." << endl;
  cout << "  aria2c http://AAA.BBB.CCC/file.zip http://DDD.EEE.FFF/GGG/file.zip" << endl;
  cout << "Reports bugs to <tujikawa at rednoah dot com>" << endl;
}
 
int main(int argc, char* argv[]) {
  bool stdoutLog = false;
  string logfile;
  string dir;
  string ufilename;
  int split = 0;
  bool daemonMode = false;
  int c;
 
 
  while(1) {
    int optIndex = 0;
    int lopt;
    static struct option longOpts[] = {
      { "daemon", no_argument, NULL, 'D' },
      { "dir", required_argument, NULL, 'd' },
      { "out", required_argument, NULL, 'o' },
      { "log", required_argument, NULL, 'l' },
      { "split", required_argument, NULL, 's' },
      { "http-proxy", required_argument, &lopt, 1 },
      { "http-user", required_argument, &lopt, 2 },
      { "http-passwd", required_argument, &lopt, 3 },
      { "http-proxy-user", required_argument, &lopt, 4 },
      { "http-proxy-passwd", required_argument, &lopt, 5 },
      { "http-auth-scheme", required_argument, &lopt, 6 },
      { "version", no_argument, NULL, 'v' },
      { "help", no_argument, NULL, 'h' },
      { 0, 0, 0, 0 }
    };
    c = getopt_long(argc, argv, "Dd:o:l:s:vh", longOpts, &optIndex);
    printf("返回值： %c\n",c);
    if(c == -1) {
      break;
    }
    switch(c) {
    case 0:{
      switch(lopt) {
      case 1: {
	printf("1: %s\n",optarg);
	break;
      }
      case 2:
	printf("2: %s\n",optarg);
	break;
      case 3:
	printf("3: %s\n",optarg);
	break;
      case 4:
	printf("4: %s\n",optarg);
	break;
      case 5: 
	printf("5: %s\n",optarg);
	break;
      case 6:
	printf("6: %s\n",optarg);
	break;
      }
      break;
    }
    case 'D':
      printf("D: %s\n",optarg);
      break;
    case 'd':
      printf("d: %s\n",optarg);
      break;
    case 'o':
      printf("o: %s\n",optarg);
      break;
    case 'l':
     printf("l: %s\n",optarg);
      break;
    case 's':
      printf("s: %s\n",optarg);
      break;
    case 'v':
      printf("s: %s\n",optarg);
      //showVersion();
      exit(0);
    case 'h':
      showUsage();
      exit(0);
    default:
      showUsage();
      exit(1);
    }
  }
  return 0;
```