#NoEnv
#SingleInstance force


;=============================Global Varlides==============================

SetControlDelay 50
SetKeyDelay 50
global ColorPage := 0				;Model 切换视图区域时，ColorPage用来切换视图界面的层面
global VirtualScreenWidth			;显示器尺寸-宽度像素
global MonitorCount					;显示器数量
global VirtualScreenHeight		;显示器尺寸-高度像素
SysGet MonitorCount,80				;获取显示器数量
SysGet, VirtualScreenWidth, 78	;获取显示器宽度（像素）
SysGet, VirtualScreenHeight, 79	;获取显示器高度（像素）

global HQ_INI_ADD := A_MyDocuments . "`\HQ_SETTING.INI"		;恒强脚本配置文件的存放路径和文件名


;=============================Administrator==============================

if not A_IsAdmin
{
	Run *RunAs "%A_ScriptFullPath%"
	ExitApp
}


ifWinActive,ahk_class ConsoleWindowClass
	winClose,ahk_class ConsoleWindowClass
	
	

#Include %A_ScriptDir%
#Include LCD.ahk


;============================= Script Start ============================；

;============================= 恒 强 工 艺 单 ============================；
;																							;
;	*	WheelUp		：指定控件内数字增加1											*
;	*	WheelDown		：指定控件内数字减少1											*
;------------------------------ 可 能 的 Bug ----------------------------	*
;可以把某些数值修改为负数，				导致意外错误								*
;可以把某些灰色不可编辑控件的数值修改，导致意外错误							*
;============================= 恒 强 工 艺 单 ============================；

#IfWinActive 工艺单

	/::controlclick,计算,工艺单,,,,NA

	WheelUp::
		MouseGetPos,,,,ctlName
		ControlGetText,CtlValue,%ctlName%
		if CtlValue is integer
			{
				CtlValue += 1
				ControlSetText,%ctlName%,%CtlValue%
			}
	Return

	WheelDown::
		MouseGetPos,,,,ctlName
		ControlGetText,CtlValue,%ctlName%
		if CtlValue is integer
		{
			CtlValue -= 1
			ControlSetText,%ctlName%,%CtlValue%
		}
		Return


	^o::
	{
		ControlClick,加载,工艺单,,,,NA
		Send,{Down}{Enter}
		Return
	}

	^s::ControlClick,保存,工艺单,,,,NA

	^n::ControlClick,新建,工艺单,,,,NA




#IfWinActive Model9


;=========================< M	o	d	e	l - 9 >==========================；
;																							*
;				***	 一些快捷键用于视图缩放或切换	***						*
;	-------------------------------------------------------------------	*
;	*	Ctrl+WheelUp		：【Page Up】 按键											*
;	*	Ctrl+WheelDown	：【Page Down】 按键										*
;	*	Shift+Up			：移动到花样顶部											*
;	*	Shift+WheelDown	：移动到花样底部											*
;	*	Shift+Left		：移动到花样最左侧											*
;	*	Shift+Right		：移动到花样最右侧											*
;																							*
;	*	Alt+WheelUp		：放大绘图区													*
;	*	Alt+WheelDown	：缩小绘图区													*
;	*	F11				：放大绘图区													*
;	*	F12				：缩小绘图区													*
;	*	Ctrl+Alt+O		：打开当前文件所在的文件夹								*
;	*	Ctrl+P				：打开参数窗口，并默认<不显示>所有参数					*
;	*	Shift+鼠标中键	：缩放到最大/最小											*
;																							*
;=========================< M	o	d	e	l - 9 >==========================；

