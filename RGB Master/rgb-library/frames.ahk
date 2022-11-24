SingleFrame()
{
    global Frame := Gui('+AlwaysOnTop -SysMenu +ToolWindow -Caption -Border +E0x20')
    Frame.BackColor := color_resume     ; starting color

    Frame.Show('x0 y0 w' A_ScreenWidth ' h' A_ScreenHeight  ' NoActivate')  
    WinSetTransparent(255, Frame)       ; initialize transparency

    height_offset := A_ScreenHeight - frame_size
    width_offset  := A_ScreenWidth  - frame_size
    WinSetRegion('0-0 ' A_ScreenWidth '-0 ' A_ScreenWidth '-' A_ScreenHeight ' 0-' A_ScreenHeight ' 0-0 ' frame_size '-' frame_size ' ' width_offset '-' frame_size ' ' width_offset '-' height_offset ' ' frame_size '-' height_offset ' ' frame_size '-' frame_size, Frame) ; creates the frame
}



DuoToneFrame()
{
    if random_box_selected {
        background   := color_array[Random(1,7)]
        accent       := color_array[Random(1,7)]
    }
    else {
        background   := Dec_to_Hex_Color(IniRead('rgb.ini', 'color_box_1', 'red'), IniRead('rgb.ini', 'color_box_1', 'green'), IniRead('rgb.ini', 'color_box_1', 'blue'))
        accent       := Dec_to_Hex_Color(IniRead('rgb.ini', 'color_box_2', 'red'), IniRead('rgb.ini', 'color_box_2', 'green'), IniRead('rgb.ini', 'color_box_2', 'blue'))
    }

    inner_frame    := frame_size / 2
    height_offset  := A_ScreenHeight - inner_frame
    width_offset   := A_ScreenWidth  - inner_frame

    global Duo_Frame_Outer := Gui('+AlwaysOnTop -SysMenu +ToolWindow -Caption -Border +E0x20')
    Duo_Frame_Outer.BackColor := background     ; starting color
    Duo_Frame_Outer.Show('x0 y0 w' A_ScreenWidth ' h' A_ScreenHeight  ' NoActivate')  

    WinSetRegion('0-0 ' A_ScreenWidth '-0 ' A_ScreenWidth '-' A_ScreenHeight ' 0-' A_ScreenHeight ' 0-0     ' inner_frame '-' inner_frame ' ' width_offset '-' inner_frame ' ' width_offset '-' height_offset ' ' inner_frame '-' height_offset ' ' inner_frame '-' inner_frame, Duo_Frame_Outer) ; creates the outer frame


    global Duo_Frame_Inner := Gui('+AlwaysOnTop -SysMenu +ToolWindow -Caption -Border +E0x20')
    Duo_Frame_Inner.BackColor := accent     ; starting color
    Duo_Frame_Inner.Show('x2 y2 w' A_ScreenWidth-frame_size ' h' A_ScreenHeight-frame_size ' NoActivate') 
    
    WinSetRegion('0-0 ' A_ScreenWidth-inner_frame '-0 ' A_ScreenWidth-inner_frame '-' A_ScreenHeight-inner_frame ' 0-' A_ScreenHeight-inner_frame ' 0-0 '    inner_frame '-' inner_frame ' ' width_offset-frame_size '-2 ' width_offset-frame_size '-' height_offset-frame_size ' ' inner_frame '-' height_offset-frame_size ' ' inner_frame '-' inner_frame, Duo_Frame_Inner) ; creates the inner frame

}



