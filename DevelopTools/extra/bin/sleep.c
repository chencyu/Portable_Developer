/* 用QueryPerformanceFrequency / QueryPerformanceCounter測試    */
/* 比Windows Server 2003 Resource Kit Tools提供的sleep.exe較佳  */
/* 測100秒：                                                    */
/* WS sleep 100.200991s                                         */
/* My sleep 100.155448s                                         */
/* 不排除也有可能是因為較新的編譯器導致                         */
#include <stdlib.h>
#include <windows.h>

int main(int argc, char* argv[])
{
    unsigned int sec = 1000 * atoi(argv[1]);
    Sleep(sec);
    return 0;
}