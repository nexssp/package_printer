#NoEnv
#SingleInstance Force
#NoTrayIcon              ; <- remove trayicon so user dont notice this script in background

Class DefaultPrinter
{
    static init := DefaultPrinter.ClassInit()
    static quit := OnExit(ObjBindMethod(DefaultPrinter, "_Delete"))
    

    ClassInit()
    {
        if !(this.hWINSPOOL := DllCall("LoadLibrary", "str", "winspool.drv", "ptr"))
            return false
        return true
    }

    Set(printer)
    {
        if !(DllCall("winspool.drv\SetDefaultPrinter", "ptr", &printer))
            return false
        return true
    }

    Get()
    {
        size:=0 ; because of the warning
        if !(DllCall("winspool.drv\GetDefaultPrinter", "ptr", 0, "uint*", size)) {
            size := VarSetCapacity(buf, size << 1, 0)
            if !(DllCall("winspool.drv\GetDefaultPrinter", "str", buf, "uint*", size))
                return false
        }
        return buf
    }

    _Delete()
    {
        if !(DllCall("FreeLibrary", "ptr", this.hWINSPOOL))
            return false
        return true
    }

    ; LocalPrinters   := 0x00000002   ; https://msdn.microsoft.com/en-us/library/cc244669.aspx
    ; NetworkPrinters := 0x00000004   ; https://msdn.microsoft.com/en-us/library/cc244669.aspx

    
}