MarqueeFrame()
{
    if marquee_number = 1 {
        top_x    := A_ScreenWidth
        bottom_x := 0
    }
    else if marquee_number = 2 {
        top_x    := 0
        bottom_x := A_ScreenWidth
    }

    ; FRAME TOP
    global Marquee_Frame_Top  := Gui('+AlwaysOnTop -SysMenu +ToolWindow -Caption -Border +E0x20')
    Marquee_Frame_Top.BackColor := color_array[1]
    Marquee_Frame_Top.Show('NoActivate')


    ; FRAME BOTTOM
    global Marquee_Frame_Bottom  := Gui('+AlwaysOnTop -SysMenu +ToolWindow -Caption -Border +E0x20')
    Marquee_Frame_Bottom.BackColor := random_box_selected ? color_array[2] : color_array[1]
    Marquee_Frame_Bottom.Show('NoActivate')


    ; FRAME LEFT
    global Marquee_Frame_Left  := Gui('+AlwaysOnTop -SysMenu +ToolWindow -Caption -Border +E0x20')
    Marquee_Frame_Left.BackColor := random_box_selected ? color_array[3] : color_array[2]
    Marquee_Frame_Left.Show('NoActivate')


    ; FRAME RIGHT
    global Marquee_Frame_Right  := Gui('+AlwaysOnTop -SysMenu +ToolWindow -Caption -Border +E0x20')
    Marquee_Frame_Right.BackColor := random_box_selected ? color_array[4] : color_array[2]
    Marquee_Frame_Right.Show('NoActivate')
}


TesseractFrame()
{
    ; FRAME TOP
    global Tesseract_Frame_Top  := Gui('+AlwaysOnTop -SysMenu +ToolWindow -Caption -Border +E0x20')
    Tesseract_Frame_Top.BackColor := random_box_selected ? color_array[5] : color_array[1]
    Tesseract_Frame_Top.OnEvent('Size', (*) => Tesseract_Frame_Top.Opt('AlwaysOnTop'))
    Tesseract_Frame_Top.Show('NoActivate')


    ; FRAME BOTTOM
    global Tesseract_Frame_Bottom  := Gui('+AlwaysOnTop -SysMenu +ToolWindow -Caption -Border +E0x20')
    Tesseract_Frame_Bottom.BackColor := random_box_selected ? color_array[6] : color_array[1] 
    Tesseract_Frame_Bottom.OnEvent('Size', (*) => Tesseract_Frame_Bottom.Opt('AlwaysOnTop'))
    Tesseract_Frame_Bottom.Show('NoActivate')


    ; FRAME LEFT
    global Tesseract_Frame_Left  := Gui('+AlwaysOnTop -SysMenu +ToolWindow -Caption -Border +E0x20')
    Tesseract_Frame_Left.BackColor := random_box_selected ? color_array[7] : color_array[2] 
    Tesseract_Frame_Left.OnEvent('Size', (*) => Tesseract_Frame_Left.Opt('AlwaysOnTop'))
    Tesseract_Frame_Left.Show('NoActivate')


    ; FRAME RIGHT
    global Tesseract_Frame_Right  := Gui('+AlwaysOnTop -SysMenu +ToolWindow -Caption -Border +E0x20')
    Tesseract_Frame_Right.BackColor := random_box_selected ? color_array[1] : color_array[2] 
    Tesseract_Frame_Right.OnEvent('Size', (*) => Tesseract_Frame_Right.Opt('AlwaysOnTop'))
    Tesseract_Frame_Right.Show('NoActivate')
}


