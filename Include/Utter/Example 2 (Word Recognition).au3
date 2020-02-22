#include "./Include/Utter.au3"

Global $name = "joe"

Global $phrases = [ "add switch", "exit" ]

For $i = 0 To UBound( $phrases ) - 1
	$phrases[$i] = $name & " " & $phrases[$i]
Next

;here "|" is default GUIDataSeparatorChar delimiter so string will be split from the delimiter
$recognize = _Utter_Speech_StartEngine() ;initializes the engine
_Utter_Speech_CreateGrammar($recognize,$phrases) ;Creates a grammar with the words
_Utter_Speech_CreateTokens($recognize) ;Creates a token for registering speech recognition
_Utter_Speech_GrammarRecognize($recognize,"",0,"_spchin") ;Starts the recognition and calls the word recognized to the _spchin function

While 1
	Sleep (50)
WEnd

_Utter_Speech_ShutdownEngine() ;shutdowns the function

Func _spchin($dummy)
	Local $command = StringReplace( $dummy, $name & " ", "" )
	action($command)
EndFunc

Func action( $action )
	Switch $action
		Case "add switch"
			WriteCode_SwitchBlock()
	EndSwitch
EndFunc



Func WriteCode_Switch()
	Send( "Switch $switch" )
	Sleep( 50 )
	Send( "{ENTER}" )
	Sleep( 50 )
	Send( "{ENTER}" )
	Sleep( 50 )
	Send( 'Case ""' )
	Sleep( 50 )
	Send( "{ENTER}" )
	Sleep( 50 )
	Send( "{ENTER}" )
	Sleep( 50 )
	Send( "{BACKSPACE}" )
	Sleep( 50 )
	Send( "{BACKSPACE}" )
	Sleep( 50 )
	Send( "EndSwitch" )
	Sleep( 50 )
	Send( "{ENTER}" )
	Send( "{ENTER}" )
EndFunc

