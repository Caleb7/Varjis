#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Compression=0
#AutoIt3Wrapper_Change2CUI=n
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
#include "Include/Utter.au3"

; ###################################################
; Words
; ###################################################
Global $SpeechPhrasesFile_Approval = @ScriptDir & "\phrases\approval.txt"
Global $SpeechPhrasesFile_Denial = @ScriptDir & "\phrases\denial.txt"
Global $SpeechPhrasesFile_Trigger = @ScriptDir & "\phrases\trigger.txt"
Global $SpeechPhrasesFile_Commands = @ScriptDir & "\phrases\commands.txt"
Global $SpeechToTextPhrases_Trigger = ImportPhraseString( $SpeechPhrasesFile_Trigger )				; phrase
Global $SpeechToTextPhrases_Approval = ImportPhraseArray( $SpeechPhrasesFile_Approval, @CRLF )		; phrase@CRLFphrase
Global $SpeechToTextPhrases_Denial = ImportPhraseArray( $SpeechPhrasesFile_Denial, @CRLF )			; phrase@CRLFphrase
Global $SpeechToTextPhrases_Commands = ImportPhraseArray( $SpeechPhrasesFile_Commands, @CRLF )		; phrase|function@CRLFphrase|function
Global $VoiceRecognitionEngine
Global $Voice
Global $Run = True
Global $Active = True

; ###################################################
; Initialize
; ###################################################
$oVoice = ObjCreate( "SAPI.SpVoice" )
$VoiceRecognitionEngine = _Utter_Speech_StartEngine()

Global $phrases[ UBound( $SpeechToTextPhrases_Commands ) ]
For $i = 0 To UBound( $SpeechToTextPhrases_Commands ) - 1
	Local $a = StringSplit( $SpeechToTextPhrases_Commands[$i], "|", 3 )
	$phrases[$i] = $SpeechToTextPhrases_Trigger & " " & $a[0]
Next
_ArrayDisplay( $phrases )

_Utter_Speech_CreateGrammar( $VoiceRecognitionEngine,$phrases )
_Utter_Speech_CreateTokens( $VoiceRecognitionEngine )
_Utter_Speech_GrammarRecognize( $VoiceRecognitionEngine, "", 0, "OnSpeechRegistered" )

While $Run
	Sleep( 10 )
WEnd

_Utter_Speech_ShutdownEngine()

; ###################################################
; Functions
; ###################################################
Func Speak( $text )
	$oVoice.Speak( $text )
EndFunc

Func OnSpeechRegistered( $text )

	ConsoleWrite( "Debug: " & $text & @CRLF )

	If NOT $Active Then
		Return
	EndIf

	If $text == $SpeechToTextPhrases_Trigger & " exit" Then
		$Run = False
		Return
	EndIf

	For $i = 0 To UBound( $SpeechToTextPhrases_Commands ) - 1
		Local $c = StringLeft( $SpeechToTextPhrases_Commands[$i], StringLen( $text ) )
		If $c == $text Then
			local $a = StringSplit( $SpeechToTextPhrases_Commands[$i], "@", 3 )
			; command = $a[0]
			; execute file $a[1]
			ConsoleWrite( "Command found: " & $a[0] & @CRLF & "Function found: " & $a[1] & @CRLF & @CRLF )
			ExitLoop
		EndIf
	Next
EndFunc

Func ImportPhraseArray( $file, $delimiter )
	Local $f = FileOpen( $file )
	Local $d = FileRead( $f )
	Local $a = StringSplit( $d, $delimiter, 3 )
	FileClose( $f )
	Return $a
EndFunc

Func ImportPhraseString( $file )
	Local $f = FileOpen( $file )
	Local $d = FileRead( $f )
	FileClose( $f )
	Return $d
EndFunc