TentacleFrame()
{
    ; FRAME TOP
    global Tentacle_Frame_Top  := Gui('+AlwaysOnTop -SysMenu +ToolWindow -Caption -Border +E0x20')
    Tentacle_Frame_Top.MarginX := 0
    Tentacle_Frame_Top.MarginY := 0

    Tentacle_Frame_Top.OnEvent('Size', (*) => Tentacle_Frame_Top.Opt('AlwaysOnTop'))
    Tentacle_Frame_Top.BackColor := random_box_selected ? color_array[5] : color_array[1]
    Tentacle_Frame_Top.Show('x' A_ScreenWidth/2 ' y0 w0 h' frame_size ' NoActivate')

    ; FRAME BOTTOM
    global Tentacle_Frame_Bottom  := Gui('+AlwaysOnTop -SysMenu +ToolWindow -Caption -Border +E0x20')
    Tentacle_Frame_Bottom.MarginX := 0
    Tentacle_Frame_Bottom.MarginY := 0

    Tentacle_Frame_Bottom.OnEvent('Size', (*) => Tentacle_Frame_Bottom.Opt('AlwaysOnTop'))
    Tentacle_Frame_Bottom.BackColor := random_box_selected ? color_array[6] : color_array[1] 
    Tentacle_Frame_Bottom.Show('x' A_ScreenWidth/2 ' y' A_ScreenHeight-frame_size ' w0 h' frame_size ' NoActivate')


    ; FRAME LEFT
    global Tentacle_Frame_Left  := Gui('+AlwaysOnTop -SysMenu +ToolWindow -Caption -Border +E0x20')
    Tentacle_Frame_Left.MarginX := 0
    Tentacle_Frame_Left.MarginY := 0

    Tentacle_Frame_Left.OnEvent('Size', (*) => Tentacle_Frame_Left.Opt('AlwaysOnTop'))
    Tentacle_Frame_Left.BackColor := random_box_selected ? color_array[7] : color_array[2] 
    Tentacle_Frame_Left.Show('x0 y' A_ScreenHeight/2 ' w' frame_size ' h0 NoActivate')


    ; FRAME RIGHT
    global Tentacle_Frame_Right  := Gui('+AlwaysOnTop -SysMenu +ToolWindow -Caption -Border +E0x20')
    Tentacle_Frame_Right.MarginX := 0
    Tentacle_Frame_Right.MarginY := 0

    Tentacle_Frame_Right.OnEvent('Size', (*) => Tentacle_Frame_Right.Opt('AlwaysOnTop'))
    Tentacle_Frame_Right.BackColor := random_box_selected ? color_array[1] : color_array[2] 
    Tentacle_Frame_Right.Show('x' A_ScreenWidth-frame_size ' y' A_ScreenHeight/2 ' w' frame_size ' h0 NoActivate')
}


RainbowFrame()
{
    ; FRAME TOP
    global Rainbow_Frame_Top  := Gui('+AlwaysOnTop -SysMenu +ToolWindow -Caption -Border +E0x20')
    Rainbow_Frame_Top.MarginX := 0
    Rainbow_Frame_Top.MarginY := 0

    loop 128
    {
        Rainbow_Frame_Top.AddText('yp w20 vframebow' A_Index)
    }
    Rainbow_Frame_Top.Show('x0 y0 w' A_ScreenWidth ' h' frame_size ' NoActivate')


    ; FRAME BOTTOM
    global Rainbow_Frame_Bottom  := Gui('+AlwaysOnTop -SysMenu +ToolWindow -Caption -Border +E0x20')
    Rainbow_Frame_Bottom.MarginX := 0
    Rainbow_Frame_Bottom.MarginY := 0

    loop 128
    {
        Rainbow_Frame_Bottom.AddText('yp w20 vframebow' A_Index)
    }
    Rainbow_Frame_Bottom.Show('x0 y' A_ScreenHeight-frame_size ' w' A_ScreenWidth ' h' frame_size ' NoActivate')


    ; FRAME LEFT
    global Rainbow_Frame_Left  := Gui('+AlwaysOnTop -SysMenu +ToolWindow -Caption -Border +E0x20')
    Rainbow_Frame_Left.MarginX := 0
    Rainbow_Frame_Left.MarginY := 0

    loop 72
    {
        Rainbow_Frame_Left.AddText('xp h20 vframebow' A_Index)
    }
    Rainbow_Frame_Left.Show('x0 y0 w' frame_size ' h' A_ScreenHeight ' NoActivate')


    ; FRAME RIGHT
    global Rainbow_Frame_Right  := Gui('+AlwaysOnTop -SysMenu +ToolWindow -Caption -Border +E0x20')
    Rainbow_Frame_Right.MarginX := 0
    Rainbow_Frame_Right.MarginY := 0

    loop 72
    {
        Rainbow_Frame_Right.AddText('xp h20 vframebow' A_Index)
    }
    Rainbow_Frame_Right.Show('x' A_ScreenWidth-frame_size ' y0 w' frame_size ' h' A_ScreenHeight ' NoActivate')
}