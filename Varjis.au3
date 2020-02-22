#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Compression=0
#AutoIt3Wrapper_Add_Constants=n
#AutoIt3Wrapper_Run_Tidy=y
#AutoIt3Wrapper_Run_Au3Stripper=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#cs ----------------------------------------------------------------------------
 AutoIt Version: 3.3.14.5
 Author: Caleb Alexander
 Script Function: Speech Control
 Dependencies:  Utter.au3
#ce ----------------------------------------------------------------------------

; ###################################################
; Includes
; ###################################################
#include <Array.au3>
#include <File.au3>
#include "Include/Utter.au3"

; ###################################################
; Words
; ###################################################
Global $SpeechPhrasesFile_Approval = @ScriptDir & "\phrases\approval.txt"
Global $SpeechPhrasesFile_Denial = @ScriptDir & "\phrases\denial.txt"
Global $SpeechPhrasesFile_Trigger = @ScriptDir & "\phrases\trigger.txt"
Global $SpeechPhrasesFile_Plugins = @ScriptDir & "\plugins\"
Global $SpeechToTextPhrases_Trigger = ImportPhraseString($SpeechPhrasesFile_Trigger)                  ; phrase
Global $SpeechToTextPhrases_Approval = ImportPhraseArray($SpeechPhrasesFile_Approval, @CRLF)          ; phrase@CRLFphrase
Global $SpeechToTextPhrases_Denial = ImportPhraseArray($SpeechPhrasesFile_Denial, @CRLF)              ; phrase@CRLFphrase
Global $SpeechToTextPhrases_Commands[0]
Global $SpeechToTextPhrases_Actions[0]
Global $VoiceRecognitionEngine
Global $Run = True
Global $Active = True
;Exit

; ###################################################
; Initialize
; ###################################################
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

; ###################################################
; Functions
; ###################################################

Func OnSpeechRegistered($text)

	ConsoleWrite("Debug: " & $text & @CRLF)

	If Not $Active Then
		Return
	EndIf

	For $i = 0 To UBound($SpeechToTextPhrases_Commands) - 1
		ConsoleWrite("Input: " & $text & @TAB & "Action: " & $SpeechToTextPhrases_Actions[$i] & ".au3" & @TAB & "Compare: " & $SpeechToTextPhrases_Commands[$i] & @TAB & $SpeechToTextPhrases_Actions[$i] & ".au3" & @CRLF)
		If $text == $SpeechToTextPhrases_Trigger & " " & $SpeechToTextPhrases_Commands[$i] Then
			Run(@ScriptDir & "\AutoIt3\AutoIt3.exe " & @ScriptDir & "\Plugins\" & $SpeechToTextPhrases_Actions[$i] & ".au3")
			ExitLoop
		EndIf
	Next
EndFunc   ;==>OnSpeechRegistered

Func ImportPhraseArray($file, $delimiter)
	Local $f = FileOpen($file)
	Local $d = FileRead($f)
	Local $a = StringSplit($d, $delimiter, 3)
	FileClose($f)
	Return $a
EndFunc   ;==>ImportPhraseArray

Func ImportPhraseString($file)
	Local $f = FileOpen($file)
	Local $d = FileRead($f)
	FileClose($f)
	Return $d
EndFunc   ;==>ImportPhraseString

Func ImportPlugins()
	Local $files = _FileListToArray($SpeechPhrasesFile_Plugins, "*.au3", 1, True)
	Local $count = UBound($files) - 1
	For $i = 1 To $count
		If $files[$i] <> $SpeechPhrasesFile_Plugins & "\test.au3" Then
			LoadPlugin($files[$i])
		EndIf
	Next

	;_ArrayDisplay( $SpeechToTextPhrases_Commands )
	;_ArrayDisplay( $SpeechToTextPhrases_Actions )

EndFunc   ;==>ImportPlugins

Func LoadPlugin($path)
	Local $sDrive = "", $sDir = "", $sFileName = "", $sExtension = ""
	Local $aPathSplit = _PathSplit($path, $sDrive, $sDir, $sFileName, $sExtension)
	Local $file = FileOpen($path)
	Local $data = FileRead($file)
	Local $start = StringInStr($data, "#cs commands" & @CRLF, 0, 1) + 14
	Local $end = StringInStr($data, "#ce commands", 0, 1)
	Local $commands = StringSplit(StringMid($data, $start, $end - $start), @CRLF, 3)
	Local $count = UBound($commands)
	Local $array[UBound($commands)]
	For $i = 0 To $count - 2
		_ArrayAdd($SpeechToTextPhrases_Commands, $commands[$i])
		_ArrayAdd($SpeechToTextPhrases_Actions, $sFileName)
	Next
	FileClose($file)
EndFunc   ;==>LoadPlugin
















