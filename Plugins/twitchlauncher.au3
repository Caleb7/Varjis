#cs ----------------------------------------------------------------------------
 AutoIt Version: 3.3.14.5
 Author: 			Caleb Alexander
 Script Function: 	Plugin for Varjis
#ce ----------------------------------------------------------------------------


#cs commands
launch twitch
load twitch
open twitch
#ce commands

$oVoice = ObjCreate( "SAPI.SpVoice" )
$oVoice.Speak( "Launching twitch" )
Run( "C:\Users\Dream\AppData\Roaming\Twitch\Bin\twitch.exe" )