;----------------------------> S T A R T <--------------------------------*

	^WheelUp::		Send, {PgUp}
	^WheelDown::		Send, {Pgdn}

	+Up::		send, {PgUp 10}
	+Down::	send, {PgDn 10}
	+Left::	send, ^{Left 10}
	+Right::	send, ^{Right 10}

	!WheelDown::	send, {NumpadSub}
	F12::			send, {NumpadSub}

	!WheelUp::	send, {NumpadAdd}
	F11::		send, {NumpadAdd}

	+MButton::Send,{F10}

	;-----------------------------> E N D <---------------------------------*


	;=========================< M	o	d	e	l - 9 >==========================；
	;
	;	*	`(间隔号)	：	选择黑色色区颜色
	;	*	Alt+`		:	选择空的针法符号
	;
	;	* 连续按` 键，会在“点色区” 和 “x色区”之间切换
	;	 
	;=========================< M	o	d	e	l - 9 >==========================；

	Global xFlag := False

	`::
	{
		;*************************************************************************
		;
		;在没有切换过颜色视图时，TFrameSelectPenBar3不存在，
		;此时，色区颜色选择区的控件名称为TFrameSelectPenBar2
		;所以先检测TFrameSelectPenBar3是否存在，不存在则Click TFrameSelectPenBar2
		;
		;=========================================================================
		ControlGetPos,,,w,h,TFrameSelectPenBar3,Model9
		if h
			{
				if (xFlag)
				{
					y := h * 0.5
					x := w - h - y
					ControlClick,TFrameSelectPenBar3,Model9,,,, NA x%x% y%y%
					xFlag := False
				}else{
					y := h * 0.5
					x := w - y
					ControlClick,TFrameSelectPenBar3,Model9,,,, NA x%x% y%y%
					xFlag := True
				}
			}else{
				ControlGetPos,,,w,h,TFrameSelectPenBar2,Model9
				if (xFlag)
				{
					y := h * 0.5
					x := w - h - y
					ControlClick,TFrameSelectPenBar2,Model9,,,, NA x%x% y%y%
					xFlag := False
				}else{
					y := h * 0.5
					x := w - y
					ControlClick,TFrameSelectPenBar2,Model9,,,, NA x%x% y%y%
					xFlag := True
				}
			}		
		Return
	}


	!`::
	{
		;*************************************************************************
		;
		;
		;
		;在没有切换过颜色视图时，针法符号选择控件的名称为TFrameSelectPenBar1
		;切换过之后，针法符号选择控件的名称为TFrameSelectPenBar2
		;所以先检测TFrameSelectPenBar3是否存在，
		;根据TFrameSelectPenBar3的状态来确定要点击的控件名称
		;
		;=========================================================================
		ControlGetPos,,,w,h,TFrameSelectPenBar3,Model9
		if h
		{
			ControlGetPos,,,w,h,TFrameSelectPenBar2,Model9
			y := h * 0.5
			x := y
			ControlClick,TFrameSelectPenBar2,Model9,,,, NA x%x% y%y%
		}else{
			ControlGetPos,,,w,h,TFrameSelectPenBar1,Model9
			y := h * 0.5
			x := y
			ControlClick,TFrameSelectPenBar1,Model9,,,, NA x%x% y%y%
		}	
		Return
	}




	^!o::
	{
		;*************************************************************************
		;
		;	*	Ctrl+Alt+O：	打开当前文件所在的文件夹
		;
		; * 获取当前活动的Model窗口的Title，然后处理Title字符串获取地址
		; * 如果地址指向的文件夹存在，则打开它
		;
		;=========================================================================
		WinGetTitle, FullTitle, A
		FullFileName := SubStr(FullTitle,10)
		SplitPath, FullFileName,, dir
		if FileExist(dir)
		{
			dir := dir . "\"
			Run, %dir%
			if ErrorLevel
				Return
		}
		Return
	}


	~^p::
	{
		;*************************************************************************
		;
		;	*	Ctrl+P：	利用Model9内置快捷键打开参数窗口，并取消“显示全部”
		;
		; * 发送Ctrl+P按键到Model，如果Model版本较低或未设置该快捷键，则失效
		; * 参数窗口激活后，检测“显示全部”的控件是否勾选，如果勾选则取消之
		;
		;=========================================================================
		WinWait,ahk_class TFormPars,,1
		{
			ControlGet,isShowAllParmsChecked,checked,,TCheckBox1,ahk_class TFormPars
			if isShowAllParmsChecked
				Control,Uncheck,,TCheckBox1,ahk_class TFormPars
		}
		Return
	}

	;^x::WinMenuSelectItem,Model9,,6&,8& ;执行脚本程序
	!i::
		WinMenuSelectItem,Model,,2&,2&
		WinWait,ahk_class TFormSelectElem,,2
		if ErrorLevel
			Return
		send,{Down}
		Send,{Enter}
		Return


	;Alt+C:Switch the PageView between Constants&Zones view and ColorView
	^Space::
	!c::
	{
		ControlGetPos,,,TabW,,TTabSet1,Model
		HalfTabW := TabW * 0.5
		ControlClick,TTabSet1,Model,,,, NA x%HalfTabW% y10 
		WinWait,ahk_class #32768,,0.5
		if ErrorLevel
			Return
		if(ColorPage == 0)
		{
			send y
			ColorPage := 1
		}else{
			send x
			ColorPage := 0
		}		
		Return
	}
		
		

	;------------------------------------------------------------------;
	;Ctrl+W: show the Library PageView
	^w::
	{
		ControlGetPos,,,TabW,,TTabSet1,Model
		HalfTabW := TabW * 0.5
		; Useing a absolute coordinate on "y100", it's not ROBUST.
		ControlClick,TTabSet1,Model,,,, NA x%HalfTabW% y100 
		Return
	}


	 
	;------------------------------------------------------------------;

	^+s::	WinMenuSelectItem,Model,,1&,4& 		;Ctrl+Shift+S:		Save As...
	^+b::	WinMenuSelectItem,Model,,1&,11&,2& 	;Ctrl+Shift+B:		Import a BMP File
	^n::	WinMenuSelectItem,Model,,1&,1&,1& 	;Ctrl+N:			New Article
	^v::	WinMenuSelectItem,Model,,4&,21&,5& 	;Ctrl+V:			paste motive
	^t::	WinMenuSelectItem,Model,,1&,8& 		;Ctrl+T:			Save as a Temp file
	^+t::	WinMenuSelectItem,Model,,1&,9& 		;Ctrl+Shift+T:		Load the Temp file

	;------------------------------------------------------------------;
	;Win+M: 	Resize the Window to fill my two Minitors 

	Global isMaxToEdge := False
	Global WinX,WinY,WinWidth,WinHeight
	#m::
	{
		CoordMode,Mouse,Screen
		if MonitorCount == 1
			Return
		else{
			if !isMaxToEdge
			{
				WinGetPos, WinX, WinY, WinWidth, WinHeight, Model
				WinMove,Model,, 0, 32, %VirtualScreenWidth%
				isMaxToEdge := True	
			}else{
				WinMove,Model,, WinX, WinY, WinWidth, WinHeight,
				isMaxToEdge := False
			}
		}
	Return
	}
	;------------------------------------------------------------------;
	XButton1::	Send, !{F9}

	^XButton1::
	{
		send,!{F9}
		WinWait,AHK_class TFormGenerate
		if ErrorLevel
			Return
		Sleep,2000
		Send,{Enter}
		
		WinMenuSelectItem,Model,,1&,6&	;保存EDS
		;在大部分版本的Model中，使用文件菜单中的“保存EDS”菜单
		;以及快捷键调用的“保存EDS”命令，都与按钮栏的“保存EDS”
		;存在区别，按钮栏一般会默认保存至当前花版所在位置
		;而其他两种会默认保存到上次保存位置
		
		WinWait,保存 EDS,,2
		if ErrorLevel
			Return
		Sleep,1000
		Send,{Enter}
		Return
	}

	;------------------------------------------------------------------;
	;在Model窗口内按下中键，检查/不检查
	;在Model窗口外按下中键，依然是中键的原本作用


	~MButton::
	{
		if MouseIsOver("ahk_exe Model9.exe")
			send {F8}
		Return
	}




	;------------------------------------------------------------------;
	;Ctrl+F6:	Restore the Background
	^F6::	WinMenuSelectItem,Model,,4&,3&

	;------------------------------------------------------------------;
	;在“线圈模拟窗口”中，切换上一个下一个系统，
	.::
	^NumpadAdd::
		CoordMode,Mouse,Window
		ControlGetPos,ComBox_X,ComBox_Y, , ,TComboBox1,Model
		if ComBox_X
		{
			SysPlusBtn_X := ComBox_X + 455
			SysPlusBtn_Y := ComBox_Y + 12
			ControlClick,X%SysPlusBtn_X% y%SysPlusBtn_Y%,Model
		}
		Return

	^!NumpadAdd::
		if ComBox_X
		{
			SysPlusBtn_X := ComBox_X + 455
			SysPlusBtn_Y := ComBox_Y + 12
			Loop,6{
				ControlClick,X%SysPlusBtn_X% y%SysPlusBtn_Y%,Model
				Sleep,100
			}
		}
		Return
	,::
	^NumpadSub::
		if ComBox_X
		{
			SysSubBtn_X := ComBox_X + 430
			SysSubBtn_Y := ComBox_Y + 12
			ControlClick,X%SysSubBtn_X% y%SysSubBtn_Y%,Model
		}
		Return

	^NumpadMult::
		if ComBox_X
		{
			SysGoBtn_X := ComBox_X + 180
			SysGoBtn_Y := ComBox_Y + 12
			ControlClick,X%SysGoBtn_X% y%SysGoBtn_Y%,Model
		}
		Return

;===============================================================================================================
; 创建针法符号界面

#IfWinActive ahk_class TFormSymbol

	;-------------------------操作界面-----------------------------------------;
	Insert::	ControlClick,TButton11,ahk_class TFormSymbol,,,,NA			;插入
	^x::		ControlClick,TButton10,ahk_class TFormSymbol,,,,NA			;剪切
	^c::		ControlClick,TButton9,ahk_class TFormSymbol,,,,NA			;复制
	^v::		ControlClick,TButton8,ahk_class TFormSymbol,,,,NA			;粘贴
	^!a::		ControlClick,TButton7,ahk_class TFormSymbol,,,,NA			;分别翻针，全部
	^a::		ControlClick,TButton6,ahk_class TFormSymbol,,,,NA			;分别翻针，当前
	^h::		ControlClick,TButton5,ahk_class TFormSymbol,,,,NA			;合并翻针
	F2::		ControlClick,TButton1,ahk_class TFormSymbol,,,,NA			;重命名



	;-------------------------图形界面-----------------------------------------;
	;放大缩小
	!WheelDown::	send, {NumpadSub}
	!WheelUp::send, {NumpadAdd}

	;增加
	i::
		ControlGetPos,,, w, h, TDrawingTools1, ahk_class TFormSymbol
		x := w * 0.5
		y := w + x
		ControlClick,TDrawingTools1, ahk_class TFormSymbol,,,,NA x%x% y%y%
		Return

	;直线
	l::
		ControlGetPos,,, w, h, TDrawingTools1, ahk_class TFormSymbol
		x := w * 0.5
		y := 2 * w + x
		ControlClick,TDrawingTools1, ahk_class TFormSymbol,,,,NA x%x% y%y%
		Return

	;曲线
	c::
		ControlGetPos,,, w, h, TDrawingTools1, ahk_class TFormSymbol
		x := w * 0.5
		y := 3 * w + x
		ControlClick,TDrawingTools1, ahk_class TFormSymbol,,,,NA x%x% y%y%
		Return

	;矩形
	r::
		ControlGetPos,,, w, h, TDrawingTools1, ahk_class TFormSymbol
		x := w * 0.5
		y := 4 * w + x
		ControlClick,TDrawingTools1, ahk_class TFormSymbol,,,,NA x%x% y%y%
		Return

	;填充
	f::
		ControlGetPos,,, w, h, TDrawingTools1, ahk_class TFormSymbol
		x := w * 0.5
		y := 5 * w + x
		ControlClick,TDrawingTools1, ahk_class TFormSymbol,,,,NA x%x% y%y%
		Return

	;文字
	t::
		ControlGetPos,,, w, h, TDrawingTools1, ahk_class TFormSymbol
		x := w * 0.5
		y := 6 * w + x
		ControlClick,TDrawingTools1, ahk_class TFormSymbol,,,,NA x%x% y%y%
		Return


	1::
	2::
	3::
	4::
	5::
	6::
	7::
	8::
		SelectColor()
		Return
	;颜色
	SelectColor()
	{
		ControlGetPos,,,, h, TTopToolBar1, ahk_class TFormSymbol
		h -= 2
		y := h * 0.5
		x := % A_ThisHotkey * h - y
		;ToolTip,%A_ThisHotkey%
		ControlClick,TTopToolBar1, ahk_class TFormSymbol,,,,NA x%x% y%y%
		Return
	}

	;撤销/重做
	^z::
		ControlGetPos,,,, h, TTopToolBar1, ahk_class TFormSymbol
		h -= 2
		y := h * 0.5
		x := 14 * h - y
		ControlClick,TTopToolBar1, ahk_class TFormSymbol,,,,NA x%x% y%y%
		Return

	^y::
		ControlGetPos,,,, h, TTopToolBar1, ahk_class TFormSymbol
		h -= 2
		y := h * 0.5
		x := 15 * h - y
		ControlClick,TTopToolBar1, ahk_class TFormSymbol,,,,NA x%x% y%y%
		Return



#IfWinActive ahk_class TFormEditGfSet

	^a::
		if YG_Selector > 0
		{
			YG_Selector += 1
			return
		}

		YG_Selector := 1
		SetTimer,Key_Ctrl_A, 500
		Return

		Key_Ctrl_A:
		SetTimer,Key_Ctrl_A,off
		if YG_Selector = 1
		{
			ControlClick,TButton2,ahk_class TFormEditGfSet,,,,NA
		}
		else
			ControlClick,TButton1,ahk_class TFormEditGfSet,,,,NA

		YG_Selector := 0
		Return





;===========================================Model RgnForm========================================================
#IfWinActive ahk_class TFormRgn


	^Delete::ControlClick,TButton1,ahk_class TFormRgn,,,,NA



	;------------------------------------------------------------------;
	;Ctrl+MiddeleClick: compass the selected yarn-guide numebers into a '[]'
	;Example: 5,4 became [5,4], just actived in RgnForm
	^MButton::
	{
		send,^x[^v]
		Return
	}
		
	CapsLock::ControlClick,TCheckBox1,,,,,NA
	;------------------------------------------------------------------;	
		;F1:	Generate a defult Rgn Path in Path type "1"
	F1::DefaultPathType(1)
	F4::DefaultPathType(4)
	F5::DefaultPathType(5)
		
	F6::
	{
		loop, 10
		{
			ControlClick,TButton8,ahk_class TFormRgn,,,,NA
			WinWaitActive,ahk_class TFormDefGfWay,,1
			if !ErrorLevel
				break
		}
			ControlClick,TRadioButton2,ahk_class TFormDefGfWay,,,,NA
			sleep 20
			ControlGet,isCheck_YG_path_rules,checked,,TCheckBox1,ahk_class TFormDefGfWay
			if !isCheck_YG_path_rules
				Control,check,,TCheckBox1,ahk_class TFormDefGfWay
			Sleep,100
			send {Enter}
	Return
	}	


	F11::
	{
		;计算路径行数
		row_count := CalculatRowsOfRgn()
		DefaultPathType(1)
		;如果区域行数大于2行，则也为多余的行数也生成路径
		if row_count > 2
		{
			old_path_list := getPathText()
			setNewPath(old_path_list,row_count)
		}
		Return
	}

	CalculatRowsOfRgn()
	{
		Global row_count := 0
		fullTittle := ""
		
		WinGetTitle,fullTittle,A
		subTittle := SubStr(fullTittle,InStr(fullTittle,A_Space) + 2 )
		StringTrimRight, subTittle, subTittle, 1

		numList := StrSplit(subTittle,",")
		row_count := numList[2] - numList[1]
		Return row_count
	}

	DefaultPathType(num)
	{
		Loop,10
		{
			ControlClick,TButton8,ahk_class TFormRgn,,,,NA
			WinWaitActive,ahk_class TFormDefGfWay,,0.5
			if !ErrorLevel
				break
			else
				Sleep,100
		}
		;当前区域
		ControlGet,isCurrentRgn,checked,,TRadioButton2,ahk_class TFormDefGfWay
		if !isCurrentRgn
			Control,check,,TRadioButton2,ahk_class TFormDefGfWay
		;取消导纱器路径规则
		ControlGet,isCheck_YG_path_rules,checked,,TCheckBox1,ahk_class TFormDefGfWay
		if isCheck_YG_path_rules
			Control,uncheck,,TCheckBox1,ahk_class TFormDefGfWay
		;设置路径类型 = 1
		ControlSetText ,TSpinEdit1,%num%
		Sleep,100
		send {Enter}
		WinWaitClose,ahk_class TFormDefGfWay,,1
		if ErrorLevel
			Return 0
		Return 1
	}

	getPathText()
	{
		ControlGetText,orginaal_path_text, TRichEdit1,Rgn
		;去除空白字符
		StringReplace, orginaal_path_text, orginaal_path_text, %A_SPACE%, , All
		;拆分为不同行
		numList := StrSplit(orginaal_path_text,"`n")
		
		;ToolTip,% numList[1]
		

	Return numList
	}

	setNewPath(path_list,row_count)
	{
		;
		new_path_list := []
		row_count += 1
		loop,%row_count%
		{
			if mod(A_Index,2)
			{
				path_str := path_list[1] . "`n"
				new_path_list.insert(path_str)
			}else{
				path_str := path_list[2] . "`n"
				new_path_list.insert(path_str)
			}		
		}
		Global new_path_Str := ""
			for k, v in new_path_list
				new_path_Str := new_path_Str . v
			;ToolTip, % new_path_Str
		 ControlSetText,TRichEdit1,%new_path_Str%,Rgn
	Return
	}

		
	;------------------------------------------------------------------;	
	; Ctrl+I :	Add or delete "Intarsia" RgnParameter
	^i::
	{
		;add RgnParameter "Intarsia = Yes" 
		;if it's exist, delete it.
		ControlGet,list1,List,,TListBox1,ahk_class TFormRgn
		row := GetParatmterListRowOfParameter(list1,"Int")
		if (row > 0)
		{
			ControlFocus, TListBox1,ahk_class TFormRgn
			send,{Down %row% + 1}		
			Sleep 100
			ControlClick,TButton1,ahk_class TFormRgn,,,,NA
			WinWait,ahk_class TFormBox,,0.5
			if ErrorLevel
				ControlClick,TButton1,ahk_class TFormRgn,,,,NA
			ControlClick,TButton2,ahk_class TFormBox,,,,NA
		}else{
			ControlClick,TButton3,,,,2,NA
			WinWaitActive,ahk_class TFormSelectElem
			if ErrorLevel
				send, {Enter}
			send i
			sleep 10
			send {Enter}
			WinWaitClose,TFormEditBool,,0.5
			if ErrorLevel
				send, {Enter}
			
			
		}
		ControlFocus,TButton15,Rgn
		Return
	}
	;------------------------------------------------------------------;

	; Ctrl+R :	Add or Delete "GfsRes = all Ygs" Rgn Parameter
	^r::
	{
		;获取当前区域的所有区域参数字符串
		ControlGet,RgnPrmtList,List,Selected,TListBox1,ahk_class TFormRgn
		;处理字符串，获取指定参数所在的行数
		row := GetParatmterListRowOfParameter(RgnPrmtList,"GfsRes")
		;如果行数值为0，则说明已存在参数，删除它
		if (row > 0)
		{
			ControlFocus, TListBox1,ahk_class TFormRgn
			send,{Down %row% + 1}		
			ControlClick,TButton1,ahk_class TFormRgn,,,,NA
			WinWait,ahk_class TFormBox,,0.5
			{
			if ErrorLevel
				ControlClick,TButton1,ahk_class TFormRgn,,,,NA
			ControlClick,TButton2,ahk_class TFormBox,,,,NA
			}
		}else{
			;如果行数为0，说明不存在，则创建默认参数
			ControlClick,TButton3,ahk_class TFormRgn,,,,NA
			WinWait,ahk_class TFormSelectElem,,0.5
			if ErrorLevel
				send,{Enter}
			sendInput gfsres
			send {Enter}
			WinWait,ahk_class TFormEditGfSet
			if !ErrorLevel
				{
				ControlClick,TButton2,ahk_class TFormEditGfSet,,,,NA
				; 剔除已有GfsMTSpecOut参数的纱嘴
				ucheckYgsWithGfsMTSpecOut(RgnPrmtList)
				ControlClick,TButton4,ahk_class TFormEditGfSet,,,,NA
				WinWaitClose,ahk_class TFormEditGfSet,,0.5
				if ErrorLevel
					Send,{enter}
			}
		}
	Return
	}




	^Del::
		ControlClick,TButton1,ahk_class TFormRgn,,,,NA
		WinWait,ahk_class TFormBox,是
			if !ErrorLevel
				ControlFocus,TButton2,ahk_class TFormBox
		Return


	;------------------------------------------------------------------;
	; Ctrl+P :	Add or Delete "GfsNoPin=all Ygs" Rgn Parameter to current Rgn
	^p::
	{
		;add RgnParameter "GfsNoPin = All" 
		;if it's exist, delete it.
		ControlGet,list1,List,Selected,TListBox1,ahk_class TFormRgn
		row := GetParatmterListRowOfParameter(list1,"GfsNoPin")
		if (row > 0)
		{
			ControlFocus, TListBox1,ahk_class TFormRgn
			send,{Down %row% + 1}		
			ControlClick,TButton1,ahk_class TFormRgn,,,,NA
			WinWait,ahk_class TFormBox,,0.5
			if ErrorLevel
				ControlClick,TButton1,ahk_class TFormRgn,,,,NA
			ControlClick,TButton2,ahk_class TFormBox,,,,NA
		}else{
			ControlClick,TButton3,ahk_class TFormRgn,,,,NA
			WinWait,ahk_class TFormSelectElem,,0.5
			if ErrorLevel
				WinWait,ahk_class TFormSelectElem,,0.5
			SendInput,GfsNoPin
			Send,{Enter}
			WinWait,ahk_class TFormEditGfSet,,0.5
			if ErrorLevel
				Send,{Enter}
			ControlClick,TButton2,ahk_class TFormEditGfSet,,,,NA
			Sleep,100
			ControlClick,TButton4,ahk_class TFormEditGfSet,,,,NA		
		}
		Return
	}

	^o::
	{
		;add RgnParameter "GfsNoPin = All" 
		;if it's exist, delete it.
		ControlGet,list1,List,Selected,TListBox1,ahk_class TFormRgn
		row := GetParatmterListRowOfParameter(list1,"GfsMTSpecOut")
		if (row > 0)
		{
			ControlFocus, TListBox1,ahk_class TFormRgn
			send,{Down %row% + 1}		
			ControlClick,TButton1,ahk_class TFormRgn,,,,NA
			WinWait,ahk_class TFormBox,,0.5
			if ErrorLevel
				ControlClick,TButton1,ahk_class TFormRgn,,,,NA
			ControlClick,TButton2,ahk_class TFormBox,,,,NA
		}else{
			ControlClick,TButton3,ahk_class TFormRgn,,,,NA
			WinWait,ahk_class TFormSelectElem,,0.5
			if ErrorLevel
				WinWait,ahk_class TFormSelectElem,,0.5
			SendInput,GfsMTSpecOut
			Send,{Enter}	
		}
		Return
	}





	;----------------------USEFUL FUCTIONS--------------------------------------------;
	 GetParatmterListRowOfParameter(ParaList,paraStr)
	{
		Row := 0
		Loop,Parse,ParaList,`n
		{
			para = %A_LoopField%
			if InStr(para,paraStr)
				Row = %A_Index%
				
		}
		Return Row
	}

	;剔除已有GfsMTSpecOut参数的纱嘴
	ucheckYgsWithGfsMTSpecOut(RgnPrmtList)
	{
		ygsList := GetPrmtValueList(RgnPrmtList,"GfsMTSpecOut")
		for k,v in ygsList
			Control,unCheck,,%v%,GfsRes
		Return
	}

	;获取指定区域参数(字符串)中指定参数名的值
	GetPrmtValueList(RgnPrmtList,RgnPrmtName)
	{
		;获取当前区域的所有区域参数文本内容
		;分析内容，查找是否有指定的参数，如果有则读取参数值
		Loop,Parse,RgnPrmtList,`n
		{
			PrmtStr := A_LoopField
			if InStr(PrmtStr,RgnPrmtName)
			{
				;获取需要的参数值
				valueStrList := StrSplit(PrmtStr,"=",A_Space)
				valueStr := valueStrList[2]
				;将获取的参数值字符串分解成list
				Return StrSplit(valueStr,",",A_Space)
			}
		}
		Return 
	}


	;判断光标是否在某个窗口上，具体原理很玄幻
	MouseIsOver(WinTitle) 
	{
		; 获取光标所在窗口的Title
		MouseGetPos,,, Win
		Return WinExist(WinTitle . " ahk_id " . Win)
	}
	;------------------------------------------------------------------;
	^NumpadEnter::
	^Enter:
	!NumpadEnter::
	!Enter::
	{
		ControlClick,TButton15,ahk_class TFormRgn,,,,NA
		Return
	}

	Esc::
	{
		;持续点击区域窗口的取消按钮
		Loop,10
		{
			ControlClick,TButton14,ahk_class TFormRgn,,,,NA
			WinWaitClose,ahk_class TFormRgn,,0.5
			if ErrorLevel
			{	
				;如果rgn窗口未被关闭，检测是否存在区域关闭确认窗口
				;存在确认窗口则退出循环
				IfWinExist,ahk_class TFormBox,,0.5
					Break
				else
					continue	;窗口未被关闭，且未检测到确认窗口就继续执行循环
			}else
				break		;窗口成功关闭则结束循环
		}
		Return
	}
	;------------------------------------------------------------------;

