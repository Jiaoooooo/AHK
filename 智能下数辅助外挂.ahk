
#NoEnv
#SingleInstance force


ifWinActive,ahk_class ConsoleWindowClass
	winClose,ahk_class ConsoleWindowClass

Global appAdd := ProgramFiles . "\ASP Creation\SmartKnitter\SmartKnitter.exe"
Global MiniSeverAdd := ProgramFiles . "\ASP Creation\SmartKnitter\MiniServer.exe"
Global flag := 1

RunSmartKnitter()


RunSmartKnitter()
{
;如果存在智能下数窗口则激活之
;如果窗口不存在，则尝试打开它
;	如果下数迷你服务器未打开，尝试先打开它
;	如果窗口打开失败，则不弹出任何提示
;	如果窗口成功打开，则自动同意协议并输入密码123登入(仅适用于1668破解版)
	ifWinExist,ahk_exe SmartKnitter.exe
		WinActivate
	else
	{
		IfWinNotExist , 吓数迷你服务器
		{
			Run %MiniSeverAdd%,,UseErrorLevel
			Sleep,1000
		}
		;appAdd := ProgramFiles . "\SmartKnitter.exe"
		;Run %appAdd%,,UseErrorLevel 
		WinWaitActive,ahk_class TLicenseAgreementForm,,10
		{
			Controlclick,TButton2,ahk_class TLicenseAgreementForm,,,,NA
		}
		WinWaitClose,ahk_class TLicenseAgreementForm,,3
		if !ErrorLevel
		{
			Sleep,500
			ifWinActive,ahk_exe SmartKnitter.exe
			{
				ControlSend, TEdit1, 123, ahk_exe SmartKnitter.exe
				sleep,100
				Controlclick,TButton2,ahk_exe SmartKnitter.exe,,,,NA
			}
		}
	}	
Return
}






#IfWinActive,ahk_class TSKMainForm


;另存为
^!s::Send,{AltDown}fa{AltUp}


/*
F1~F12:各快捷键定义
根据TToolBar1的高度TBWidth和宽度TBHeight，计算各按钮对应的位置
F1		列印			
F2		列印预览
F3		资料库
F4		撤销			Win+WheelUp也可以  (系统自带)

F5		撤销下拉
F6		重做			Win+WheelDown也可以  (系统自带)
F7		重做下拉
F8		词汇

F9		间色
F10	尺寸
F11	文字
F12	调整尺寸
*/


F1::
{
;F1		列印	
ControlGetPos, , , TB_W, TB_H, TToolBar1, ahk_exe SmartKnitter.exe
Btn_Margin := 1
btn_w := TB_H - 3 * Btn_Margin

Btn_Y := 0.5 * TB_H
Btn_X := 5 + 3 * ( 3 * btn_w + Btn_Margin) + Btn_Y

ControlClick,TToolBar1,ahk_exe SmartKnitter.exe,,,, NA x%Btn_X% y%Btn_Y%

Return
}

F2::
{
;F2		列印预览	
ControlGetPos, , , TB_W, TB_H, TToolBar1, ahk_exe SmartKnitter.exe
Btn_Margin := 1
btn_w := TB_H - 3 * Btn_Margin

Btn_Y := 0.5 * TB_H
Btn_X := 5 + 4 * ( 3 * btn_w + Btn_Margin) - Btn_Y

ControlClick,TToolBar1,ahk_exe SmartKnitter.exe,,,, NA x%Btn_X% y%Btn_Y%

Return
}


F4::
{
;F4		撤销
ControlGetPos, , , TB_W, TB_H, TToolBar1, ahk_exe SmartKnitter.exe
Btn_Margin := 1
btn_w := TB_H - 3 * Btn_Margin

Btn_Y := 0.5 * TB_H
Btn_X := 5 + 7 * ( 3 * btn_w + Btn_Margin) + Btn_Y

ControlClick,TToolBar1,ahk_exe SmartKnitter.exe,,,, NA x%Btn_X% y%Btn_Y%

Return
}


F5::
{
;F4		撤销选项
ControlGetPos, , , TB_W, TB_H, TToolBar1, ahk_exe SmartKnitter.exe
Btn_Margin := 1
btn_w := TB_H - 3 * Btn_Margin

Btn_Y := 0.5 * TB_H
Btn_X := 5 + 7 * ( 3 * btn_w + Btn_Margin) + Btn_Y + btn_w


ControlClick,TToolBar1,ahk_exe SmartKnitter.exe,,,, NA x%Btn_X% y%Btn_Y%

Return
}

