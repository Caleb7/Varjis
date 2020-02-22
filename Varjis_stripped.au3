Global Const $UBOUND_DIMENSIONS = 0
Global Const $UBOUND_ROWS = 1
Global Const $UBOUND_COLUMNS = 2
Global Const $STR_ENTIRESPLIT = 1
Global Const $STR_NOCOUNT = 2
Global Const $STR_REGEXPARRAYMATCH = 1
Global Const $_ARRAYCONSTANT_SORTINFOSIZE = 11
Global $__g_aArrayDisplay_SortInfo[$_ARRAYCONSTANT_SORTINFOSIZE]
Global Const $_ARRAYCONSTANT_tagLVITEM = "struct;uint Mask;int Item;int SubItem;uint State;uint StateMask;ptr Text;int TextMax;int Image;lparam Param;" & "int Indent;int GroupID;uint Columns;ptr pColumns;ptr piColFmt;int iGroup;endstruct"
#Au3Stripper_Ignore_Funcs=__ArrayDisplay_SortCallBack
Func __ArrayDisplay_SortCallBack($nItem1, $nItem2, $hWnd)
If $__g_aArrayDisplay_SortInfo[3] = $__g_aArrayDisplay_SortInfo[4] Then
If Not $__g_aArrayDisplay_SortInfo[7] Then
$__g_aArrayDisplay_SortInfo[5] *= -1
$__g_aArrayDisplay_SortInfo[7] = 1
EndIf
Else
$__g_aArrayDisplay_SortInfo[7] = 1
EndIf
$__g_aArrayDisplay_SortInfo[6] = $__g_aArrayDisplay_SortInfo[3]
Local $sVal1 = __ArrayDisplay_GetItemText($hWnd, $nItem1, $__g_aArrayDisplay_SortInfo[3])
Local $sVal2 = __ArrayDisplay_GetItemText($hWnd, $nItem2, $__g_aArrayDisplay_SortInfo[3])
If $__g_aArrayDisplay_SortInfo[8] = 1 Then
If(StringIsFloat($sVal1) Or StringIsInt($sVal1)) Then $sVal1 = Number($sVal1)
If(StringIsFloat($sVal2) Or StringIsInt($sVal2)) Then $sVal2 = Number($sVal2)
EndIf
Local $nResult
If $__g_aArrayDisplay_SortInfo[8] < 2 Then
$nResult = 0
If $sVal1 < $sVal2 Then
$nResult = -1
ElseIf $sVal1 > $sVal2 Then
$nResult = 1
EndIf
Else
$nResult = DllCall('shlwapi.dll', 'int', 'StrCmpLogicalW', 'wstr', $sVal1, 'wstr', $sVal2)[0]
EndIf
$nResult = $nResult * $__g_aArrayDisplay_SortInfo[5]
Return $nResult
EndFunc
Func __ArrayDisplay_GetItemText($hWnd, $iIndex, $iSubItem = 0)
Local $tBuffer = DllStructCreate("wchar Text[4096]")
Local $pBuffer = DllStructGetPtr($tBuffer)
Local $tItem = DllStructCreate($_ARRAYCONSTANT_tagLVITEM)
DllStructSetData($tItem, "SubItem", $iSubItem)
DllStructSetData($tItem, "TextMax", 4096)
DllStructSetData($tItem, "Text", $pBuffer)
If IsHWnd($hWnd) Then
DllCall("user32.dll", "lresult", "SendMessageW", "hwnd", $hWnd, "uint", 0x1073, "wparam", $iIndex, "struct*", $tItem)
Else
Local $pItem = DllStructGetPtr($tItem)
GUICtrlSendMsg($hWnd, 0x1073, $iIndex, $pItem)
EndIf
Return DllStructGetData($tBuffer, "Text")
EndFunc
Global Enum $ARRAYFILL_FORCE_DEFAULT, $ARRAYFILL_FORCE_SINGLEITEM, $ARRAYFILL_FORCE_INT, $ARRAYFILL_FORCE_NUMBER, $ARRAYFILL_FORCE_PTR, $ARRAYFILL_FORCE_HWND, $ARRAYFILL_FORCE_STRING, $ARRAYFILL_FORCE_BOOLEAN
Func _ArrayAdd(ByRef $aArray, $vValue, $iStart = 0, $sDelim_Item = "|", $sDelim_Row = @CRLF, $iForce = $ARRAYFILL_FORCE_DEFAULT)
If $iStart = Default Then $iStart = 0
If $sDelim_Item = Default Then $sDelim_Item = "|"
If $sDelim_Row = Default Then $sDelim_Row = @CRLF
If $iForce = Default Then $iForce = $ARRAYFILL_FORCE_DEFAULT
If Not IsArray($aArray) Then Return SetError(1, 0, -1)
Local $iDim_1 = UBound($aArray, $UBOUND_ROWS)
Local $hDataType = 0
Switch $iForce
Case $ARRAYFILL_FORCE_INT
$hDataType = Int
Case $ARRAYFILL_FORCE_NUMBER
$hDataType = Number
Case $ARRAYFILL_FORCE_PTR
$hDataType = Ptr
Case $ARRAYFILL_FORCE_HWND
$hDataType = Hwnd
Case $ARRAYFILL_FORCE_STRING
$hDataType = String
Case $ARRAYFILL_FORCE_BOOLEAN
$hDataType = "Boolean"
EndSwitch
Switch UBound($aArray, $UBOUND_DIMENSIONS)
Case 1
If $iForce = $ARRAYFILL_FORCE_SINGLEITEM Then
ReDim $aArray[$iDim_1 + 1]
$aArray[$iDim_1] = $vValue
Return $iDim_1
EndIf
If IsArray($vValue) Then
If UBound($vValue, $UBOUND_DIMENSIONS) <> 1 Then Return SetError(5, 0, -1)
$hDataType = 0
Else
Local $aTmp = StringSplit($vValue, $sDelim_Item, $STR_NOCOUNT + $STR_ENTIRESPLIT)
If UBound($aTmp, $UBOUND_ROWS) = 1 Then
$aTmp[0] = $vValue
EndIf
$vValue = $aTmp
EndIf
Local $iAdd = UBound($vValue, $UBOUND_ROWS)
ReDim $aArray[$iDim_1 + $iAdd]
For $i = 0 To $iAdd - 1
If String($hDataType) = "Boolean" Then
Switch $vValue[$i]
Case "True", "1"
$aArray[$iDim_1 + $i] = True
Case "False", "0", ""
$aArray[$iDim_1 + $i] = False
EndSwitch
ElseIf IsFunc($hDataType) Then
$aArray[$iDim_1 + $i] = $hDataType($vValue[$i])
Else
$aArray[$iDim_1 + $i] = $vValue[$i]
EndIf
Next
Return $iDim_1 + $iAdd - 1
Case 2
Local $iDim_2 = UBound($aArray, $UBOUND_COLUMNS)
If $iStart < 0 Or $iStart > $iDim_2 - 1 Then Return SetError(4, 0, -1)
Local $iValDim_1, $iValDim_2 = 0, $iColCount
If IsArray($vValue) Then
If UBound($vValue, $UBOUND_DIMENSIONS) <> 2 Then Return SetError(5, 0, -1)
$iValDim_1 = UBound($vValue, $UBOUND_ROWS)
$iValDim_2 = UBound($vValue, $UBOUND_COLUMNS)
$hDataType = 0
Else
Local $aSplit_1 = StringSplit($vValue, $sDelim_Row, $STR_NOCOUNT + $STR_ENTIRESPLIT)
$iValDim_1 = UBound($aSplit_1, $UBOUND_ROWS)
Local $aTmp[$iValDim_1][0], $aSplit_2
For $i = 0 To $iValDim_1 - 1
$aSplit_2 = StringSplit($aSplit_1[$i], $sDelim_Item, $STR_NOCOUNT + $STR_ENTIRESPLIT)
$iColCount = UBound($aSplit_2)
If $iColCount > $iValDim_2 Then
$iValDim_2 = $iColCount
ReDim $aTmp[$iValDim_1][$iValDim_2]
EndIf
For $j = 0 To $iColCount - 1
$aTmp[$i][$j] = $aSplit_2[$j]
Next
Next
$vValue = $aTmp
EndIf
If UBound($vValue, $UBOUND_COLUMNS) + $iStart > UBound($aArray, $UBOUND_COLUMNS) Then Return SetError(3, 0, -1)
ReDim $aArray[$iDim_1 + $iValDim_1][$iDim_2]
For $iWriteTo_Index = 0 To $iValDim_1 - 1
For $j = 0 To $iDim_2 - 1
If $j < $iStart Then
$aArray[$iWriteTo_Index + $iDim_1][$j] = ""
ElseIf $j - $iStart > $iValDim_2 - 1 Then
$aArray[$iWriteTo_Index + $iDim_1][$j] = ""
Else
If String($hDataType) = "Boolean" Then
Switch $vValue[$iWriteTo_Index][$j - $iStart]
Case "True", "1"
$aArray[$iWriteTo_Index + $iDim_1][$j] = True
Case "False", "0", ""
$aArray[$iWriteTo_Index + $iDim_1][$j] = False
EndSwitch
ElseIf IsFunc($hDataType) Then
$aArray[$iWriteTo_Index + $iDim_1][$j] = $hDataType($vValue[$iWriteTo_Index][$j - $iStart])
Else
$aArray[$iWriteTo_Index + $iDim_1][$j] = $vValue[$iWriteTo_Index][$j - $iStart]
EndIf
EndIf
Next
Next
Case Else
Return SetError(2, 0, -1)
EndSwitch
Return UBound($aArray, $UBOUND_ROWS) - 1
EndFunc
Global Const $FLTA_FILESFOLDERS = 0
Global Const $PATH_ORIGINAL = 0
Global Const $PATH_DRIVE = 1
Global Const $PATH_DIRECTORY = 2
Global Const $PATH_FILENAME = 3
Global Const $PATH_EXTENSION = 4
Func _FileListToArray($sFilePath, $sFilter = "*", $iFlag = $FLTA_FILESFOLDERS, $bReturnPath = False)
Local $sDelimiter = "|", $sFileList = "", $sFileName = "", $sFullPath = ""
$sFilePath = StringRegExpReplace($sFilePath, "[\\/]+$", "") & "\"
If $iFlag = Default Then $iFlag = $FLTA_FILESFOLDERS
If $bReturnPath Then $sFullPath = $sFilePath
If $sFilter = Default Then $sFilter = "*"
If Not FileExists($sFilePath) Then Return SetError(1, 0, 0)
If StringRegExp($sFilter, "[\\/:><\|]|(?s)^\s*$") Then Return SetError(2, 0, 0)
If Not($iFlag = 0 Or $iFlag = 1 Or $iFlag = 2) Then Return SetError(3, 0, 0)
Local $hSearch = FileFindFirstFile($sFilePath & $sFilter)
If @error Then Return SetError(4, 0, 0)
While 1
$sFileName = FileFindNextFile($hSearch)
If @error Then ExitLoop
If($iFlag + @extended = 2) Then ContinueLoop
$sFileList &= $sDelimiter & $sFullPath & $sFileName
WEnd
FileClose($hSearch)
If $sFileList = "" Then Return SetError(4, 0, 0)
Return StringSplit(StringTrimLeft($sFileList, 1), $sDelimiter)
EndFunc
Func _PathSplit($sFilePath, ByRef $sDrive, ByRef $sDir, ByRef $sFileName, ByRef $sExtension)
Local $aArray = StringRegExp($sFilePath, "^\h*((?:\\\\\?\\)*(\\\\[^\?\/\\]+|[A-Za-z]:)?(.*[\/\\]\h*)?((?:[^\.\/\\]|(?(?=\.[^\/\\]*\.)\.))*)?([^\/\\]*))$", $STR_REGEXPARRAYMATCH)
If @error Then
ReDim $aArray[5]
$aArray[$PATH_ORIGINAL] = $sFilePath
EndIf
$sDrive = $aArray[$PATH_DRIVE]
If StringLeft($aArray[$PATH_DIRECTORY], 1) == "/" Then
$sDir = StringRegExpReplace($aArray[$PATH_DIRECTORY], "\h*[\/\\]+\h*", "\/")
Else
$sDir = StringRegExpReplace($aArray[$PATH_DIRECTORY], "\h*[\/\\]+\h*", "\\")
EndIf
$aArray[$PATH_DIRECTORY] = $sDir
$sFileName = $aArray[$PATH_FILENAME]
$sExtension = $aArray[$PATH_EXTENSION]
Return $aArray
EndFunc
Global $UTTER_SPEECH_RECOGNIZE
Global $UTTER_SPEECH_VAR
Global $UTTER_SPEECH_ERROR
Global $UTTER_SPEECH_RECOSTATE
Global $UTTER_SPEECH_RESPONSE
Global $UTTER_SPEECH_FUNC
Global $UTTER_SPEECH_PASS = 0
Global $oMyError
Func _Utter_Speech_StartEngine()
$h_Context = ObjCreate("SAPI.SpInProcRecoContext")
$comer = @error
$h_Recognizer = $h_Context.Recognizer
$oRecoContext = $h_Context
$oVBS = ObjCreate("ScriptControl")
$oVBS.Language = "VBScript"
$oNothing = $oVBS.Eval("Nothing")
$oRecoContext.CreateGrammar(0)
$oGrammar = $oRecoContext.CreateGrammar()
$h_Grammar = $oGrammar
$oMyError = ObjEvent("AutoIt.Error","MyErrFunc")
_nullifyvariable()
Global $array[8]
$array[0] = $oRecoContext
$array[1] = $h_Recognizer
$array[2] = 'null'
$array[3] = $oVBS
$array[4] = $oNothing
$array[5] = $h_Grammar
$array[6] = "Error:" &$comer
$array[7] = $oMyError
Return $array
EndFunc
Func _Utter_Speech_CreateGrammar(ByRef $ark,$gramr,$trn="")
_CheckObject($ark)
$ftr = _checkgrammar($gramr)
$btr = _checkgrammar($trn)
$oGrammar = $ark[5]
$oTopRule = $oGrammar.Rules.Add('RUN', 1, 0)
$oWordsRule = $oGrammar.Rules.Add('WORDS', BitOR(1, 32), 1)
$oAfterCmdState = $oTopRule.AddState()
For $i = 0 To UBound($ftr)-1
$oTopRule.InitialState.AddWordTransition($oAfterCmdState, $ftr[$i])
$oAfterCmdState.AddRuleTransition($ark[4], $oWordsRule)
Next
For $i = 0 To UBound($btr) -1
$oWordsRule.InitialState.AddWordTransition($ark[4], $btr[$i])
Next
$oGrammar.Rules.Commit()
$oGrammar.CmdSetRuleState('RUN', 1)
Local $array[3]
$array[0] = $oTopRule
$array[1] = $oAfterCmdState
$array[2] = $oWordsRule
Return $array[2]
EndFunc
Func _Utter_Speech_CreateTokens(ByRef $ark)
$h_Recognizer = $ark[1]
$h_Category = ObjCreate("SAPI.SpObjectTokenCategory")
$h_Category.SetId("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Speech\AudioInput\TokenEnums\MMAudioIn\")
$h_Token = ObjCreate("SAPI.SpObjectToken")
$h_Token.SetId("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Speech\AudioInput\TokenEnums\MMAudioIn\")
$h_Recognizer.AudioInput = $h_Token
Local $array[2]
$array[0] = $h_Category
$array[1] = $h_Token
Return $array[1]
EndFunc
Func _Utter_Speech_GrammarRecognize(ByRef $ark,$grm="",$delay=1000,$func="")
$hk = ObjEvent($ark[0], 'RecoContext_')
$UTTER_SPEECH_ERROR = @error
$UTTER_SPEECH_VAR = $grm
$UTTER_SPEECH_FUNC = ""
If Not $func = "" Then $UTTER_SPEECH_FUNC = $func
Sleep($delay)
Return $hk
EndFunc
Func _Utter_Speech_ShutdownEngine()
_nullifyvariable()
$hk = 0
$h_Context = 0
$h_Recognizer = 0
$oRecoContext = 0
$oVBS = 0
$oGrammar = 0
$oMyError = 0
$oTopRule = 0
$oWordsRule = 0
$oAfterCmdState = 0
$h_Category = 0
$h_Token = 0
$hk = 0
$oNothing = 0
EndFunc
Func _nullifyvariable()
$UTTER_SPEECH_RECOGNIZE = ""
$UTTER_SPEECH_VAR = ""
$UTTER_SPEECH_ERROR = ""
$UTTER_SPEECH_RECOSTATE = ""
$UTTER_SPEECH_RESPONSE = ""
$UTTER_SPEECH_FUNC = ""
$UTTER_SPEECH_PASS = ""
EndFunc
Func _checkgrammar($atb)
$char = Opt("GUIDataSeparatorChar")
If IsArray($atb) Then
Return $atb
ElseIf StringInStr($atb,$char) Then
$split = StringSplit($atb,$char,2)
Return $split
Else
Local $ark[1]
$ark[0] = $atb
Return $ark
EndIf
EndFunc
Func _CheckObject($ark)
ObjName($ark[0])
If @error Then MsgBox("","Utter","Handler not valid")
EndFunc
Func MyErrFunc()
Msgbox(0,"Utter COM Test","We intercepted a COM Error !" & @CRLF & @CRLF & "err.description is: " & @TAB & $oMyError.description & @CRLF & "err.windescription:" & @TAB & $oMyError.windescription & @CRLF & "err.number is: " & @TAB & hex($oMyError.number,8) & @CRLF & "err.lastdllerror is: " & @TAB & $oMyError.lastdllerror & @CRLF & "err.scriptline is: " & @TAB & $oMyError.scriptline & @CRLF & "err.source is: " & @TAB & $oMyError.source & @CRLF & "err.helpfile is: " & @TAB & $oMyError.helpfile & @CRLF & "err.helpcontext is: " & @TAB & $oMyError.helpcontext )
Local $err = $oMyError.number
If $err = 0 Then $err = -1
$g_eventerror = $err
Endfunc
Global $SpeechPhrasesFile_Approval = @ScriptDir & "\phrases\approval.txt"
Global $SpeechPhrasesFile_Denial = @ScriptDir & "\phrases\denial.txt"
Global $SpeechPhrasesFile_Trigger = @ScriptDir & "\phrases\trigger.txt"
Global $SpeechPhrasesFile_Plugins = @ScriptDir & "\plugins\"
Global $SpeechToTextPhrases_Trigger = ImportPhraseString($SpeechPhrasesFile_Trigger)
Global $SpeechToTextPhrases_Approval = ImportPhraseArray($SpeechPhrasesFile_Approval, @CRLF)
Global $SpeechToTextPhrases_Denial = ImportPhraseArray($SpeechPhrasesFile_Denial, @CRLF)
Global $SpeechToTextPhrases_Commands[0]
Global $SpeechToTextPhrases_Actions[0]
Global $VoiceRecognitionEngine
Global $Run = True
ImportPlugins()
$VoiceRecognitionEngine = _Utter_Speech_StartEngine()
Global $phrases[UBound($SpeechToTextPhrases_Commands)]
For $i = 0 To UBound($SpeechToTextPhrases_Commands) - 1
Local $a = StringSplit($SpeechToTextPhrases_Commands[$i], "|", 3)
$phrases[$i] = $SpeechToTextPhrases_Trigger & " " & $a[0]
Next
_Utter_Speech_CreateGrammar($VoiceRecognitionEngine, $phrases)
_Utter_Speech_CreateTokens($VoiceRecognitionEngine)
_Utter_Speech_GrammarRecognize($VoiceRecognitionEngine, "", 0, "OnSpeechRegistered")
While $Run
Sleep(10)
WEnd
_Utter_Speech_ShutdownEngine()
Func ImportPhraseArray($file, $delimiter)
Local $f = FileOpen($file)
Local $d = FileRead($f)
Local $a = StringSplit($d, $delimiter, 3)
FileClose($f)
Return $a
EndFunc
Func ImportPhraseString($file)
Local $f = FileOpen($file)
Local $d = FileRead($f)
FileClose($f)
Return $d
EndFunc
Func ImportPlugins()
Local $files = _FileListToArray($SpeechPhrasesFile_Plugins, "*.au3", 1, True)
Local $count = UBound($files) - 1
For $i = 1 To $count
If $files[$i] <> $SpeechPhrasesFile_Plugins & "\test.au3" Then
LoadPlugin($files[$i])
EndIf
Next
EndFunc
Func LoadPlugin($path)
Local $sDrive = "", $sDir = "", $sFileName = "", $sExtension = ""
Local $aPathSplit = _PathSplit($path, $sDrive, $sDir, $sFileName, $sExtension)
Local $file = FileOpen($path)
Local $data = FileRead($file)
Local $start = StringInStr($data, "#cs commands" & @CRLF, 0, 1) + 14
Local $end = StringInStr($data, "#ce commands", 0, 1)
Local $commands = StringSplit(StringMid($data, $start, $end - $start), @CRLF, 3)
Local $count = UBound($commands)
For $i = 0 To $count - 2
_ArrayAdd($SpeechToTextPhrases_Commands, $commands[$i])
_ArrayAdd($SpeechToTextPhrases_Actions, $sFileName)
Next
FileClose($file)
EndFunc
