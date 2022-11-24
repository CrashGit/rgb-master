;-------------------------------------------------------------------------------
; VARIABLES AND INITIALIZATION
;-------------------------------------------------------------------------------
const_rgb   := ['ff0000', 'ff7f00', 'ffff00', '00bc3f', '0068ff', '7a00e5', 'd300c9'] ; don't change
color_array := ['ff0000', 'ff7f00', 'ffff00', '00bc3f', '0068ff', '7a00e5', 'd300c9'] ; make sure this matches const_rgb

frame_size            := 4                                                 ; this is the size of the frame you want around the screen
frame_is_toggled      := false                                             ; tracks state of toggled frame visibility
frame_started         := false                                             ; prevents F2 from triggering before gui is first started
box_selected          := unset                                             ; keeps track of what alternating box is selected

rgb_mode              := IniRead('rgb.ini', 'var', 'rgb_mode')             ; keep track of last rgb mode used
frame_style           := IniRead('rgb.ini', 'var', 'frame_style')          ; keep track of last frame used
speed                 := 110 - IniRead('rgb.ini', 'var', 'speed')          ; used for color-changing timing
marquee_number        := IniRead('rgb.ini', 'var', 'marquee_number')       ; used to change marquee function depending on what marquee option was chosen
tesseract_number      := IniRead('rgb.ini', 'var', 'tesseract_number')     ; used to change tesseract function depending on what tesseract option was chosen
random_box_selected   := IniRead('rgb.ini', 'var', 'random_box_selected')  ; keep track of what box is selected
color_resume          := random_box_selected ? color_array[color_array.Length] : Dec_to_Hex_Color(IniRead('rgb.ini', 'color_box_2', 'red'), IniRead('rgb.ini', 'color_box_2', 'green'), IniRead('rgb.ini', 'color_box_2', 'blue')) ; remembers last color before toggling off

framebow_setup1       := (*) => FrameBow('Rainbow_Frame_Top', 128)
framebow_setup2       := (*) => FrameBow('Rainbow_Frame_Bottom', 128)
framebow_setup3       := (*) => FrameBow('Rainbow_Frame_Left', 72)
framebow_setup4       := (*) => FrameBow('Rainbow_Frame_Right', 72)


; SAVES RGB VALUES PER BOX
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



;-------------------------------------------------------------------------------
;-------------------------------------------------------------------------------
; FUNCTIONS
;-------------------------------------------------------------------------------
Save_Options(*)
{
    global
    static is_running := false  ; is_running is to prevent button from being spammed. sleep() wasn't working correctly
    
    if is_running
        return
    else
        is_running := true
 

    IniWrite(color_box_1.red,      'rgb.ini', 'color_box_1', 'red')
    IniWrite(color_box_1.green,    'rgb.ini', 'color_box_1', 'green')
    IniWrite(color_box_1.blue,     'rgb.ini', 'color_box_1', 'blue')
    IniWrite(color_box_2.red,      'rgb.ini', 'color_box_2', 'red')
    IniWrite(color_box_2.green,    'rgb.ini', 'color_box_2', 'green')
    IniWrite(color_box_2.blue,     'rgb.ini', 'color_box_2', 'blue')
    IniWrite(rgb_mode_list.value,  'rgb.ini', 'list', 'list_index')
    IniWrite(random_box_selected,  'rgb.ini', 'var', 'random_box_selected')
    IniWrite(marquee_number,       'rgb.ini', 'var', 'marquee_number')
    IniWrite(tesseract_number,     'rgb.ini', 'var', 'tesseract_number')
    IniWrite(rgb_mode,             'rgb.ini', 'var', 'rgb_mode')
    IniWrite(frame_style,          'rgb.ini', 'var', 'frame_style')
    IniWrite(Master['speed_slider'].Value, 'rgb.ini', 'var', 'speed')
    speed := 110 - IniRead('rgb.ini', 'var', 'speed')

    if random_box_selected
        color_array := const_rgb
    else {
        color_array := []
        color_array.Push(Dec_to_Hex_Color(color_box_1.red, color_box_1.green, color_box_1.blue))
        color_array.Push(Dec_to_Hex_Color(color_box_2.red, color_box_2.green, color_box_2.blue))
    }

    Settings_Saved_Notification()
    Destroy_Frame()
    CreateFrame()
    global frame_started := true
    global frame_is_toggled := true
    SetTimer(() => is_running := false, -1000)
}