F6::
{
;F6		重做
ControlGetPos, , , TB_W, TB_H, TToolBar1, ahk_exe SmartKnitter.exe
Btn_Margin := 1
btn_w := TB_H - 3 * Btn_Margin

Btn_Y := 0.5 * TB_H
Btn_X := 5 + 7 * ( 3 * btn_w + Btn_Margin) + 2 * (btn_w  + Btn_Margin )

ControlClick,TToolBar1,ahk_exe SmartKnitter.exe,,,, NA x%Btn_X% y%Btn_Y%

Return
}


F7::
{
;F7		重做选项
ControlGetPos, , , TB_W, TB_H, TToolBar1, ahk_exe SmartKnitter.exe
Btn_Margin := 1
btn_w := TB_H - 3 * Btn_Margin

Btn_Y := 0.5 * TB_H
Btn_X := 5 + 7 * ( 3 * btn_w + Btn_Margin) + 3 * (btn_w  + Btn_Margin )

ControlClick,TToolBar1,ahk_exe SmartKnitter.exe,,,, NA x%Btn_X% y%Btn_Y%

Return
}


F8::
{
;F8		词汇
ControlGetPos, , , TB_W, TB_H, TToolBar1, ahk_exe SmartKnitter.exe
Btn_Margin := 1
btn_w := TB_H - 3 * Btn_Margin

Btn_Y := 0.5 * TB_H
Btn_X := 5 + 8 * ( 3 * btn_w + Btn_Margin) + 2 * btn_w + Btn_Margin 

ControlClick,TToolBar1,ahk_exe SmartKnitter.exe,,,, NA x%Btn_X% y%Btn_Y%

Return
}


F9::
{
;F9		间色
ControlGetPos, , , TB_W, TB_H, TToolBar1, ahk_exe SmartKnitter.exe
Btn_Margin := 1
btn_w := TB_H - 3 * Btn_Margin

Btn_Y := 0.5 * TB_H
Btn_X := 5 + 9 * ( 3 * btn_w + Btn_Margin) + 2 * btn_w + Btn_Margin 

ControlClick,TToolBar1,ahk_exe SmartKnitter.exe,,,, NA x%Btn_X% y%Btn_Y%

Return
}

F10::
{
;F10		尺寸
ControlGetPos, , , TB_W, TB_H, TToolBar1, ahk_exe SmartKnitter.exe
Btn_Margin := 1
btn_w := TB_H - 3 * Btn_Margin

Btn_Y := 0.5 * TB_H
Btn_X := 5 + 10 * ( 3 * btn_w + Btn_Margin) + 2 * btn_w + Btn_Margin 

ControlClick,TToolBar1,ahk_exe SmartKnitter.exe,,,, NA x%Btn_X% y%Btn_Y%

Return
}

F11::
{
;F11		文字
ControlGetPos, , , TB_W, TB_H, TToolBar1, ahk_exe SmartKnitter.exe
Btn_Margin := 1
btn_w := TB_H - 3 * Btn_Margin

Btn_Y := 0.5 * TB_H
Btn_X := 5 + 11 * ( 3 * btn_w + Btn_Margin) + 2 * btn_w + Btn_Margin 

ControlClick,TToolBar1,ahk_exe SmartKnitter.exe,,,, NA x%Btn_X% y%Btn_Y%

Return
}

F12::
{
;F12		调整尺寸
ControlGetPos, , , TB_W, TB_H, TToolBar1, ahk_exe SmartKnitter.exe
Btn_Margin := 1
btn_w := TB_H - 3 * Btn_Margin

Btn_Y := 0.5 * TB_H
Btn_X := 5 + 12 * ( 3 * btn_w + Btn_Margin) + 2 * btn_w + Btn_Margin 

ControlClick,TToolBar1,ahk_exe SmartKnitter.exe,,,, NA x%Btn_X% y%Btn_Y%

Return
}

^WheelDown::Control,TabRight ,1,TPageControl1,ahk_exe SmartKnitter.exe
^WheelUp::Control,TabLeft ,1,TPageControl1,ahk_exe SmartKnitter.exe

!WheelDown::
{
MouseGetPos,,,,ctlName,1
Control,TabRight ,1,%ctlName%,ahk_exe SmartKnitter.exe

/*
ControlGetPos,x,y,w,h,TPageControl2,ahk_exe SmartKnitter.exe
if (w > 0)
	Control,TabRight ,1,TPageControl2,ahk_exe SmartKnitter.exe
else
{
	ControlGetPos,,,w,h,TTabControl1,ahk_exe SmartKnitter.exe
	if (w > 0)
		Control,TabRight ,1,TTabControl1,ahk_exe SmartKnitter.exe
}
*/
Return
}


