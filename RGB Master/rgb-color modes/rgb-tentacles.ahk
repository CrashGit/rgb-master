Tentacles()
{
    static color_index := color_array.Length
    global growing := true
    global shrinking := true

    try {
        ; this and variables fix issue when re-applying that causes the sync to go out of whack, even though the f2 toggle worked 100% of the time
        Tentacle_Frame_Top.Move(A_ScreenWidth/2,, 0)
        Tentacle_Frame_Bottom.Move(A_ScreenWidth/2,, 0)
        Tentacle_Frame_Left.Move(, A_ScreenHeight/2,, 0)
        Tentacle_Frame_Right.Move(, A_ScreenHeight/2,, 0)


        while growing
        {
            Tentacle_Frame_Top.GetPos(&top_pos,, &top_size)
            Tentacle_Frame_Bottom.GetPos(&bottom_pos,, &bottom_size)
            Tentacle_Frame_Left.GetPos(, &left_pos,, &left_size)
            Tentacle_Frame_Right.GetPos(, &right_pos,, &right_size)

            Tentacle_Frame_Top.Move(top_pos-2,, top_size+4)
            Tentacle_Frame_Bottom.Move(bottom_pos-2,, bottom_size+4)
            Tentacle_Frame_Left.Move(, left_pos - (Mod(left_size, 9) = 0 ? 2 : 1),, left_size + (Mod(left_size, 9) = 0 ? 4 : 2))
            Tentacle_Frame_Right.Move(, right_pos - (Mod(right_size, 9) = 0 ? 2 : 1),, right_size + (Mod(right_size, 9) = 0 ? 4 : 2))
            
            if right_pos <= 0
                break
        }

        ChangeColor()

        while shrinking
        {
            Tentacle_Frame_Top.GetPos(&top_pos,, &top_size)
            Tentacle_Frame_Bottom.GetPos(&bottom_pos,, &bottom_size)
            Tentacle_Frame_Left.GetPos(, &left_pos,, &left_size)
            Tentacle_Frame_Right.GetPos(, &right_pos,, &right_size)

            Tentacle_Frame_Top.Move(top_pos+2,, top_size-4)
            Tentacle_Frame_Bottom.Move(bottom_pos+2,, bottom_size-4)
            Tentacle_Frame_Left.Move(, left_pos + (Mod(left_size, 9) = 0 ? 2 : 1),, left_size - (Mod(left_size, 9) = 0 ? 4 : 2))
            Tentacle_Frame_Right.Move(, right_pos + (Mod(right_size, 9) = 0 ? 2 : 1),, right_size - (Mod(right_size, 9) = 0 ? 4 : 2))
            
            if right_pos >= A_ScreenHeight/2
                break
        }

        ChangeColor()


        ChangeColor()
        {
            Tentacle_Frame_Top.BackColor    := color_array[CheckColorIndexIsValid(color_index+1)]
            Tentacle_Frame_Right.BackColor  := color_array[CheckColorIndexIsValid(color_index+1)]
            Tentacle_Frame_Bottom.BackColor := color_array[CheckColorIndexIsValid(color_index+1)]
            Tentacle_Frame_Left.BackColor   := color_array[CheckColorIndexIsValid(color_index+1)]
            color_index := random_box_selected ? color_index : CheckColorIndexIsValid(color_index+1)
        }


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