Settings_Saved_Notification()
{
    Master.GetPos(&guiX, &guiY, &guiWidth)
    ttID := ToolTip('Settings saved', -5000, -5000, 6)
    SetTimer(() => ToolTip(,,, 6), -2000)
    WinGetPos(,,&tooltipWidth, &tooltipHeight, ttID)
    WinMove(guiX + (guiWidth - tooltipWidth) / 2, (guiY - tooltipHeight/2),,, ttID)
}


Restore_Options()
{
    global frame_style           := IniRead('rgb.ini', 'var', 'frame_style')
    global rgb_mode              := IniRead('rgb.ini', 'var', 'rgb_mode')
    global random_box_selected   := IniRead('rgb.ini', 'var', 'random_box_selected')
    rgb_mode_list.value          := IniRead('rgb.ini', 'list', 'list_index')
    Master['speed_slider'].Value := IniRead('rgb.ini', 'var', 'speed')

    ControlFocus Master['title_background'] ; start with no dotted lines on any controls
    EnableAll()
    SetStartingBoxes()                      ; set starting position
    
    SetTimer(TitleRandomColors, 80)
    SetTimer(SaveButtonColors, 100)
}


EvaluateRGBSelection(*)
{
    switch rgb_mode_list.value, 'Off'
    {
        case 1:
            Set_RGB_Mode('ColorPulse', 'single')
        case 2:
            Set_RGB_Mode('ColorShift', 'single')
        case 3:
            Set_RGB_Mode('Cycle', 'single')
        case 4:
            Set_Rainbow_Mode()
        case 5:
            Set_RGB_Mode('MarqueeColors', 'marquee')
            global marquee_number := 1
        case 6:
            Set_RGB_Mode('MarqueeColors', 'marquee')
            global marquee_number := 2
        case 7:
            Set_RGB_Mode('DuoStatic', 'duo')
        case 8:
            Set_RGB_Mode('Tesseract', 'tesseract')
            global tesseract_number := 1
        case 9:
            Set_RGB_Mode('Tesseract', 'tesseract')
            global tesseract_number := 2
        case 10:
            Set_RGB_Mode('Tentacles', 'tentacle')
    }
}


; CHOOSE RGB MODE
Set_RGB_Mode(mode, style_of_frame) 
{
    global rgb_mode    := mode
    global frame_style := style_of_frame
    EnableAll()
    SetStartingBoxes()
}


Set_Rainbow_Mode()  ; specific to rainbow mode
{
    global random_box_selected := true
    global rgb_mode := 'Rainbow_Mode'
    global frame_style := 'rainbow'
    DisableAll()
    DisableRGB_Sliders()
    MoveIndicator('random_color')
    SetTimer(RandomColorBoxColorChange, 500)
}


SetStartingBoxes()
{
    if rgb_mode = 'Rainbow_Mode'
        Set_Rainbow_Mode()
    else if random_box_selected
        SelectedRandomColorBox()
    else
        SelectedAlternatingColorBox('alternating_1')
}


; SELECT RANDOM COLOR BOX
SelectedRandomColorBox(*)
{
    global random_box_selected := true
    DisableRGB_Sliders()
    MoveIndicator('random_color')

    
    Master['alternating_1'].Opt('Redraw Background' Dec_to_Hex_Color(color_box_1.red, color_box_1.green, color_box_1.blue))
    Master['alternating_2'].Opt('Redraw Background' Dec_to_Hex_Color(color_box_2.red, color_box_2.green, color_box_2.blue))
    
    Master['random_color'].Opt('Redraw Background' color_resume)
    Master['random_color'].Enabled := false     ; prevents color cycling from starting over when clicking it again when already enabled
    SetTimer(RandomColorBoxColorChange, 500)
}


; SELECT ALTERNATING BOXES
SelectedAlternatingColorBox(selected_box)
{
    global random_box_selected := false
    EnableAll()
    MoveIndicator(selected_box)

    Master['random_color'].Opt('Redraw BackgroundDefault')
    Master['random_color'].Enabled := true
    SetTimer(RandomColorBoxColorChange, 0)
    
    RegExMatch(selected_box, '[0-9]', &box_selected_match)  ; find number in variable
    global box_selected := box_selected_match[]             ; store number in global box_selected
    
    Master['slider_red'].value   := color_box_%box_selected%.red
    Master['slider_green'].value := color_box_%box_selected%.green
    Master['slider_blue'].value  := color_box_%box_selected%.blue
    Master['alternating_1'].Opt('Redraw Background' Dec_to_Hex_Color(color_box_1.red, color_box_1.green, color_box_1.blue))
    Master['alternating_2'].Opt('Redraw Background' Dec_to_Hex_Color(color_box_2.red, color_box_2.green, color_box_2.blue))    
}


