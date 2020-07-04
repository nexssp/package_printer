;~ Nexss PROGRAMMER 2.0.0 - AutoIt 3
;~ Default template for JSON Data
#include <MsgBoxConstants.au3>
#include <Array.au3>
#include "3rdPartyLibraries/JSON/json.au3"
;~ STDIN
Local $NexssStdin
While True
    $NexssStdin &= ConsoleRead()
    If @error Then ExitLoop
    Sleep(25)
WEnd

$parsedJson = json_decode($NexssStdin)
Json_ObjPut($parsedJson, "test", "test")
;~ $start = Json_ObjGet($object,"start") OR Json_Get($json, '["upload"]["links"]["original"]')

$wbemFlagReturnImmediately = "&h10"
$wbemFlagForwardOnly = "&h20"

$WMI = ObjGet("winmgmts:\\" & @ComputerName & "\root\CIMV2")
$aItems = $WMI.ExecQuery("SELECT * FROM Win32_Printer", "WQL", $wbemFlagReturnImmediately + $wbemFlagForwardOnly)


$ObjList = ObjCreate("System.Collections.ArrayList") ; create
For $printer in $aItems
;~  MsgBox(0, "Printers", $printer.Name)
    $ObjList.Add($printer.Name)
Next

Json_ObjPut($parsedJson, "nxsOut", $ObjList.ToArray )

$NexssStdout = Json_Encode($parsedJson, $JSON_UNESCAPED_UNICODE)
ConsoleWrite($NexssStdout)