;===========================================定义色区窗口========================================================	
#IfWinActive, ahk_class TFormZone
	m::
	{
		ControlGet,isShapePoint,checked,,锚点,ahk_class TFormZone
		if isShapePoint
			Control,uncheck,,锚点,ahk_class TFormZone
		else
			Control,check,,锚点,ahk_class TFormZone
		Return
	}

	j::
	{
		ControlGet,isJacZone,checked,,提花,ahk_class TFormZone
		if isJacZone
			Control,uncheck,,提花,ahk_class TFormZone
		else
			Control,check,,提花,ahk_class TFormZone
	Return
	}

	q::
		ControlClick,线圈密度,ahk_class TFormZone,,,,NA
		Return

	g::
		ControlClick,底格,ahk_class TFormZone,,,,NA
		Return

;===========================================HqPDS========================================================	
#IfWinActive, HqPDS

	Home::Send,{Shift Down}{Up}{Shift Up}		;移动到最上方
	End::	Send,{Shift Down}{Down}{Shift Up}	;移动到最下方

	;打开窗口菜单，有时候Alt+W不起作用
	;^w::ControlClick,Menu Bar,HqPDS,,,,NA x250 y10	;绝对坐标？


	; 获取光标位置所在控件，如果是功能线区域的控件，则把滚轮转换为左右方向键
	$WheelUp::
		if isMousePosInControl("AfxFrameOrView140u12") or isMousePosInControl("AfxFrameOrView140u13")
			send,{Left}
		else
			send,{WheelUp}
		Return

	$WheelDown::
		if isMousePosInControl("AfxFrameOrView140u12") or isMousePosInControl("AfxFrameOrView140u13")
			send,{Right}
		else
			send,{WheelDown}
		Return

	isMousePosInControl(controlName)
	{
		MouseGetPos,,,,CurrControlName,1		; 最后的1非常关键，用来正确获取多窗口界面的控件名称
		Return (controlName == CurrControlName)

	}

	;替换Ctrl+A为Ctrl+Alt+A，防止按Ctrl+S时候老是按错
	^a::	Return
	^!a::	Send,{CtrlDown}a{CtrlUp}

	;------------------------------------------------------------------;
	^b::
		if isMousePosInControl("AfxFrameOrView140u4")
		{
			ControlClick,AfxFrameOrView140u4,HqPDS,,R,1,NA				; 复制到文件
			send,{Up 8}{right}{Enter}
		}
		Return


	XButton1::
	{
		Send {CtrlDown}{F9}{CtrlUp}											; 开始编译
		WinWait,编译选项,,1
		{
			ControlGet,isShowingCompileInfoAlways,checked,,显示编译信息,编译选项	; 始终显示编译信息
			if !isShowingCompileInfoAlways
				Control,check,,显示编译信息,编译选项
				
			ControlGet,isSplitTrasnferOnFrontBackNeddleBed,checked,,前后床分别翻针,编译选项	; 始终显示编译信息
			if isSplitTrasnferOnFrontBackNeddleBed
				Control,uncheck,,前后床分别翻针,编译选项	
				
			ControlGet,isComplieToCNT,checked,,编译为CNT,编译选项	; 始终显示编译信息
			if !isComplieToCNT
				Control,check,,编译为CNT,编译选项
				
			Control,Choose,5,ListBox1,编译选项			
			ControlGet,isUse_81_3,checked,,优化81-3动作,编译选项			; 禁用“优化81-3动作”
			if isUse_81_3
				Control,uncheck,,优化81-3动作,编译选项	
			
			Sleep,500
			Send, {Enter}
		}
		Return
	}

	; Ctrl+鼠标侧键1：开始编译，监视并强制执行某些编译选项
	^XButton1::
	{
		Send {CtrlDown}{F9}{CtrlUp}														; 开始编译

		WinWait,编译选项,,1
		{
		ControlGet,isClampWithScissors,checked,,剪夹联动,编译选项					; 始终剪夹联动
		if !isClampWithScissors
			Control,check,,剪夹联动,编译选项
		
		ControlGet,isShowingCompileInfoAlways,checked,,显示编译信息,编译选项	; 始终显示编译信息
		if !isShowingCompileInfoAlways
			Control,check,,显示编译信息,编译选项
		
		ControlGet,isGenerateToCNT,checked,,编译为CNT,编译选项	; 始终显示编译信息
		if !isGenerateToCNT
			Control,check,,编译为CNT,编译选项
			
		Control,Choose,2,ListBox1,编译选项												; 切换到自动处理
		
		ControlGetText,AutoYgsOutStr,ComboBox1,编译选项								; 始终编织时纱出
		if !(AutoYgsOutStr == "编织时纱出")
			Control,Choose,2,ComboBox1,编译选项
			
		ControlGet,isClampInStitchDropRows,checked,,落布区剪夹,编译选项			; 始终落布区剪夹
		if !isClampInStitchDropRows											
			Control,check,,落布区剪夹,编译选项
		
		ControlGet,isModuleExcutedPartly,checked,,允许部分小图,编译选项			; 始终允许部分小图
		if !isModuleExcutedPartly
			Control,check,,允许部分小图,编译选项
		
		Control,Choose,5,ListBox1,编译选项												; 切换到自动处理
		
		ControlGet,isUse_81_3,checked,,优化81-3动作,编译选项			; 禁用“优化81-3动作”
		if isUse_81_3
			Control,uncheck,,优化81-3动作,编译选项
		
		if !GetKeyState("Ctrl")																; 如果按住Control键不松手，停止继续编译
			Send,{Enter}
		}
		Return
	}


	; 设置编译选项中纱嘴跟随的数值都为10
	!XButton1::
	{
		Send {CtrlDown}{F9}{CtrlUp}														; 开始编译

		WinWait,编译选项,,1
		{
		Control,Choose,2,ListBox1,编译选项												; 切换到自动处理
		
		ControlGetText,Edit1Text,Edit1,编译选项
		if !(Edit1Text == 10)
			ControlSetText,Edit1,10
		ControlGetText,Edit2Text,Edit2,编译选项
		if !(Edit2Text == 10)
			ControlSetText,Edit2,10
		ControlGetText,Edit3Text,Edit3,编译选项
		if !(Edit3Text == 10)
			ControlSetText,Edit3,10
		ControlGetText,Edit4Text,Edit4,编译选项
		if !(Edit4Text == 10)
			ControlSetText,Edit4,10
		
		Send,{Enter}
		}
		Return
	}

	^r::
	if isMousePosInControl("AfxFrameOrView140u4")
	{
		ControlClick,AfxFrameOrView140u4,HqPDS,,R,1,NA				; 如果光标在绘图区，弹出工具属性窗口
		send,{Up 2}{Enter}
	}
	Return



	;------------------------------------------------------------------;
	; Ctrl+Alt+F9：批量编译并关闭当前所有已打开的恒强文件，
	^!F9::
		CoordMode,Mouse,Window
		WinGetPos,,,WW,WH,HqPDS
		x := WW-20
		y := 48

	MsgBox,4,4, 即将开始自动批量编译。当前已打开的所有文档都会被逐个自动编译并关闭。`n编译过程中如遇到花版严重错误会自动停止。`n你确定要进行自动批量编译吗？
	IfMsgBox No	;如果选择否，直接退出
		Return
	;开始批量编译
	Loop
	{
		ToolTip,正在处理...
		Sleep,200
		WinActivate,HqPDS
		WinWait,HqPDS,,20
		if ErrorLevel
			{
			ToolTip
			Return
			; 如果恒强未在前台，退出
			}
			
		if isHqPDSFileEmpty()
		{
			ToolTip,
			Return	; 如果所有程序都被关闭，退出
		}
		Send,{LControl Down}{F9}{LControl Up}	;发送编译快捷键：Ctrl+F9
		Sleep,500
		WinWait,编译选项,,30
		if ErrorLevel
		{
			; 如果按下Ctrl+F9键，20秒内未弹出编译选项窗口，退出
			; 如果用户在高级设置里未勾选“显示编译选项”，则不能继续
			MsgBox, 抱歉，未检测到编译选项窗口。请检查重试...	
			ToolTip
			Break
		}else{
			ControlGet,isShowingCompileInfoAlways,checked,,显示编译信息,编译选项	
			; 始终显示编译信息
			if !isShowingCompileInfoAlways
				Control,check,,显示编译信息,编译选项
				
			;检测到编译选项窗口，开始处理
			Send,{Enter}
			WinWaitClose,编译选项,,1
			ToolTip, 正在编译...
			Sleep,3000
			; 等编译选项窗口消失后，等待3秒开始检测弹出的窗口
			Loop{
				; 如果弹出窗口时编译信息窗口，则继续
				; 如果弹出窗口“提示”或“错误”的文字，则报错
				WinWait,ahk_class #32770,,1
				{
					;获取弹出的窗口的标题文字内容
					WinGetTitle,MsgBoxTitle,ahk_class #32770
					;是否发现“编译信息”文字
					findWinInfo		:= 	InStr(MsgBoxTitle,"编译信息")	
					;是否发现“提示”或“错误”文字
					findWinError 	:= 	InStr(MsgBoxTitle,"提示") + InStr(MsgBoxTitle,"错误")
					;发现“编译信息”，跳出当前循环，继续编译
					if findWinInfo
						Break
					else{
						;如果发现“提示”或“错误”文字，报错
						if findWinError
						{
							MsgBox,"错误处理",发现错误,编译终止。
							Return
						}
					}
				}
				Sleep, 500
			}
		; 关闭“编译信息”
		Sleep, 1000
		WinClose,编译信息
		ToolTip,编译结束...尝试保存并关闭当前花样... 
		WinActivate,HqPDS
		ControlClick,x%x% y%y%,HqPDS	;关闭当前程序，准备处理下一个
		}
		ToolTip
	}
	Return

	isHqPDSFileEmpty()
	{
		ControlGetPos,X_Temp,,,,AfxFrameOrView140u4,HqPDS
		return X_Temp
	}






	;-----------------------------------------------------------------;
	; Ctrl+Alt+S: Save AS
	^!s::
	^+s::
		Send,{AltDown}f{AltUp}
		Send,a
		Return


	;------------------------------------------------------------------;
	; Ctrl+Q:	close current PDS file
	^q::
	{
		CoordMode,Mouse,Window
		WinGetPos,,,WW,WH,HqPDS
		x := WW-20
		y := 48
		ControlClick,x%x% y%y%,HqPDS
		Return
	}


	;---------------------------------------------------------------;

	!WheelDown::
	{
		CoordMode,Mouse,Screen
		MouseGetPos,M1x,M1y,CurWin
		CoordMode,Mouse,Relative
		ControlGetPos,x,y,w,h,机器工具栏,A
		btn_y := y + h * 0.5
		btn_x :=x + w - h * 0.5
		
		;ControlClick,机器工具栏,A,,,,NA x%btn_x% y%bt_y% ;会引起按钮消失？
		Send,{Click %btn_x%, %btn_y%}
		WinWait,模板,,2
		if ErrorLevel
		{
			ToolTip,打开模块窗口失败!
			Sleep,2000
			ToolTip,
			Return
		}else{
			CoordMode,Mouse,Screen
			MouseMove,M1x,M1y
			ToolTip,
			
			;读取ini文件的list，生成一个gui，可以是listViwe，显示出来
			SendMessage, 0x1330, 1,, SysTabControl321, 模板	;切换到文件（关键一步）
			
			WinGetPos,Win_X,Win_Y,,,模板							;获取模板窗口的坐标
			controlGetPos,Static1_x,Static1_y,Static1_w,Static1_h,Static1,模板	;获取框体尺寸位置
			Static1_x := Win_X + Static1_x
			Static1_y := Win_Y + Static1_y + Static1_h		;运算出要显示的GUI的尺寸和位置,其实可以写到函数里
			
			showGUI(Static1_x,Static1_y,Static1_w,Static1_h)	;显示窗口
			
			Gosub,GetAndAsveTextOnEdit							;
			Return
		}
	}

	showGUI(gui_x,gui_y,gui_w,gui_h)
	{
		;计算UI Frame
		;从配置文件读出数据
		;设定动作
		
		gui_h := gui_w * 0.5
		
		Gui,New
		Gui +AlwaysOnTop -Caption +ToolWindow  ; +ToolWindow 避免显示任务栏按钮和 alt-tab 菜单项.
		Gui,Add,ListView, w%gui_w% h%gui_h% gMylistView NoSort count10 Grid,最近调用的模块

		loop,10
		{
			IniRead,ModuleAdd,%HQ_INI_ADD%,LastUsedModule,%A_Index%
			LV_Add("",ModuleAdd)
		}
		LV_ModifyCol() 
		
		Gui,Show, x%gui_x% y%gui_y% w%gui_w% h%gui_h% ,LastUsedModule

		SetTimer,correctGuiFrame,200	;设定计时器，使Gui跟随模板窗口、隐藏出现、移动和消失
		Return	
	}



	GetAndAsveTextOnEdit:
	{
		;从配置文件中读取出10个最近调用的文件地址，组成数组LastUsedModuleList
		
		Global LastUsedModuleList := []			;清空数组
		loop,10
		{
			IniRead, moduleAdd, %HQ_INI_ADD%, LastUsedModule, %A_Index%, "空"	;从配置文件中读取出数据到数组
			LastUsedModuleList.insert(moduleAdd)
		}
		;设定计时器，一直读取Edit1中的text，模板窗口关闭后，如果读取成功且判断文件存在，将其保存在list头部
		SetTimer,GetTextFromEdit1,200
		Return

	}

	GetTextFromEdit1:
	{
		IfWinExist,模板
			ControlGetText,Edit1Text,Edit1,模板
		else{
			if (Edit1Text and FileExist(Edit1Text))
			{
				;去重插入，如果已有相同值，则将其移到首位置
				LastUsedModuleList := InsertIntoListNoRepeat(Edit1Text,LastUsedModuleList)
			}
			SetTimer,GetTextFromEdit1,off
			;更新配置文件
			SaveConfig()
		}
	Return
	}

	SaveConfig()
	{
		for k,v in LastUsedModuleList
			if ((k < 11) and v)
				IniWrite,%v%,%HQ_INI_ADD%,LastUsedModule,%A_Index%
		LastUsedModuleList := []	;清空数组
	Return
	}


	MylistView:
	{
		;双击ListView时，执行的动作
		LV_GetText(OutputText,A_EventInfo,1)	;获取点击行的text
		ControlSetText,Edit1,%OutputText%,模板	;输出text到Edit1中
		Return
	}


	correctGuiFrame:
	{
		;模板窗口未激活时，如果发现被关闭，Gui也一起关闭
		IfWinNotActive,模板
		{
			IfWinNotExist ,模板
			{
				WinKill,LastUsedModule
				SetTimer,correctGuiFrame,OFF
			}else{
				 IfWinNotActive,LastUsedModule
					winHide,LastUsedModule	;如果发现只是未激活，隐藏GUI防止遮挡其他窗口
			}
		}else
			Winshow,LastUsedModule
			
		WinGetPos,Win_X,Win_Y,,,模板							;获取模板窗口的坐标
		controlGetPos,Static1_x,Static1_y,Static1_w,Static1_h,Static1,模板	;获取框体尺寸位置
		lastModuleFrame_x := Win_X + Static1_x
		lastModuleFrame_y := Win_Y + Static1_y + Static1_h		;运算出要显示的GUI的尺寸和位置
		;高度不能超过SysTabControl321的下边缘
		controlGetPos,,tabConbtrol_y,,tabConbtrol_h,SysTabControl321,模板
		lastModuleFrame_h := tabConbtrol_y + tabConbtrol_h - ( Static1_y + Static1_h) - 2
		
		WinMove,LastUsedModule,,lastModuleFrame_x,lastModuleFrame_y,,lastModuleFrame_h
		
		controlMove,SysListView321,x0 ,y0 ,,h%lastModuleFrame_h%,LastUsedModule
		Return
	}


	isInList(e,myList)
	{

		for k,v in myList
		{
			if (e = v)
				return k
		}
		return False

	}

	InsertIntoListNoRepeat(n,myList)
	{
		index := isInList(n,myList)
		if index
			myList.RemoveAt(index)
		myList.Insert(1,n)
		Return myList
	}


	; Ctrl+Alt+下滚轮：直接调用上次的小图（需要在恒强-高级-设置-模块管理-快捷键：Ctrl+M）
	^!WheelDown::
	{
		Send,{CtrlDown}m{CtrlUp}											; 利用快捷键调出导入恒强模块窗口
		WinWait,模板,,2
		if ErrorLevel
			Return
		else
		{
			SendMessage, 0x1330, 1,, SysTabControl321, 模板			; 切换到文件选项卡
			lastUsedModuleAddress := ReadModuleAddressFromIni()		; 读取配置文件中保存的上一个模块地址
			
			ControlSetText,Edit1,%lastUsedModuleAddress%,模板		; 调用函数，写入调出的模块地址
			ControlClick,确定,模板,,,,NA									; 确定
			WinWaitClose,模板,,1
			if ErrorLevel
				Send, {Enter}
		}
		Return
	}





	^!m::
	{
		if MouseIsOver(HqPDS)
		{
			Click,Right
			WinWait,ahk_class #32768,,1
			if ErrorLevel
				Return
			send,{Up 5}
			Send,{Right}
			Send,{Down 2}
			Send,{Enter}
			WinWait,模板,,1
			if ErrorLevel
				Return
			else
				ControlClick,Button7,模板,,,,NA	
			Sleep,1000
			WinWaitClose,另存为
			Sleep,200
			ControlFocus,Button1,模板,,,,NA
		}
		Return
	}

	ReadModuleAddressFromIni()
	{
		IniRead, moduleAdd, %HQ_INI_ADD%, LastUsedModule, 1, 0	;从配置文件中读取出数据到数组
		return moduleAdd

	}

	!WheelUp::		Send,{ctrl down}{F2}{ctrl up}
	+WheelUp::		Send,{ctrl down}{F3}{ctrl up}
	^WheelUp::		^PgUp
	^WheelDown::		^PgDn




	;=========================模块替换功能=================
	^`::
	{
		DetectHiddenWindows, On
		; 如果"模块替换"窗口不存在，则用<Alt+F8>按键打开模块替换
		ifWinNotExist,模块替换
		{
			Send,!{F8}
			WinWait,模块替换,,3
			if ErrorLevel
				Return
		}
		Goto findModule1
	}


	!`::
	{
		DetectHiddenWindows, On
		; 如果"模块替换"窗口不存在，则用<Alt+F8>按键打开模块替换
		ifWinNotExist,模块替换
		{
			Send,!{F8}
			WinWait,模块替换,,3
			if ErrorLevel
				Return
		}
		Goto findModule2
	}

	MoveMouseToCenterOfWindow(ConTittle)
	{
		WinGetPos,x,y,w,h,%ConTittle%
		;ToolTip,x = %w%
		if w>0
		{
			Mx := x + w * 0.5
			My := y + h * 0.5
			MouseMove,Mx,My
		}
		Return
	}

