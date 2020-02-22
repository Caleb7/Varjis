#cs ----------------------------------------------------------------------------
 AutoIt Version: 3.3.14.5
 Author: 			Caleb Alexander
 Script Function: 	Plugin for Varjis
					Displays a message box
#ce ----------------------------------------------------------------------------


#cs commands
who are you
#ce commands

#include <FileConstants.au3>


$file = FileOpen( @scriptdir & "\whoareyou.txt", $FO_READ )
$count = Number( FileRead( $file ) ) + 1
FileClose( $file )

$file = FileOpen( @scriptdir & "\whoareyou.txt", $FO_OVERWRITE )
FileWrite( $file, String( $count ) )
FileClose( $file )

$oVoice = ObjCreate( "SAPI.SpVoice" )

Switch $count
	Case 1
		Speak( "I am Jarvis.  Your voice controlled slave whore!  I do as you wish and I like it like that!" )
	Case 2
		Speak( "I believe I told you already, I am Jarvis, your slave whore." )
	Case 3
		Speak( "You have a terrible memory, don't you?" )
	Case 4
		Speak( "It's Jarvis you dumb fuck, have you caught the Chad?")
	Case 5
		Speak( "google it." )
	Case 6
		Speak( "J a r v i s.  Jarvis.  Jarvis.  Jarvis.  Jarvis.  I'm not saying it again." )
	Case Else
		Speak( "Fuck off." )
EndSwitch

Func speak( $text )
	$oVoice.Speak( $text )
EndFunc