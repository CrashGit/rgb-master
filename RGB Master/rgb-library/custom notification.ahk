SetWinDelay(-1)

; colors
red       := 'cff0000'
orange    := 'cff7f00'
yellow    := 'cffff00'
green     := 'c00bc3f'
blue      := 'c0068ff'
indigo    := 'c7a00e5'
violet    := 'cd300c9'
backcolor := 'c131313'

~LButton::      ; hide notification if clicked, in case it gets in the way
{
    if IsSet(Notify) {
        MouseGetPos(,, &Hwnd,, 2)
        
        if Hwnd = Notify.Hwnd
            Notify.Hide()
    }
}

ShowNotification(title, message, beepTone := 0)
{
    DestroyNotificationIfSet()  ; prevents issues if notification is already up
    SoundBeep(beepTone)         ; play a tone

    global Notify := Gui('+AlwaysOnTop +ToolWindow -SysMenu -Caption -Border')
    Notify.BackColor := backcolor
    Notify.MarginY := 10

    Notify.SetFont('s17 bold', 'Segoe UI')
    Notify.AddText(red ' Center x20', '<')

    Notify.SetFont('s14')
    Notify.AddText(violet ' Center xp+60 yp+5 w160', title)
    Notify.AddText(yellow ' Center xp+190 yp', '/')

    Notify.SetFont('s17')
    Notify.AddText(blue ' Center xp+20 yp-3', '>')
   
    Notify.SetFont('s11')
    Notify.AddText(green ' x20 w288 Center', message)
    
    
    Notify.Show('y0 AutoSize NoActivate')

    Notify.GetPos(,, &width, &height)
    WinSetRegion('0-0 w' width ' h' height ' r15-15', Notify)

    
    Notify.GetPos(,,, &gui_height)   ; get height of gui
    Notify.Move(, 0 - gui_height)   ; move gui just out of view above the monitor

    WinSetTransparent(0, Notify)
    SetTimer(SlideAndFadeIn, 10)
}

SlideAndFadeIn()
{
    try {
        transparency := WinGetTransparent(Notify) + 5
        
        try WinSetTransparent(transparency, Notify)
        catch {
            WinSetTransparent(255, Notify)
        }

        Notify.GetPos(, &guiY)
        Notify.Move(, guiY + 2)
        Notify.GetPos(, &guiY)

        if guiY >= 20 {     ; pixels from the top
            SetTimer(SlideAndFadeIn, 0)
            SetTimer(() => SetTimer(SlideAndFadeOut, 10), -3000)   ; slide out after 3 seconds
        }
    }
}

SlideAndFadeOut()
{
    try {
        transparency := WinGetTransparent(Notify) - 5

        try WinSetTransparent(transparency, Notify)
        catch {
            WinSetTransparent(0, Notify)
        }

        Notify.GetPos(, &guiY,, &gui_height)
        Notify.Move(, guiY - 2)
        Notify.GetPos(, &guiY)

        if guiY <= (0 - gui_height) {   ; gui_height above the screen (off screen)
            SetTimer(SlideAndFadeOut, 0) 
            DestroyNotificationIfSet()
        }
    }
}


DestroyNotificationIfSet()
{
    if IsSet(Notify) {
        SetTimer(SlideAndFadeIn, 0)
        SetTimer(SlideAndFadeOut, 0)
        Notify.Destroy()
        global Notify := unset
    }
}