#IfWinActive,模块替换

	findModule1:
	^`::
		; 点击找到按钮
		
		ifWinExist,模块替换
		{
			WinShow,模块替换
			WinActivate,模块替换
			MoveMouseToCenterOfWindow(模块替换)
		}
		Sleep,100
		SetControlDelay -1
		ControlClick,找到,模块替换,,,,NA
		WinWait,提示,大小不符,1
		if !ErrorLevel
		{
			Sleep,1000
			WinActivate
			;ControlClick,确定,提示,,,,NA
		}
		Return

	findModule2:
	!`::
		; 点击替换按钮
		
		ifWinExist,模块替换
		{
			WinShow,模块替换
			WinActivate,模块替换
			MoveMouseToCenterOfWindow(模块替换)
		}
		Sleep,100
		SetControlDelay -1
		ControlClick,Button4,模块替换,,,,NA
		WinWait,提示,大小不符,1
		if !ErrorLevel
		{
			Sleep,1000
			WinActivate
			;ControlClick,确定,提示,,,,NA
		}
		Return

	^Enter::	ControlClick,Button1,模块替换,,,,NA

	BackSpace::	ControlClick,Button5,模块替换,,,,NA

	Space::	ControlClick,Button6,模块替换,,,,NA

	;==========================模块替换功能结束================


	
	
