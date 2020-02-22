#cs ----------------------------------------------------------------------------
 AutoIt Version: 3.3.14.5
 Author: 			Caleb Alexander
 Script Function: 	Plugin for Varjis
					Displays a message box
#ce ----------------------------------------------------------------------------


#cs commands
how much hard drive space do I have left
how much drive space do I have left
how much hard disk space do I have left
how much disk space do I have left
how much space do I have left
give me drive data
#ce commands

$oVoice = ObjCreate( "SAPI.SpVoice" )
$oVoice.Speak( String( Round( DriveSpaceFree(@HomePath) / 1024, 0 ) ) & " gigabytes free out of " & String( Round( DriveSpaceTotal(@HomePath) / 1024, 0 ) ) & " gigabytes"  )
