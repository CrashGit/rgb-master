DuoStatic()
{
    Duo_Frame_Outer.Opt('AlwaysOnTop')
    Duo_Frame_Inner.Opt('AlwaysOnTop')
    if IniRead('rgb.ini', 'var', 'random_box_selected') {
        Duo_Frame_Outer.BackColor := color_array[Random(1, color_array.Length)]
        Duo_Frame_Inner.BackColor := color_array[Random(1, color_array.Length)]
    }

    Sleep(speed*10)
}