;===========================================Model Shape Tool========================================================

#IfWinActive,ahk_class TFormShapeTool

	;------------------------------------------------------------------;
	^o::WinMenuSelectItem,,,1&,2&
	^s::WinMenuSelectItem,,,1&,3&
	F6::WinMenuSelectItem,,,3&,1&
	F7::WinMenuSelectItem,,,4&,1&
	;------------------------------------------------------------------;

	;===========================================提示窗口========================================================
	;处理恒强打开较低版本程序时，弹出的“8把纱嘴花样，是否打开?”的窗口
	;当弹出此窗口时，按下热键，自动点击确定，10秒内再次弹出，再点击确定，10秒内不弹出，结束循环

	#ifWinActive, 提示
	wait_count := 0
	^!8::
	{
		setTimer,Process_8_YG_MSGBOX,1000	;设定计时器，每1秒执行1次
		Return
	}

	Process_8_YG_MSGBOX:
	{
		
		IfWinExist,提示,8把纱嘴
		{
			ControlClick,确定,提示,8把纱嘴,,,NA
			WinWaitClose,提示
			if ErrorLevel
				Send,{Enter}
			wait_count := 0	;发现窗口,计数清零
		}
		
		wait_count += 1		;如果没有发现，计数加1
		if wait_count > 20	;20秒后，计时器停止并计数清零
		{
			setTimer,Process_8_YG_MSGBOX,off
			wait_count := 0
		}

	Return
	}

