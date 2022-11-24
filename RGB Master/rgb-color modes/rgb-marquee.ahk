MarqueeColors()
{
    static color_index := random_box_selected ? color_array.Length : 1
    static top_add_sub, bot_add_sub, local_marquee := 0

    try { 
        ;prevents taskbar from covering effects
        Marquee_Frame_Top.Opt('AlwaysOnTop')
        Marquee_Frame_Bottom.Opt('AlwaysOnTop')
        Marquee_Frame_Left.Opt('AlwaysOnTop')
        Marquee_Frame_Right.Opt('AlwaysOnTop')

        
        if local_marquee != IniRead('rgb.ini', 'var', 'marquee_number') {
            local_marquee := IniRead('rgb.ini', 'var', 'marquee_number')
            top_add_sub   := local_marquee = 1 ? -2 : 2
            bot_add_sub   := local_marquee = 1 ? 2 : -2
        }

        ; move to starting positions
        Marquee_Frame_Top.Move(local_marquee = 1 ? A_ScreenWidth : 0, 0, 40, frame_size)
        Marquee_Frame_Bottom.Move(local_marquee = 1 ? 0 : A_ScreenWidth, A_ScreenHeight-frame_size, 40, frame_size)
        Marquee_Frame_Left.Move(0, A_ScreenHeight, frame_size, 40)
        Marquee_Frame_Right.Move(A_ScreenWidth-frame_size, 0, frame_size, 40)
        

        while true
        {
            Marquee_Frame_Top.GetPos(&top_position)
            Marquee_Frame_Bottom.GetPos(&bottom_position)
            Marquee_Frame_Left.GetPos(, &left_position)
            Marquee_Frame_Right.GetPos(, &right_position)

            Marquee_Frame_Top.Move(top_position + top_add_sub)
            Marquee_Frame_Bottom.Move(bottom_position + bot_add_sub)
            Marquee_Frame_Left.Move(, left_position - (Mod(left_position, 9) = 0 ? 2 : 1))
            Marquee_Frame_Right.Move(, right_position + (Mod(right_position, 9) = 0 ? 2 : 1))
            
            if right_position >= A_ScreenHeight
                break
        }

    

        Marquee_Frame_Top.BackColor    := color_array[CheckColorIndexIsValid(color_index+1)]
        Marquee_Frame_Right.BackColor  := color_array[CheckColorIndexIsValid(color_index+1)]
        Marquee_Frame_Bottom.BackColor := color_array[CheckColorIndexIsValid(color_index+1)]
        Marquee_Frame_Left.BackColor   := color_array[CheckColorIndexIsValid(color_index+1)]
        color_index := random_box_selected ? color_index : CheckColorIndexIsValid(color_index+1)


        CheckColorIndexIsValid(color)
        {
            if color > color_array.Length {  
                color_index := 1
                color := color_index
            } 
            else {
                color_index++
            }
            global color_resume := color_array[color]
            return color
        }
    }
}