#cs ----------------------------------------------------------------------------
 AutoIt Version: 3.3.14.5
 Author: 			Caleb Alexander
 Script Function: 	Plugin for Varjis
					Displays a message box
#ce ----------------------------------------------------------------------------


#cs commands
reboot my computer
reboot my pc
restart my computer
restart my pc
restart desktop
reboot desktop
#ce commands

$oVoice = ObjCreate( "SAPI.SpVoice" )
$oVoice.Speak( "Rebooting your computer master caleb.  See you soon" )
Shutdown( 2 )