;===========================================CKS========================================================

#ifWinActive, ahk_exe PaintRettilinee.exe
	!WheelUp::		F12
	!WheelDown::		F11


	; 已失效，因为CKS控件名称不固定
	F1::
		ControlGetText,Box1Str,TCheckBox1,ahk_class TMainForm
		if (Box1Str == "查看全部")
			ControlClick,TCheckBox3,ahk_class TMainForm
		else
			ControlClick,TCheckBox2,ahk_class TMainForm
		Return	
	F2::
		ControlGetText,Box1Str,TCheckBox1,ahk_class TMainForm
		if (Box1Str == "查看全部")
			ControlClick,TCheckBox2,ahk_class TMainForm
		else
			ControlClick,TCheckBox1,ahk_class TMainForm
		Return

	; 打开选择纱嘴窗口，可能不会很实用
	!F1::ControlClick,TPanel14,ahk_class TMainForm,,,,NA x48 y17


	XButton1::
		if MouseIsOver(TMainForm)
		{
			Send,{LControl Down}a{LControl Up}
			Send,{Down 1}
			Send,{Enter}
		}
		Return

	^XButton1::
		if MouseIsOver(TMainForm)
		{
			Send,{LControl Down}a{LControl Up}
			Send,{Down 2}
			Send,{Enter}
		}
		Return