MoveIndicator(selected_box)
{
    Master[selected_box].GetPos(&ctrl_x_pos,, &ctrl_width)
    Master['selection_indicator'].GetPos(,, &indicator_width)
    Master['selection_indicator'].Move(ctrl_x_pos + (ctrl_width/2) - (indicator_width/2))

    WinSetRegion('0-15 4-20 9-15', Master['selection_indicator'])
}


EnableAll()
{
    EnableRGB_Sliders()
    Master['random_color'].Enabled  := true
    Master['alternating_1'].Enabled := true
    Master['alternating_2'].Enabled := true

    switch rgb_mode_list.value, 'Off'   ; disable speed slider for some effects that aren't affected by it
    {
        case 5, 6, 8, 9, 10:
            Master['speed_slider'].Enabled := false
        default:
            Master['speed_slider'].Enabled := true
    }
}


DisableAll()
{
    Master['speed_slider'].Enabled  := false
    Master['random_color'].Enabled  := false
    Master['alternating_1'].Enabled := false
    Master['alternating_2'].Enabled := false
    Master['alternating_1'].Opt('Redraw BackgroundDefault')
    Master['alternating_2'].Opt('Redraw BackgroundDefault')
}


EnableRGB_Sliders()
{
    Master['slider_red'].Enabled   := true
    Master['slider_green'].Enabled := true
    Master['slider_blue'].Enabled  := true

    Master['slider_red'].Opt('Backgroundff0000') 
    Master['slider_green'].Opt('Background00bc3f')
    Master['slider_blue'].Opt('Background5694f1')
}


DisableRGB_Sliders()
{
    Master['slider_red'].value   := 128
    Master['slider_green'].value := 128
    Master['slider_blue'].value  := 128

    Master['slider_red'].Enabled   := false
    Master['slider_green'].Enabled := false
    Master['slider_blue'].Enabled  := false

    Master['slider_red'].Opt('BackgroundDefault') 
    Master['slider_green'].Opt('BackgroundDefault')
    Master['slider_blue'].Opt('BackgroundDefault')
}


SetRGBColor(color)  ; changes color box to match slider colors
{
    color_box_%box_selected%.%color% := Master['slider_' color].Value
    Master['alternating_' box_selected].Opt('Redraw Background' Dec_to_Hex_Color(color_box_%box_selected%.red, color_box_%box_selected%.green, color_box_%box_selected%.blue))
}


;-------------------------------------------------------------------------------
; CONVERT RGB COLORS TO HEX
;-------------------------------------------------------------------------------
Dec_to_Hex_Color(R, G, B)
{
    VarSetStrCapacity(&hex, 17 << 1)
    DllCall('Shlwapi.dll\wnsprintf', 'str', hex, 'int', 17, 'str', '%016I64X', 'uint64', (R << 16) + (G << 8) + B, 'int')
    return SubStr(hex, StrLen(hex) - 6 + 1)
}


;-------------------------------------------------------------------------------
; GUI RGB EFFECTS
;-------------------------------------------------------------------------------
TitleRandomColors()
{
    static color_index := const_rgb.Length
    static index := 1, index2 := 9
    
    try {
        Master['title' index].SetFont('c' const_rgb[color_index])
        Master['title' (index2-1 <= 0 ? 9 : index2-1)].SetFont('c1f1f1f')
    }
   
    index++
    index2++
    color_index++

    if color_index > const_rgb.Length
        color_index := 1

    if index > 9
        index := 1
    else if index2 > 9
        index2 := 1
}


SaveButtonColors()
{
    static index := 1, index2 := 7
    
    try Master['save' index].SetFont('cffffff')
    try Master['save' (index2-1 <= 0 ? 4 : index2-1)].SetFont('c6b6b6b')    

    index++
    index2++

    if index > 7 {
        index := 1
        SetTimer(SaveButtonColors, 0)
        SetTimer(() => SetTimer(SaveButtonColors, 100), -1000)
    }
    else if index2 > 7 {
        index2 := 1
    }
}


RandomColorBoxColorChange()
{
    static color_index := const_rgb.Length   ; start at the last color of the array

    try Master['random_color'].Opt('Redraw Background' const_rgb[CheckColorIndexIsValid(color_index+1)])

    CheckColorIndexIsValid(color)
    {
        if color > const_rgb.Length {  
            color_index := 1
            color := color_index
        } 
        else {
            color_index++
        }
        return color
    }
}