!WheelUp::
{
MouseGetPos,,,,ctlName,1
Control,TabLeft ,1,%ctlName%,ahk_exe SmartKnitter.exe

Return
}



MButton::
ifWinNotActive,ahk_class TKnitCmdDialogForm
{
; 修改下数窗口未激活，中键功能为“修改下数”
	Click Right
	WinWait,ahk_class #32768,,1
	if ErrorLevel
		send,{Esc}
	else
	{
		Send, {Down}
		;Sleep,30
		send,{Enter}
		WinWait,ahk_class TKnitCmdDialogForm,,0.5
		if ErrorLevel
			Send,{Esc 2}
	}
}else{
; 修改下数窗口已激活，中键功能为“修改数字为输出字符‘.’。”
	MouseGetPos,,,,ctlName
	ControlGetText,CtlValue,%ctlName%
	if CtlValue is integer
	{
		CtlValue := "."
		ControlSetText,%ctlName%,%CtlValue%
	}
}
Return


^!WheelUp::
PgUp::
{
ControlGetPos, , , PgControl_W, PgControl_H, TPageControl2, ahk_exe SmartKnitter.exe
ControlGetPos, , , StrGrid_W, StrGrid_H, TStringGrid2, ahk_exe SmartKnitter.exe


General_Width := PgControl_H - StrGrid_H - 4

PreviousSize_Btn_X := 4 + General_Width + 1 + 4 * General_Width + 4 + General_Width * 0.3
PreviousSize_Btn_Y := 0.5 * General_Width 

ControlClick,TStringGrid2,ahk_exe SmartKnitter.exe,,,, NA x%PreviousSize_Btn_X% y%PreviousSize_Btn_Y%
ControlClick,TStringGrid1,ahk_exe SmartKnitter.exe,,,, NA x%PreviousSize_Btn_X% y%PreviousSize_Btn_Y%

Return
}


^!WheelDown::
PgDn::
{
ControlGetPos, , , PgControl_W, PgControl_H, TPageControl2, ahk_exe SmartKnitter.exe
ControlGetPos, , , StrGrid_W, StrGrid_H, TStringGrid2, ahk_exe SmartKnitter.exe


General_Width := PgControl_H - StrGrid_H - 4

NextSize_Btn_X := 4 + General_Width + 1 + 4 * General_Width + 4 + General_Width * 0.3 + 1.5 * General_Width 
NextSize_Btn_Y := 0.5 * General_Width 

ControlClick,TStringGrid2,ahk_exe SmartKnitter.exe,,,, NA x%NextSize_Btn_X% y%NextSize_Btn_Y%
ControlClick,TStringGrid1,ahk_exe SmartKnitter.exe,,,, NA x%NextSize_Btn_X% y%NextSize_Btn_Y%

Return
}





 /*
 ;把所有宽度小于20 高度小于30的控件尺寸位置名称找出来
 ;找不到切换尺码的小三角的控件名称

^F12::
{
WinGet, ActiveControlList, ControlList, ahk_exe SmartKnitter.exe

Loop, Parse, ActiveControlList, `n
{
	ControlGetPos,x,y,w,h,%A_LoopField%,ahk_exe SmartKnitter.exe
	if ((w > 0) and (w < 20) and (h < 30))
	{	
		mousemove,x,y
		MsgBox, 4,, Control #%a_index% is "%A_LoopField%"`nx = %x%, y = %y%, w = %w%, h= %h%. Continue?
		IfMsgBox, No
		break
	}
}


Return
}

*/




#IfWinActive,ahk_class TKnitCmdDialogForm

;修改下数窗口

WheelDown::
;如果指向的控件内容是数字，则数值-1
MouseGetPos,,,,ctlName
ControlGetText,CtlValue,%ctlName%
if CtlValue is integer
	{
	if (CtlValue = 0)
		return
	CtlValue -= 1
	ControlSetText,%ctlName%,%CtlValue%
	}
Return

WheelUp::
;如果指向的控件内容是数字，则数值+1，如果是小数点，则数值变为0
MouseGetPos,,,,ctlName
ControlGetText,CtlValue,%ctlName%
if CtlValue is integer
	{
	CtlValue += 1
	}
else
	if CtlValue = .
		CtlValue := 0
	
	ControlSetText,%ctlName%,%CtlValue%
Return

MButton::
;如果指向的控件内容是数字，则数值变为小数点
MouseGetPos,,,,ctlName
ControlGetText,CtlValue,%ctlName%
if CtlValue is integer
	{
	CtlValue := "."
	ControlSetText,%ctlName%,%CtlValue%
	}
Return

^!NumpadEnter::
^!Enter::
ControlFocus,使用新转数支数,ahk_class TKnitCmdDialogForm
ControlClick,使用新转数支数,ahk_class TKnitCmdDialogForm,,,,Na
Return