;===========================================Model YGs Dialog========================================================

#IfWinActive ahk_class TFormGuideFils
	F1::Control,Choose,1,TComboBox1,ahk_class TFormGuideFils ; 正在使用
	F2::Control,Choose,2,TComboBox1,ahk_class TFormGuideFils ; 吊线
	F3::Control,Choose,3,TComboBox1,ahk_class TFormGuideFils ; 添纱
	F4::Control,Choose,4,TComboBox1,ahk_class TFormGuideFils ; 向右
	F5::Control,Choose,5,TComboBox1,ahk_class TFormGuideFils ; 纱夹
	F6::Control,Choose,6,TComboBox1,ahk_class TFormGuideFils ; 气
	F7::Control,Choose,7,TComboBox1,ahk_class TFormGuideFils ; 纱夹(-)

	/*
	; 此快捷键运行良好，但是后来又使用了计时器的方法，新快捷键 = ^!8
	#IfWinActive,提示

	!Esc::
	Loop
	{
		WinWait,提示,8把纱嘴花样,10
		if ErrorLevel
			Break
		else{
			WinActivate,提示
			{
				ControlClick,确定,提示
				WinWaitClose,提示,,0.5
				if ErrorLevel
					Send,{Enter} 
			}
		}
	}
	Return
	*/

;===========================================Generual========================================================


#IfWinActive , ahk_exe Explorer.EXE
	^Up::
	Send,{AltDown}{Up}{AltUp}{Up}{Enter}
	Return


	^Down::
	Send,{AltDown}{Up}{AltUp}{Down}{Enter}
	Return








#IfWinActive




;------------------------------------------------------------------;
;HotKey:Ctrl+`: show FloatView Window
^`::
	{
	;If FloatView Window is not Exist, open it
	;If FloatView Window is Exist but not actived, show it
	;If FloatView Window is actived, close it
		ifWinActive, TFormFloatView
			WinClose
		else{
			ifWinExist,TFormFloatView
				WinActivate
			else
				WinMenuSelectItem,Model,,5&,14&
			}
		Return
	}
	;------------------------------------------------------------------;
	;HotKey:AppsKey(MenuKey):Switch the Input Tools
	AppsKey::Send,{LWinDown}{Space}{LWinUp}
	;------------------------------------------------------------------;


	#w::Run WINWORD.exe,,UseErrorLevel  
	#x::Run EXCEL.exe,,UseErrorLevel  



	#f::
	{
		ifWinActive,ahk_class EVERYTHING
			WinMinimize
		else{
			ifWinExist,ahk_class EVERYTHING
				WinActivate
			else
				Run C:\Program Files\Everything\Everything.exe,,UseErrorLevel  
			}
	Return
	}

	#g::
	{
		ifWinActive,ahk_exe GoodSync.exe
			WinMinimize
		else{
			ifWinExist,ahk_exe GoodSync.exe
				WinActivate
			else
				Run C:\Program Files\Siber Systems\GoodSync\GoodSync.exe,,UseErrorLevel  
			}
	Return
	}

	#n::
	{
		ifWinActive,ahk_class Notepad++
			WinMinimize
		else{
			ifWinExist,ahk_class Notepad++
				WinActivate
			else
				Run notepad++.exe,,UseErrorLevel  
			}
	Return
	}
	#WheelDown::		#^Right
	#WheelUp::		#^Left

	PAUSE::	PAUSE
	!PAUSE::	ExitApp






