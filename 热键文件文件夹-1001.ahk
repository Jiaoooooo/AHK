;test5.ahk

;------------------------配置--------------------------*/
#NoEnv
#SingleInstance force
#Persistent

if not A_IsAdmin
{
	Run *RunAs "%A_ScriptFullPath%"
	ExitApp
}



ifWinActive,ahk_class ConsoleWindowClass
	winClose,ahk_class ConsoleWindowClass


;做一个自定义打开文件夹或软件的GUI,就像https://www.songruihua.com/hk4win/那样

;------------------------变量--------------------------*/

global Config_Add := A_MyDocuments . "`\TEST.INI"		;脚本配置文件的存放路径和文件名

;------------------------菜单设置--------------------------*/

Menu, tray, add 
Menu, tray, add, 文件直通车, showHotKeyforFile
Return
;------------------------窗口GUI开始--------------------------*/

;------------------------GUI：绘制界面------------------------*/

showHotKeyforFile:
{
	ifWinExist,文件直通车
	{
		WinActivate
		Return
	}
	Gui, New
	Gui, +Resize
	Gui Add, Tab2, x0 y0 w500 h800, 文件程序直通车|文件夹直通车
	Gui Tab, 1
	Gui Add, Text, x10 y+10 w50 h20 +0x200, 快捷键
	Gui Add, Text, x+10  w300 h20 +0x200, 对应的文件或程序地址(不支持文件夹)
	loop, 12
	{
		Gui Add, Text, x10 y+10 w50 h20 +0x200, Win+F%A_Index% =
		Gui Add, Edit, x+15  w300 h20, 
		Gui Add, Button, gWinF%A_Index%  x+15  w40 h20, +
	}
	Gui Add, Text,x10 y+10 w480 h2 0x10
	Gui,Add,Text,x10 y+10 w480 h20,· 一键直达：用户可以为自己常用的程序或文件设置快捷键，快速打开。
	Gui,Add,Text,x10 y+0 w480 h20,· 设置简单：点击右侧的“+”按钮，选择文件，然后保存，即可一键直达。
	Gui,Add,Text,x10 y+0 w480 h20,· Win键又称Windows键，一般在空格键或Ctrl键旁边
	Gui,Add,Text,x10 y+0 w480 h20,· 第一行Win+F1意思是同时按下 Win 和 F1 这两个键。
	
	Gui Tab, 2
	Gui Add, Text, x10 y+10 w50 h20 +0x200, 快捷键
	Gui Add, Text, x+10  w300 h20 +0x200, 对应的文件夹地址(仅支持文件夹)
	loop, 9
	{
		Gui Add, Text, x10 y+10 w50 h20 +0x200, Win+%A_Index% =
		Gui Add, Edit, x+15  w300 h20, 
		Gui Add, Button, gWin%A_Index%  x+15  w40 h20, +
	}
	Gui Add, Text, x10 y+10 w50 h20 +0x200, Win+0 =
	Gui Add, Edit, x+15  w300 h20, 
	Gui Add, Button, gWin10  x+15  w40 h20, +
	Gui Add, Text, x10 y+10 w50 h20 +0x200, Win+- =
	Gui Add, Edit, x+15  w300 h20, 
	Gui Add, Button, gWin11  x+15  w40 h20, +
	Gui Add, Text, x10 y+10 w50 h20 +0x200, Win+= =
	Gui Add, Edit, x+15  w300 h20, 
	Gui Add, Button, gWin12  x+15  w40 h20, +
	
	Gui Add, Text,x10 y+10 w480 h2 0x10
	Gui,Add,Text,x10 y+10 w480 h20,· 一键直达：用户可以为自己常用的文件夹设置快捷键，快速打开。
	Gui,Add,Text,x10 y+0 w480 h20,· 设置简单：点击右侧的“+”按钮，选择文件夹，然后保存，即可一键直达。
	Gui,Add,Text,x10 y+0 w480 h20,· Win键又称Windows键，一般在空格键或Ctrl键旁边
	Gui,Add,Text,x10 y+0 w480 h20,· 第一行Win+1意思是同时按下 Win 和 1 这两个键。（不支持小键盘的数字1）



	Gui Add, Button, gDone x10 y40 w30 h30, 保存

	Gui Show, w500 h800, 文件直通车

	GUI_Init()

	return



	;------------------------GUI：配置动作------------------------*/

	GuiSize:  
	if A_EventInfo = 1  
		return
	loop,24
	{
		GuiControl, Move, Button%A_Index%, % "X" . (A_GuiWidth - 46)
		GuiControl, Move, Edit%A_Index%, % "w" . (A_GuiWidth - 130)
	}
	GuiControl,Move, 保存, %  "y" . (A_GuiHeight - 40) . "w" . (A_GuiWidth - 20)
	GuiControl,Move,SysTabControl321, % "w" . (A_GuiWidth) . "h" . (A_GuiHeight - 50)
	GuiControl,Move,Static15, % "w" . (A_GuiWidth-20)
	return

	GuiEscape:
	GuiClose:
		Gui, Destroy
		Return


	;------------------------GUI：按钮功能------------------------*/

	SelectFileOnButton(num)
	{
	  Gui,Submit ,NoHide
	  FileSelectFile, SelectedFile, ,::{20d04fe0-3aea-1069-a2d8-08002b30309d} , 打开文件
		if SelectedFile <>
			ControlSetText,Edit%num%,%SelectedFile%,A
		Return
	}

	WinF1:
	{
		SelectFileOnButton(1)
		Return
	}
	WinF2:
	{
		SelectFileOnButton(2)
		Return
	}
	WinF3:
	{
		SelectFileOnButton(3)
		Return
	}
	WinF4:
	{
		SelectFileOnButton(4)
		Return
	}

	WinF5:
	{
		SelectFileOnButton(5)
		Return
	}

	WinF6:
	{
		SelectFileOnButton(6)
		Return
	}

	WinF7:
	{
		SelectFileOnButton(7)
		Return
	}

	WinF8:
	{
		SelectFileOnButton(8)
		Return
	}

	WinF9:
	{
		SelectFileOnButton(9)
		Return
	}

	WinF10:
	{
		SelectFileOnButton(10)
		Return
	}

	WinF11:
	{
		SelectFileOnButton(11)
		Return
	}
	WinF12:
	{
		SelectFileOnButton(12)
		Return
	}
	
	SelectFolderOnButton(num)
	{
	  Gui,Submit ,NoHide
	  FileSelectFolder, SelectedFile, , , 打开文件
		if SelectedFile <>
			ControlSetText,Edit%num%,%SelectedFile%,A
		Return
	}



	Win1:
	{
	SelectFolderOnButton(13)
	Return
	}
	Win2:
	{
	SelectFolderOnButton(14)
	Return
	}
	Win3:
	{
	SelectFolderOnButton(15)
	Return
	}
	Win4:
	{
	SelectFolderOnButton(16)
	Return
	}
	Win5:
	{
	SelectFolderOnButton(17)
	Return
	}
	Win6:
	{
	SelectFolderOnButton(18)
	Return
	}
	Win7:
	{
	SelectFolderOnButton(19)
	Return
	}
	Win8:
	{
	SelectFolderOnButton(20)
	Return
	}
	Win9:
	{
	SelectFolderOnButton(21)
	Return
	}
	Win10:
	{
	SelectFolderOnButton(22)
	Return
	}
	Win11:
	{
	SelectFolderOnButton(23)
	Return
	}
	Win12:
	{
	SelectFolderOnButton(24)
	Return
	}









	Done:
	{

		Gui,Submit,NoHide
		loop,24
		{
			ControlGetText,FileTextForWinF%A_Index%,Edit%A_Index%,A
			IniWrite, % FileTextForWinF%A_Index%, %Config_Add%, HotKeyForFileConfig, HotkeyForFile%A_Index%
		}
		Return
		}

	}



	GUI_Init()
	{
		loop,24
		{
			IniRead,TextStr,%Config_Add%,HotKeyForFileConfig,HotkeyForFile%A_Index%,%A_Space%
			if TextStr <> 
				ControlSetText,Edit%A_Index%,%TextStr%,A
		}
		Return
}