^NumpadEnter::
^Enter::
ControlFocus,使用新下数,ahk_class TKnitCmdDialogForm
ControlClick,使用新下数,ahk_class TKnitCmdDialogForm,,,,Na
Return

Pgup::
ControlFocus,上一组,ahk_class TKnitCmdDialogForm
ControlClick,上一组,ahk_class TKnitCmdDialogForm,,,,Na
Return
PgDn::
ControlFocus,下一组,ahk_class TKnitCmdDialogForm
ControlClick,下一组,ahk_class TKnitCmdDialogForm,,,,Na
Return


^MButton::
ControlFocus,计算下数,ahk_class TKnitCmdDialogForm
ControlClick,计算下数,ahk_class TKnitCmdDialogForm,,,,Na
Return


#IfWinActive,智能方格纸

;放大；缩小
!WheelDown::Send,{F9}
!WheelUp::Send,{F10}






l::
{
;直线
;控件名称一直变来变去，无法ControlClick
/*
解决方法：
1.获取当前主窗口的 MainFormSize
2.遍历获取各个 TButton 的 size（遍历TButton1~20即可）
3.根据各 TButton 的 size中 W/H 比例，推断出对应的按钮 ControlName和按钮功能的对应关系
4.记录对应的 ControlName ，ControlClick 之
5.如果 MainFormSize 发生宽度或高度变化，则重新执行2、3步（不用每次都执行遍历、核对）
*/

ControlGetPos, , , TB_W, TB_H, TToolBar8,智能方格纸


Btn_Y := TB_H * 0.17
Btn_X := TB_W * 0.25

;ControlClick,TToolBar8,智能方格纸,,,, NA x%Btn_X% y%Btn_Y%

Return
}

r::
{
;矩形
;控件名称一直变来变去，无法ControlClick
ControlGetPos, , , TB_W, TB_H, TToolBar8,智能方格纸


Btn_Y := TB_H * 0.5
Btn_X := TB_W * 0.25

;ControlClick,TToolBar8,智能方格纸,,,, NA x%Btn_X% y%Btn_Y%

Return
}






#IfWinActive




^F1::
{

str := "================================`n 
.====* 智能吓数主窗口界面* ==== `n
.----------------------------- `n
.鼠标中键	：	修改吓数 `n
.----------------------------- `n
.F1		：	列印吓数 `n
.F2		：	列印预览 `n
.Win+滚轮上	：	撤销一步  `n
.Win+滚轮下	：	重做一步 `n
.F8		：	词汇 `n
.F9		：	间色 `n
.F10		：	尺寸 `n
.F11		：	文字 `n
.F12		：	调整尺寸`n 
. ----------------------------- `n
.Ctrl+Alt+滚轮上/下：切换尺码 `n
.Ctrl+滚轮上/下：切换工艺标签 `n
.Alt+滚轮上/下 ：切换尺寸标签 `n
.（注：需要光标放在尺寸标签上） `n
.----------------------------- `n
.===== * 修改吓数窗口界面 * ===== `n
.----------------------------- `n
.滚轮上/下	：指向的数字+1或-1 `n
.鼠标中键	：指向的数字变为. `n
.Ctrl+中键	：计算下数 `n
.Ctrl+回车	：使用新下数 `n
.Ctrl+Alt+回车：使用新转数支数 `n
.Page Up	：上一组 `n
.Page Down	：下一组`n 
.===============================`n
.再次按下Ctrl+F1键关闭本提示`n`n
.更多需求，联系作者`n
.QQ:88543702`n
.==============================="


if flag
{
	ToolTip,%str%
	flag := 0
}else{
	ToolTip,
	flag := 1
}
Return


}












/*
============================
===* 智能吓数主窗口界面* ===
----------------------------
鼠标中键	：	修改吓数
----------------------------
F1			：	列印吓数
F2			：	列印预览
Win+滚轮上：	撤销一步
Win+滚轮下：	重做一步
F8			：	词汇
F9			：	间色
F10		：	尺寸
F11		：	文字
F12		：	调整尺寸
----------------------------
Ctrl+滚轮上/下：切换工艺标签
Alt+滚轮上/下 ：切换尺寸标签
（注：需要光标放在尺寸标签上）
----------------------------
=== * 修改吓数窗口界面 * ===
----------------------------
滚轮上/下	：指向的数字+1或-1
鼠标中键	：指向的数字变为.
Ctrl+中键	：计算下数
Ctrl+回车	：使用新下数
Ctrl+Alt+回车：使用新转数支数
Page Up	：上一组
Page Down	：下一组
============================
*/


















