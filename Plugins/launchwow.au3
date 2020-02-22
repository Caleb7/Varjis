#cs ----------------------------------------------------------------------------
 AutoIt Version: 3.3.14.5
 Author: 			Caleb Alexander
 Script Function: 	Plugin for Varjis
					Displays a message box
#ce ----------------------------------------------------------------------------


#cs commands
launch wow
launch world of warcraft
load wow
load world of warcraft
#ce commands

$oVoice = ObjCreate( "SAPI.SpVoice" )
$oVoice.Speak( "Loading wow master caleb" )
RunWait( "C:\Program Files (x86)\World of Warcraft\World of Warcraft Launcher.exe" )
$oVoice.Speak( "Your task is done master caleb may I have some food?" )