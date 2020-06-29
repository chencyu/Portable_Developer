/* 直接開啟，或從Command Line參數啟動                */
/*                                                   */
/* 直接開啟，按按鍵來顯示其ASCII碼                   */
/* 從Command Line配合參數，則是顯示參數字元的ASCII碼 */
#include <stdio.h>
#include <stdlib.h>
#include <conio.h>

#define true 1

int main(int argc, char* argv[])
{
// For Win32/64
#ifdef _WIN32
    system("mode con cp select=65001 >nul");
#endif
	char num;
    if(argc == 1)
    {
        while(true)
        {
        	puts("輸入字元以顯示其ASCII碼");
        	num = getch();
        	printf("the ASCII code of char %c is \"%d\"\n", num, num);
	    }
    } 
    else if(argc == 2)
    {
        num = argv[1][0];
        printf("the ASCII code of char %c is \"%d\"\n", num, num);
        system("pause");
    }

	return 0;
}