;------------------------窗口GUI结束--------------------------*/

;------------------------快捷键设置------------------------*/

	#F1::ActionForHotKeyWinF(1)
	#F2::ActionForHotKeyWinF(2)
	#F3::ActionForHotKeyWinF(3)
	#F4::ActionForHotKeyWinF(4)
	#F5::ActionForHotKeyWinF(5)
	#F6::ActionForHotKeyWinF(6)
	#F7::ActionForHotKeyWinF(7)
	#F8::ActionForHotKeyWinF(8)
	#F9::ActionForHotKeyWinF(9)
	#F10::ActionForHotKeyWinF(10)
	#F11::ActionForHotKeyWinF(11)
	#F12::ActionForHotKeyWinF(12)

	#1::ActionForHotKeyWinF(13)
	#2::ActionForHotKeyWinF(14)
	#3::ActionForHotKeyWinF(15)
	#4::ActionForHotKeyWinF(16)
	#5::ActionForHotKeyWinF(17)
	#6::ActionForHotKeyWinF(18)
	#7::ActionForHotKeyWinF(19)
	#8::ActionForHotKeyWinF(20)
	#9::ActionForHotKeyWinF(21)
	#0::ActionForHotKeyWinF(22)
	#-::ActionForHotKeyWinF(23)
	#=::ActionForHotKeyWinF(24)

	ActionForHotKeyWinF(num)
	{
		IniRead, HotkeyForFileWinF%num%, %Config_Add%, HotKeyForFileConfig, HotkeyForFile%num%,0
		Run,% HotkeyForFileWinF%num%,,UseErrorLevel
		Return
	}






