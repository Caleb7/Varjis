#cs ----------------------------------------------------------------------------
 AutoIt Version: 3.3.14.5
 Author: 			Caleb Alexander
 Script Function: 	Plugin for Varjis
#ce ----------------------------------------------------------------------------


#cs commands
test
#ce commands

$oVoice = ObjCreate( "SAPI.SpVoice" )
$oVoice.Speak( "Test command registered." )