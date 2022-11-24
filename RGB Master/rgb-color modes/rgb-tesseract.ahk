Tesseract()
{
    static color_index := color_array.Length
    global growing := true
    global shrinking := true

    if tesseract_number = 1
    {
        try {


            Tesseract_Frame_Top.Move(0, 0, 0, frame_size)
            Tesseract_Frame_Bottom.Move(A_ScreenWidth, A_ScreenHeight-frame_size, 0, frame_size)
            Tesseract_Frame_Left.Move(0, frame_size, frame_size, 0)
            Tesseract_Frame_Right.Move(A_ScreenWidth-frame_size, A_ScreenHeight-frame_size, frame_size, 0)
            
    
            while growing
            {
                Tesseract_Frame_Top.GetPos(,, &top_size)
                Tesseract_Frame_Bottom.GetPos(&bottom_pos,, &bottom_size)
                Tesseract_Frame_Left.GetPos(,,, &left_size)
                Tesseract_Frame_Right.GetPos(, &right_pos,, &right_size)
    
                Tesseract_Frame_Top.Move(,, top_size + 4)
                Tesseract_Frame_Bottom.Move(bottom_pos - 2,, bottom_size + 2)
                Tesseract_Frame_Bottom.Move(bottom_pos - 4,, bottom_size + 4)
                Tesseract_Frame_Left.Move(,,, left_size + (Mod(left_size, 9) = 0 ? 4 : 2))
                Tesseract_Frame_Right.Move(, right_pos - (Mod(right_size, 9) = 0 ? 4 : 2),, right_size + (Mod(right_size, 9) = 0 ? 4 : 2))
    
                if right_pos <= 0 {
                    ChangeColor()
                    break
                }
            }
    

            Tesseract_Frame_Top.Move(0, 0, A_ScreenWidth-frame_size, frame_size)
            Tesseract_Frame_Bottom.Move(0, A_ScreenHeight-frame_size, A_ScreenWidth, frame_size)
            Tesseract_Frame_Left.Move(0, frame_size, frame_size, A_ScreenHeight-frame_size)
            Tesseract_Frame_Right.Move(A_ScreenWidth-frame_size, 0, frame_size, A_ScreenHeight-frame_size)

    
            while shrinking
            {
                Tesseract_Frame_Top.GetPos(,, &top_size)
                Tesseract_Frame_Bottom.GetPos(&bottom_pos,, &bottom_size)
                Tesseract_Frame_Left.GetPos(,,, &left_size)
                Tesseract_Frame_Right.GetPos(, &right_pos,, &right_size)
    
                Tesseract_Frame_Top.Move(,, top_size - 4)
                Tesseract_Frame_Bottom.Move(bottom_pos + 4,, bottom_size - 4)
                Tesseract_Frame_Left.Move(,,, left_size - (Mod(left_size, 9) = 0 ? 4 : 2))
                Tesseract_Frame_Right.Move(, right_pos + (Mod(right_size, 9) = 0 ? 4 : 2),, right_size - (Mod(right_size, 9) = 0 ? 4 : 2))
    
                if right_pos >= A_ScreenHeight {
                    ChangeColor()
                    break
                }
            }    
        }
    }



    else
    {
        try {
            Tesseract_Frame_Top.Move(0, 0, 0, frame_size)
            Tesseract_Frame_Bottom.Move(A_ScreenWidth, A_ScreenHeight-frame_size, 0, frame_size)
            Tesseract_Frame_Left.Move(0, A_ScreenHeight, frame_size, 0)
            Tesseract_Frame_Right.Move(A_ScreenWidth-frame_size, 0, frame_size, 0)
    
    
            while growing
            {
                Tesseract_Frame_Top.GetPos(,, &top_size)
                Tesseract_Frame_Bottom.GetPos(&bottom_pos,, &bottom_size)
                Tesseract_Frame_Left.GetPos(, &left_pos,, &left_size)
                Tesseract_Frame_Right.GetPos(,,, &right_size)
    
                Tesseract_Frame_Top.Move(,, top_size + 4)
                Tesseract_Frame_Bottom.Move(bottom_pos - 4,, bottom_size + 4)
                Tesseract_Frame_Left.Move(, left_pos - (Mod(left_size, 9) = 0 ? 4 : 2),, left_size + (Mod(left_size, 9) = 0 ? 4 : 2))
                Tesseract_Frame_Right.Move(,,, right_size + (Mod(right_size, 9) = 0 ? 4 : 2))
    
                if left_pos <= 0 {
                    ChangeColor()
                    break
                }
            }
    
            ; Tesseract_Frame_Top.Move(0, 0, A_ScreenWidth-frame_size, frame_size)
            ; Tesseract_Frame_Bottom.Move(0, A_ScreenHeight-frame_size, A_ScreenWidth, frame_size)
            ; Tesseract_Frame_Left.Move(0, frame_size, frame_size, A_ScreenHeight-frame_size)
            ; Tesseract_Frame_Right.Move(A_ScreenWidth-frame_size, 0, frame_size, A_ScreenHeight-frame_size)
    
            while shrinking
            {
                Tesseract_Frame_Top.GetPos(,, &top_size)
                Tesseract_Frame_Bottom.GetPos(&bottom_pos,, &bottom_size)
                Tesseract_Frame_Left.GetPos(, &left_pos,, &left_size)
                Tesseract_Frame_Right.GetPos(,,, &right_size)
    
                Tesseract_Frame_Top.Move(,, top_size - 4)
                Tesseract_Frame_Bottom.Move(bottom_pos + 4,, bottom_size - 4)
                Tesseract_Frame_Left.Move(, left_pos + (Mod(left_size, 9) = 0 ? 4 : 2),, left_size - (Mod(left_size, 9) = 0 ? 4 : 2))
                Tesseract_Frame_Right.Move(,,, right_size - (Mod(right_size, 9) = 0 ? 4 : 2))
    
                if left_pos >= A_ScreenHeight {
                    ChangeColor()
                    break
                }
            }
        }
    }



    ChangeColor()
    {
        if !random_box_selected
            return
        Tesseract_Frame_Top.BackColor := color_array[CheckColorIndexIsValid(color_index+1)]
        Tesseract_Frame_Bottom.BackColor := color_array[CheckColorIndexIsValid(color_index+1)]
        Tesseract_Frame_Right.BackColor := color_array[CheckColorIndexIsValid(color_index+1)]
        Tesseract_Frame_Left.BackColor := color_array[CheckColorIndexIsValid(color_index+1)]
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
        return color
    }
}