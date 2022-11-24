Cycle()
{
    static color_index := color_array.Length   ; start at the last color of the array

    Frame.BackColor := color_array[CheckColorIndexIsValid(color_index+1)]
    Sleep(speed*25)
    
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