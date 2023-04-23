state("BetonBrutal")
{
	int run_count : "UnityPlayer.dll", 0x01C10720, 0x8, 0x10, 0x68, 0x0, 0xA0, 0x28, 0x60;
	int height : "UnityPlayer.dll", 0x01C18E48, 0x48, 0x828, 0x30, 0x28, 0x50, 0x88, 0x64;
	// 1 if a Menu is on screen, 0 if player in game. used for starting along with time and height
	int menu_active : "UnityPlayer.dll", 0x01C18E48, 0x48, 0x2B0, 0x20, 0x440, 0x18, 0x0, 0x1F0;
	int current_time : "UnityPlayer.dll", 0x01C18E48, 0x48, 0x828, 0x30, 0x28, 0x50, 0x88, 0x7C;
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
	vars.run_ended = false;
}

start {
    if ((old.menu_active == 1) && (current.menu_active == 0) && (current.current_time == 0) && (current.height == 0)) {
		vars.run_ended = false;
	    return true;
    }
}

split
{
	if ((current.height >= 500)) {
		vars.current_split = 0;
		vars.run_ended = true;
		return true;
	}

    if ((old.height < Math.Abs(vars.split_list[vars.current_split])) && (current.height >= Math.Abs(vars.split_list[vars.current_split]))) {
        if (vars.split_list[vars.current_split] < 0) {
            vars.current_split = Math.Min(vars.current_split + 1, vars.split_list.Count - 1);
            return false;
        }else{
            vars.current_split = Math.Min(vars.current_split + 1, vars.split_list.Count - 1);
            return true;
        }
    }
}

reset {
    if(((old.menu_active == 0) && (current.menu_active == 1) && (vars.run_ended)) || (current.run_count > old.run_count)) {
    	vars.current_split = 0;
	    return true;
    }
}

exit {
	// With the current start logic, timer starts when game is closed. This manually resets at game close.
	timer.CurrentPhase = TimerPhase.NotRunning;
}

