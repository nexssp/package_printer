; Nexss PROGRAMMER 2.x - Auto Hot Key
; SETUP
EnvGet, NEXSS_PACKAGES_PATH, NEXSS_PACKAGES_PATH
#Include %A_AppData%/../../.nexss/packages/Nexss/Lib/NexssIn.ahk
#Include %A_AppData%/../../.nexss/packages/Nexss/Lib/NexssLog.ahk
; ======================================================

#Include ./src/Classprinters.ahk

NexssStdout.defaultPrinter := DefaultPrinter.Get()

; ======================================================
#Include %A_AppData%/../../.nexss/packages/Nexss/Lib/NexssOut.ahk