Rainbow_Mode()
{
    SetTimer(framebow_setup1, 200)
    SetTimer(framebow_setup2, 200)
    SetTimer(framebow_setup3, 200)
    SetTimer(framebow_setup4, 200)
}


FrameBow(gui, loop_count)
{
    static color_index := const_rgb.Length   ; start at the last color of the array
    %gui%.Opt('AlwaysOnTop')


    loop loop_count
    {
        try %gui%['framebow' A_Index].Opt('Redraw Background' const_rgb[CheckColorIndexIsValid(color_index+1)])
    }

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