;==========================================Useful Fuctions===========================




	DetectHiddenWindows, On
	; 检测光标下的控件尺寸、title、class、控件内文本信息等内容
	^!MButton::
	{
		MouseGetPos,,,CurWin,CurCon,1
		ControlGetPos,,,ConW,ConH,%CurCon%,ahk_id %CurWin%
		WinGetClass,CurClass,ahk_id %CurWin%
		WinGetTitle,CurTitle,ahk_id %CurWin%
		ControlGetText,ControlText,%CurCon%,ahk_id %CurWin%
		WinGetText,WinText,ahk_id %CurWin%
		SubControlText := SubStr(ControlText,1,50)
		SubWinText := SubStr(WinText,1,50)
		ToolTip,%  "控件尺寸: `t(" 			ConW "," ConH 	")`n " 
					. "ControlName:`t" 			CurCon 			"`n "
					. "Tittle:`t`t" 				CurTitle 			"`n"
					. "ahk_clsss:`t" 			CurClass 			"`n" 
					. "ControlText:`t"			SubControlText 	"`n" 
					. "WinText:`t"				SubWinText		"`n" 
		Return
	}

	~*MButton Up::ToolTip,

	#s::
	{
		ifWinActive,Window Spy
			WinMinimize
		else{
			ifWinExist,Window Spy
				WinActivate
			else
				Run C:\Users\88543\Desktop\一些想法不一定对\AHK学习\工具合集\5.窗口信息工具\WindowSpy.exe,,UseErrorLevel
			}
	Return
	}


	#h::
	{
		ifWinActive,HqPDS
			WinMinimize
		else{
			ifWinExist,HqPDS
				WinActivate
			else{
				Run C:\Program Files (x86)\恒强\横机制板系统（16把纱嘴）\HxPDS.exe,,UseErrorLevel
				}
			}
	Return
	}


	#c::Send,{CtrlDown}c{CtrlUp}
	#z::Send,{CtrlDown}z{CtrlUp}







	^F12::
	{
		keylist2 :=["Alt+鼠标滚轮上滚|放大绘图区|绘图工具"
		,"Alt+鼠标滚轮下滚|缩小绘图区|绘图工具"
		,"F11|放大绘图区|绘图工具"
		,"F12|缩小绘图区|绘图工具"
		,"鼠标中键|检查/不检查|工具栏"
		,"鼠标侧键1|出带|工具栏"
		,"Ctrl+N|新建花样|菜单栏"
		,"Ctrl+Shift+S|另存为|菜单栏"
		,"Ctrl+T|保存暂存文件|菜单栏"
		,"Ctrl+Shift+T|读出暂存文件|菜单栏"
		,"Ctrl+Alt+B|导入位图|菜单栏"
		,"Ctrl+Shift+B|新建针法符号|菜单栏"
		,"Ctrl+F6|恢复底样|菜单栏"
		,"Alt+W|查看警告|菜单栏"
		,"Alt+F|查看提花浮线|菜单栏"
		,"Alt+``|切换花型设计视图|菜单栏"
		,"F1|生成缺省的导纱器路径，类型1|区域窗口内"
		,"F4|生成缺省的导纱器路径，类型4|区域窗口内"
		,"F5|生成缺省的导纱器路径，类型5|区域窗口内"
		,"Ctrl+鼠标中键|将选中的导纱器路径合并系统，例如选中3,5,9变为[3,5,9]|区域窗口内导纱器路径文字"
		,"Ctrl+I|增加'Intarsia=是'的区域参数或删除它|区域窗口内"
		,"Ctrl+R|增加'GfsRes=所有导纱器'的区域参数或删除它|区域窗口内"
		,"Ctrl+P|增加'GfsNoPin=所有导纱器'的区域参数或删除它|区域窗口内"
		,"Ctrl+O|打开设定GfsMTSpecOut的窗口或删除它|区域窗口内"
		,"Alt++|Rgn+，切换到下个区域|区域窗口内"
		,"Alt+-|Rgn-，切换到上个区域|区域窗口内"
		,"CapsLock|切换导纱器路径编辑模式|区域窗口内"
		,"Ctrl+Enter|区域窗口的执行按钮|区域窗口内"
		,"Ctrl+O|打开一个成型文件|成型窗口内"
		,"Ctrl+S|保存当前成型文件|成型窗口内"
		,"F6|建立成型视图|成型窗口内"
		,"F7|编辑成型针法符号|成型窗口内"
		,"Ctrl+F12|查看快捷键帮助窗口|Model"
		,"Ctrl+鼠标滚轮上滚|上滚绘图区|Model"
		,"Ctrl+鼠标滚轮下滚|下滚绘图区|Model"]

		keylist1 :=["Alt+WheelUp|Zoom In|Model"
		,"Alt+WheelDown|Zoom Out|Model"
		,"F11|Zoom In|Model"
		,"F12|Zoom Out|Model"
		,"Wheel MiddeleClick|Check/UnCheck|Model"
		,"XButton1|Generate(XButton1 is a key on the left side of some mouse)|Model"
		,"Ctrl+N|New Article|Model"
		,"Ctrl+Shift+S|Save As|Model"
		,"Ctrl+T|Save Temp|Model"
		,"Ctrl+Shift+T|Open Temp|Model"
		,"Ctrl+Alt+B|Convert BMP|Model"
		,"Ctrl+Shift+B|New Symbol|Model"
		,"Ctrl+F6|Restore Background|Model"
		,"Alt+W|View/Close/Show Warnings|Model"
		,"Alt+F|View/Close/Show Floats(jacquard)|Model"
		,"Alt+``|Shift Design View|Model"
		,"F1|Generate Default Yg-Path with path type 1 for current region|Region Dialog"
		,"F4|Generate Default Yg-Path with path type 4 for current region|Region Dialog"
		,"F5|生Generate Default Yg-Path with path type 5 for current region|Region Dialog"
		,"Ctrl+Mouse MiddeleClick|Enclose selected Yg-Path text,such as '3,5,9' will change to '[3,5,9]'|Region Dialog"
		,"Ctrl+I|Set Region Parameter 'Intarsia = 是'(or delete if exist)|Region Dialog"
		,"Ctrl+R|Set Region Parameter 'GfsRes = All Necessary YGs'or delete if exist)|Region Dialog"
		,"Ctrl+P|Set Region Parameter 'GfsNoPin = All Necessary YGs'or delete if exist)|Region Dialog"
		,"Ctrl+O|Set Region Parameter 'GfsSpecOut = All Necessary YGs'or delete if exist)|Region Dialog"
		,"Alt++|Rgn+，Goto Next Region|Region Dialog"
		,"Alt+-|Rgn-，Goto Previous Region|Region Dialog"
		,"CapsLock|Yg Path Editor|Region Dialog"
		,"Ctrl+Enter|click 'OK' button of Region Dialog|Region Dialog"
		,"Ctrl+O|Open a Shape file|Shape Dialog"
		,"Ctrl+S|Save Shape file|Shape Dialog"
		,"F6|Creat a shape view|Shape Dialog"
		,"F7|Modify shape Symbols|Shape Dialog"
		,"Ctrl+F12|Open This Window|Model"
		,"Ctrl+WheelUp|Next Design View|Model"
		,"1~7|"
		,"Ctrl+WheelDown|PreviousDesign View|Model"]



		Gui New
		;Gui, Margin , 8, 8
		Gui, +Resize

		Gui, Add,ListView,, HotKeys|Fuctions|Working Area

		Loop,% keylist2.length()
		{
			keyA := keylist2[A_Index]
			keyListA := StrSplit(keyA,"|")
			LV_Add("",keyListA[1],keyListA[2],keyListA[3])
		}
		LV_ModifyCol() 

		Gui, Font,cBlue bold
		Gui Add, Text,,此Model制版辅助软件仅适用于Mode 9版本，如需其他版本或者交流沟通，请发邮件到：88543702@qq.com,vTips
		Gui, Font

		Gui Show,W800 h600,Model制版辅助工具帮助信息
		Return

		GuiSize:  
		if A_EventInfo = 1  
			return
		GuiControl, Move, SysListView321, % "W" . (A_GuiWidth - 16) . " H" . (A_GuiHeight - 36)
		WinGetTitle, Title, A
		if Title = Model制版辅助工具帮助信息
			GuiControl, Move, Static1, % " Y" . (A_GuiHeight - 20)
		return
	}

;==========================================================================================



	#MButton::	Send {Media_Play_Pause}
	#XButton1::	Send {Media_Next}			; 上一曲
	#XButton2::	Send {Media_Prev}			;下一曲


	/*
	很少用，怀疑会引起鼠标指针灵敏度混乱
	~CapsLock::
	SPI_GETMOUSESPEED := 0x70
	SPI_SETMOUSESPEED := 0x71
	; 获取鼠标当前的速度以便稍后恢复:
	DllCall("SystemParametersInfo", "UInt", SPI_GETMOUSESPEED, "UInt", 0, "UIntP", OrigMouseSpeed, "UInt", 0)
	; 现在在倒数第二个参数中设置较低的速度 (范围为 1-20, 10 是默认值):
	DllCall("SystemParametersInfo", "UInt", SPI_SETMOUSESPEED, "UInt", 0, "Ptr", 3, "UInt", 0)
	KeyWait CapsLock  ; 这里避免了由于键盘的重复特性导致再次执行 DllCall.
	return

	~CapsLock up::DllCall("SystemParametersInfo", "UInt", 0x71, "UInt", 0, "Ptr", OrigMouseSpeed, "UInt", 0)  ; 恢复原来的速度.
	*/

		;*************************************************************************
		;
		;	用热字符串快捷打开指定的文件夹
		; * m ：事坦格文件夹
		; * x ：慈星文件夹
		; *  ：慈星文件夹
		;
		;=========================================================================

	::m20::
	Run F:\事坦格\2020\
	Return

	::m19::
	Run F:\事坦格\2019\
	Return

	::m18::
	Run F:\事坦格\2018\
	Return

	::m17::
	Run F:\事坦格\2017\
	Return

	::m16::
	Run F:\事坦格\2016\
	Return

	::m15::
	Run F:\事坦格\2015\
	Return

	::x20::
	Run F:\慈星\2020\
	Return

	::x19::
	Run F:\慈星\2019\
	Return

	::x18::
	Run F:\慈星\2018\
	Return

	::x17::
	Run F:\慈星\2017\
	Return

	::x16::
	Run F:\慈星\2016\
	Return

	::x15::
	Run F:\慈星\2015\
	Return













/*
;光标在任务栏上停靠时，鼠标控制音乐切换
;内存损耗过大？好用但是暂时不用了。
#If MouseIsOver("ahk_class Shell_TrayWnd")
WheelUp::		Send {Volume_Up}
WheelDown::	Send {Volume_Down}
MButton::		Send {Media_Play_Pause}
XButton1::		Send {Media_Next}
XButton2::		Send {Media_Prev}

#If
*/



; cmd /k C:\AutoHotkey\AutoHotkey.exe "$(FULL_CURRENT_PATH)" & PAUSE & EXIT

/*
#NoEnv
#Warn
#SingleInstance Force
SetWorkingDir %A_ScriptDir%

Gui Add, Button, x24 y632 w75 h23, 按钮
Gui Add, Tab2,x10 y10 w800 h600, 恒强980|Model 9|智能吓数|智能方格纸|文件直通车|鼠标变形|系统设置|软件设置
Gui Tab, 1
Gui Add, GroupBox, x24 y48 w390 h160, 分组框
Gui Add, CheckBox, x40 y72 w120 h23, 复选框
Gui Add, CheckBox, x40 y104 w120 h23, 复选框
Gui Add, CheckBox, x40 y136 w120 h23, 复选框
Gui Add, CheckBox, x40 y168 w120 h23, 复选框
Gui Show, w900 h660, 设置
return

GuiEscape:
GuiClose:
    ExitApp

; GUI区域结束
*/
