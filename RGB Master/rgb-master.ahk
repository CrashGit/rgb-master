#SingleInstance

#Include rgb-library\rgb library.ahk
#Include rgb-library\frames.ahk
#Include rgb-color modes\rgb-cycle.ahk
#Include rgb-color modes\rgb-color pulse.ahk
#Include rgb-color modes\rgb-color shift.ahk
#Include rgb-color modes\rgb-rainbow.ahk
#Include rgb-color modes\rgb-marquee.ahk
#Include rgb-color modes\rgb-static duo.ahk
#Include rgb-color modes\rgb-tesseract.ahk
#Include rgb-color modes\rgb-tentacles.ahk


TraySetIcon('Shell32.dll', 162)


F1::    ; toggle menu
{
    if IsSet(Master) {
        Master_Destroy()
    }
    else {
        RGB_Master_Gui()
    }
}


F2::    ; toggle on/off when it may be distracting like watching full-screen videos
{
    if frame_started {
        if frame_is_toggled  {
            Destroy_Frame()
            global frame_is_toggled := false
        }
        else {
            CreateFrame()
            global frame_is_toggled := true
        }
    }
}



RGB_Master_Gui()    ; INITIALIZE GUI
{
    global Master := Gui('+AlwaysOnTop -SysMenu +ToolWindow -Caption -Border')
    
    Master.BackColor := '1f1f1f'
    Master.MarginX := 16
    Master.MarginY := 16
    Master.SetFont('s12 bold c1f1f1f')

    Master.AddText('w482 h30 vtitle_background')
    Master.AddText('xm+5 yp+7 w2 h16 Left vtitle_border')

    Master.AddText('xp+5 yp-2 h20 vtitle1', 'R')
    Master.AddText('x+0  yp   h20 vtitle2', 'G')
    Master.AddText('x+0  yp   h20 vtitle3', 'B ')
    Master.AddText('x+0  yp   h20 vtitle4', 'M')
    Master.AddText('x+0  yp   h20 vtitle5', 'A')
    Master.AddText('x+0  yp   h20 vtitle6', 'S')
    Master.AddText('x+0  yp   h20 vtitle7', 'T')
    Master.AddText('x+0  yp   h20 vtitle8', 'E')
    Master.AddText('x+0  yp   h20 vtitle9', 'R')

    Master.SetFont('s10 c6b6b6b')
    Master.AddText('xm+412 yp+2 h20 vsave1', 'A').OnEvent('Click', Save_Options)
    Master.AddText('x+0    yp   h20 vsave2', 'P').OnEvent('Click', Save_Options)
    Master.AddText('x+0    yp   h20 vsave3', 'P').OnEvent('Click', Save_Options)
    Master.AddText('x+0    yp   h20 vsave4', 'L').OnEvent('Click', Save_Options)
    Master.AddText('x+0    yp   h20 vsave5', 'Y').OnEvent('Click', Save_Options)


    Master.SetFont('s8 cffffff')
   


    ; CHOOSE RGB MODE
    global rgb_mode_list := Master.AddListBox('xm y+12 w150 h144 Background000000 0x100 -Multi Section',
    ['Color Pulse', ;1 
    'Color Shift',  ;2
    'Cycle',        ;3
    'Rainbow',      ;4
    'Marquee',      ;5
    'Marquee 2',    ;6
    'Duo-Tone',     ;7
    'Tesseract',    ;8
    'Tesseract 2',  ;9
    'Tentacles'])   ;10
    rgb_mode_list.OnEvent('Change', EvaluateRGBSelection)
   
    

    ; SPEED SLIDER & COLOR SELECTION
    Master.AddGroupBox('ys-6 w150 h150 Section')
    Master.AddProgress('xp+2 yp+8 w146 h140 Disabled')   ; workaround to change groupbox background color

    ; SPEED SLIDER
    Master.AddSlider('xs+2 ys+24 w146 NoTicks Center ToolTip Range10-100 AltSubmit vspeed_slider', 40)
    Master.AddText('xs+2 y+0 w146 Center', 'Speed')

    ; COLOR CHOICE BOXES
    Master.AddText('xs+20 y+24 w25 h25 Border vrandom_color').OnEvent('Click', SelectedRandomColorBox)
    Master.AddText('x+25  yp   w25 h25 Border valternating_1').OnEvent('Click', (*) => SelectedAlternatingColorBox('alternating_1'))
    Master.AddText('x+10  yp   w25 h25 Border valternating_2').OnEvent('Click', (*) => SelectedAlternatingColorBox('alternating_2'))

    ; COLOR CHOICE TEXT
    Master.AddText('xs+10 y+8', 'Random')
    Master.AddText('x+14 yp', 'Alternating')

    ; INDICATOR
    Master.AddText('xp+6 yp-55 w9 h20 vselection_indicator')



    ; RGB SLIDERS  
    Master.AddGroupBox('ys w150 h150 Section')
    Master.AddProgress('xp+2 yp+8 w146 h140 Disabled')   ; workaround to change groupbox background color

    Master.AddSlider('xs+8 ys+24 w134 h26 Center NoTicks Center ToolTip Range0-255 AltSubmit Disabled vslider_red', 128).OnEvent('Change', (*) => SetRGBColor('red'))
    Master.AddSlider('xs+8 y+16  w134 h26 Center NoTicks Center ToolTip Range0-255 AltSubmit Disabled vslider_green', 128).OnEvent('Change', (*) => SetRGBColor('green'))
    Master.AddSlider('xs+8 y+16  w134 h26 Center NoTicks Center ToolTip Range0-255 AltSubmit Disabled vslider_blue', 128).OnEvent('Change', (*) => SetRGBColor('blue'))



    ; sets background of previously defined controls to match the groupbox background color (progress control)
    For ctrl in Master      
        try ctrl.Opt('Background131313')    ; try because not all controls support Background keyword



    ; exceptions for the above loop
    Master['title_border'].Opt('Backgroundffffff')
    Master['selection_indicator'].Opt('Background027af3')
    

    Master.Show('AutoSize')


    Restore_Options()


    WinSetRegion('0-0 w514 h216 r15-15', Master)
    WinSetRegion('0-0 w134 h26  r15-15', Master['slider_red'])
    WinSetRegion('0-0 w134 h26  r15-15', Master['slider_green'])
    WinSetRegion('0-0 w134 h26  r15-15', Master['slider_blue'])
    WinSetRegion('0-0 w482 h30  r15-15', Master['title_background'])
}


