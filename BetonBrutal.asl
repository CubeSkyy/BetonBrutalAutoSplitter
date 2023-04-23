state("BetonBrutal")
{
	int run_count : "mono-2.0-bdwgc.dll", 0x007290F8, 0x150, 0xDB8, 0x10, 0x90, 0x28, 0x28, 0x60;
	int height : "mono-2.0-bdwgc.dll", 0x00729078, 0x440, 0x230, 0x230, 0x350, 0xD48, 0x64;
	int menu_active : "mono-2.0-bdwgc.dll", 0x009F30C8, 0x300, 0x10, 0x28, 0x78, 0x198, 0x40, 0x24;
	int current_time : "mono-2.0-bdwgc.dll", 0x00753300, 0x210, 0x1C0, 0x58, 0x58, 0x1C8, 0x118, 0x7C;

}

init {
    // Read splits file and initialize internal split list
    vars.split_file_path =  Directory.GetCurrentDirectory().ToString() + "\\BetonBrutalSplits.cfg";
    List<int> integers = new List<int>();
    StreamReader reader = new StreamReader(vars.split_file_path);
    while (!reader.EndOfStream) {
        string line = reader.ReadLine();
        string[] tokens = line.Split(',');
        foreach (string token in tokens) {
            int integer = Convert.ToInt32(token.Trim());
            integers.Add(integer);
        }
    }
    vars.split_list = integers;
    vars.current_split = 0;
}



update {
    //print("[ASL DEBUG]" + vars.split_list[0]);
}

start {
    if ((old.menu_active == 1) && (current.menu_active == 0) && (current.current_time == 0) && (current.height == 0)) {
	    return true;
    }
}

split
{
    if ((old.height < Math.Abs(vars.split_list[vars.current_split])) && (current.height >= Math.Abs(vars.split_list[vars.current_split]))) {
        if (vars.split_list[vars.current_split] < 0) {
            vars.current_split += 1;
            return false;
        }else{
            vars.current_split += 1;
            return true;
        }

    }
}

reset {
    if(current.run_count > old.run_count) {
    	vars.current_split = 0;
	    return true;
    }
}