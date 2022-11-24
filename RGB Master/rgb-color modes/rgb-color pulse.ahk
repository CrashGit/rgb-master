; you only need to change these variables, everything else should auto-calculate based on these values
pulse_in_increment    := 5                              ; amount to increase opacity per pulse_in_speed interval, a smaller number can result in a smoother fade
pulse_out_decrement   := 3                              ; amount to decrease opacity per pulse_out_speed interval, a smaller number can result in a smoother fade
pulse_in_to_pulse_out_transition_pause := -(speed*25)   ; when the color reaches full opacity, this is the delay before it increases transparency again
pulse_out_to_pulse_in_transition_pause := -(speed*7.5)  ; when the frame is no longer visible, this is the delay before it increases opacity again


ColorPulse()
{
    try transparency := WinGetTransparent(Frame) + pulse_in_increment
    
    try WinSetTransparent(transparency, Frame)
    catch {
        try WinSetTransparent(255, Frame)
    }

    try if transparency >= 255 {
        SetTimer(ColorPulse, 0)
        SetTimer(() => SetTimer(PulseOut, speed), pulse_in_to_pulse_out_transition_pause)  ; pause before breathing out
    }
}

PulseOut()
{
    try transparency := WinGetTransparent(Frame) - pulse_out_decrement

    try WinSetTransparent(transparency, Frame)
    catch {
        try WinSetTransparent(0, Frame)
    }

    try if transparency <= 0
    {
        SetTimer(PulseOut, 0)
        static colorIndex := color_array.Length   ; start at the last color of the array

        Frame.BackColor := color_array[CheckColorIndexIsValid(colorIndex+1)]

        CheckColorIndexIsValid(color)
        {
            if color > color_array.Length {  
                colorIndex := 1
                color := colorIndex
            } 
            else {
                colorIndex++
            }
            global color_resume := color_array[color]
            return color
        }
        SetTimer(() => SetTimer(ColorPulse, speed), pulse_out_to_pulse_in_transition_pause) ; pause before breathing in
    }
}