;-------------------------------------------------------------------------------
; DESTROY RGB MASTER
;-------------------------------------------------------------------------------
Master_Destroy(*)
{
    global
    SetTimer(TitleRandomColors, 0)
    SetTimer(SaveButtonColors, 0)
    SetTimer(RandomColorBoxColorChange, 0)

    ToolTip(,,, 6)  ; settings saved tooltip

    if IsSet(Master) {
        Master.Destroy()
        Master := unset
    }

    color_box_1 := 
    {
        red:    IniRead('rgb.ini', 'color_box_1', 'red'),
        green:  IniRead('rgb.ini', 'color_box_1', 'green'),
        blue:   IniRead('rgb.ini', 'color_box_1', 'blue')
    }

    color_box_2 := 
    {
        red:    IniRead('rgb.ini', 'color_box_2', 'red'),
        green:  IniRead('rgb.ini', 'color_box_2', 'green'),
        blue:   IniRead('rgb.ini', 'color_box_2', 'blue')
    }
}


; -------------------------------------------------------------------------------------------------
; -------------------------------------------------------------------------------------------------
CreateFrame()   ; create an RGB frame border around the screen
{
    global
    switch frame_style, 'Off'
    {
        case 'single':
            SingleFrame()
        case 'duo':
            DuoToneFrame()
        case 'rainbow':
            RainbowFrame()
        case 'marquee':
            MarqueeFrame()
        case 'tesseract':
            TesseractFrame()
        case 'tentacle':
            TentacleFrame()
    }


    if rgb_mode = 'Rainbow_Mode'
        Rainbow_Mode()
    else
        SetTimer(%rgb_mode%, speed)   ; begin rgb color change
}
; -------------------------------------------------------------------------------------------------
; -------------------------------------------------------------------------------------------------
Destroy_Frame()
{
    global
    if IsSet(Frame) {
        SetTimer(Cycle, 0)
        SetTimer(ColorShift, 0)
        SetTimer(ColorPulse, 0)
        SetTimer(PulseOut, 0)
        SetTimer(() => SetTimer(ColorPulse, 0), 0)
        SetTimer(() => SetTimer(PulseOut, 0), 0)
        Frame.Destroy()
        Frame := unset
    }

    else if IsSet(Rainbow_Frame_Top) {  
        SetTimer(framebow_setup1, 0)
        SetTimer(framebow_setup2, 0)
        SetTimer(framebow_setup3, 0)
        SetTimer(framebow_setup4, 0)
 
        Rainbow_Frame_Top.Destroy()
        Rainbow_Frame_Bottom.Destroy()
        Rainbow_Frame_Left.Destroy()
        Rainbow_Frame_Right.Destroy()
        Rainbow_Frame_Top    := unset
        Rainbow_Frame_Bottom := unset
        Rainbow_Frame_Left   := unset
        Rainbow_Frame_Right  := unset
    }

    else if IsSet(Marquee_Frame_Top) {
        SetTimer(MarqueeColors, 0)

        Marquee_Frame_Top.Destroy()
        Marquee_Frame_Bottom.Destroy()
        Marquee_Frame_Left.Destroy()
        Marquee_Frame_Right.Destroy()
        Marquee_Frame_Top    := unset
        Marquee_Frame_Bottom := unset
        Marquee_Frame_Left   := unset
        Marquee_Frame_Right  := unset
    }

    else if IsSet(Duo_Frame_Outer) {
        SetTimer(DuoStatic, 0)

        Duo_Frame_Outer.Destroy()
        Duo_Frame_Inner.Destroy()
        Duo_Frame_Outer := unset
        Duo_Frame_Inner := unset
    }

    else if IsSet(Tesseract_Frame_Top) {
        SetTimer(Tesseract, 0)
        global growing := false
        global shrinking := false

        Tesseract_Frame_Top.Destroy()
        Tesseract_Frame_Bottom.Destroy()
        Tesseract_Frame_Left.Destroy()
        Tesseract_Frame_Right.Destroy()
        Tesseract_Frame_Top    := unset
        Tesseract_Frame_Bottom := unset
        Tesseract_Frame_Left   := unset
        Tesseract_Frame_Right  := unset
    }

    else if IsSet(Tentacle_Frame_Top) {
        SetTimer(Tentacles, 0)
        global growing := false
        global shrinking := false

        Tentacle_Frame_Top.Destroy()
        Tentacle_Frame_Bottom.Destroy()
        Tentacle_Frame_Left.Destroy()
        Tentacle_Frame_Right.Destroy()
        Tentacle_Frame_Top    := unset
        Tentacle_Frame_Bottom := unset
        Tentacle_Frame_Left   := unset
        Tentacle_Frame_Right  := unset
    }
}