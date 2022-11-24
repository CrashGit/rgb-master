ColorShift()
{
    static red       := 255
    static green     := 0
    static blue      := 0
    static index     := 1
    static increment := Round(speed / 20)

    ; random color box selected
    if IniRead('rgb.ini', 'var', 'random_box_selected') {
        if index = 1 {
            if green + increment <= 255 {
                green += increment
            } else {
                green := 255
                index++
            }
        }
                
        else if index = 2 {
            if red - increment >= 0 {
                red -= increment
            } else {
                red := 0
                index++
            }
        }
    
        else if index = 3 {
            if blue + increment <= 255 {
                blue += increment
            } else {
                blue := 255
                index++
            }
        }
           
        else if index = 4 {
            if green - increment >= 0 {
                green -= increment
            } else {
                green := 0
                index++
            }
        }
    
        else if index = 5 {
            if red + increment <= 255 {
                red += increment
            } else {
                red := 255
                index++
            }
        } 
    
        else if index = 6 {
            if blue - increment >= 0 {
                blue -= increment
            } else {
                blue := 0
                index := 1
            }
        }

        try Frame.BackColor := Dec_to_Hex_Color(red, green, blue)

        global color_resume := index
    }


    ; alternating color boxes selected
    else {  
        static box_number := 1
        static red_done   := true
        static blue_done  := true
        static green_done := true
        static red_alt    := 0
        static green_alt  := 0
        static blue_alt   := 0
        static red_diff   := unset
        static green_diff := unset
        static blue_diff  := unset

        if red_done and green_done and blue_done {
            red_done   := false
            green_done := false
            blue_done  := false

            if box_number = 1 {
                box_number := 2
                red_diff   := IniRead('rgb.ini', 'color_box_1', 'red')   - IniRead('rgb.ini', 'color_box_2', 'red')
                green_diff := IniRead('rgb.ini', 'color_box_1', 'green') - IniRead('rgb.ini', 'color_box_2', 'green')
                blue_diff  := IniRead('rgb.ini', 'color_box_1', 'blue')  - IniRead('rgb.ini', 'color_box_2', 'blue')
            }
            else {
                box_number := 1
                red_diff   := IniRead('rgb.ini', 'color_box_2', 'red')   - IniRead('rgb.ini', 'color_box_1', 'red')
                green_diff := IniRead('rgb.ini', 'color_box_2', 'green') - IniRead('rgb.ini', 'color_box_1', 'green')
                blue_diff  := IniRead('rgb.ini', 'color_box_2', 'blue')  - IniRead('rgb.ini', 'color_box_1', 'blue')
            }
        }

        try Frame.BackColor := Dec_to_Hex_Color(red_alt, green_alt, blue_alt)


        if red_diff >= 0 and !red_done {
            if red_alt - increment >= IniRead('rgb.ini', 'color_box_' box_number, 'red') {
                red_alt -= increment
            } else {
                red_alt := IniRead('rgb.ini', 'color_box_' box_number, 'red')
                red_done := true
            }
        }
        else if red_diff < 0 and !red_done {
            if red_alt + increment <= IniRead('rgb.ini', 'color_box_' box_number, 'red') {
                red_alt += increment
            } else {
                red_alt := IniRead('rgb.ini', 'color_box_' box_number, 'red')
                red_done := true
            }
        }

        if green_diff >= 0 and !green_done {
            if green_alt - increment >= IniRead('rgb.ini', 'color_box_' box_number, 'green') {
                green_alt -= increment
            } else {
                green_alt := IniRead('rgb.ini', 'color_box_' box_number, 'green')
                green_done := true
            }
        }
        else if green_diff < 0 and !green_done {
            if green_alt + increment <= IniRead('rgb.ini', 'color_box_' box_number, 'green') {
                green_alt += increment
            } else {
                green_alt := IniRead('rgb.ini', 'color_box_' box_number, 'green')
                green_done := true
            }
        }

        if blue_diff >= 0 and !blue_done {
            if blue_alt - increment >= IniRead('rgb.ini', 'color_box_' box_number, 'blue') {
                blue_alt -= increment
            } else {
                blue_alt := IniRead('rgb.ini', 'color_box_' box_number, 'blue')
                blue_done := true
            }
        }
        else if blue_diff and !blue_done {
            if blue_alt + increment <= IniRead('rgb.ini', 'color_box_' box_number, 'blue') {
                blue_alt += increment
            } else {
                blue_alt := IniRead('rgb.ini', 'color_box_' box_number, 'blue')
                blue_done := true
            }
        }
    }
}