//  This splitter uses a separate split file "BetonBrutalSplits.cfg" that needs to be inside LiveSplit folder.
//  For more informmation on how to use it read this: https://github.com/CubeSkyy/BetonBrutalAutoSplitter#defining-split-times
//
//  Beton Brutal Discord: 
//	Autosplitter created by CubeSky

state("BetonBrutal") {
	int run_count : "UnityPlayer.dll", 0x01C665F8, 0xD0, 0x8, 0xE0, 0x28, 0x110, 0x28, 0x60;
	int height : "UnityPlayer.dll", 0x01C18E48, 0x48, 0x828, 0x30, 0x28, 0x50, 0x88, 0x64;
	// 1 if a Menu is on screen, 0 if player in game. used for starting along with time and height
	int menu_active : "UnityPlayer.dll", 0x01C806D0, 0x10, 0xB8, 0x10, 0x10, 0x10, 0x0, 0x544;
	int current_time : "UnityPlayer.dll", 0x01C18E48, 0x48, 0x828, 0x30, 0x28, 0x50, 0x88, 0x7C;
	// New version uses floats as the InGame Timer. Keeping both for now
	float current_time_ms : "UnityPlayer.dll", 0x01C80640, 0xC40, 0x5F8, 0x30, 0x48, 0x28, 0x50, 0x7C;
	int did_run_end : "UnityPlayer.dll", 0x01C81F78, 0xA78, 0xD0, 0x8, 0xE0, 0x28, 0x118, 0x5C;
}

startup {
	// Dummy setting, just an info to the user.
    settings.Add("Loc", true, "Add your splits in LiveSplit\\BetonBrutalSplits.cfg file. Checking this does nothing"); 
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
    if ((old.menu_active == 1) && (current.menu_active == 0) && ((current.current_time == 0) || (current.current_time_ms < 1.0)) && (current.height == 0)) {
		vars.run_ended = false;
	    return true;
    }
}

split
{
	if (current.height >= 500 || (current.height >= 498 && current.did_run_end == 1)) {
		vars.current_split = 0;
		vars.run_ended = true;
		return true;
	}

    if ((old.height < Math.Abs(vars.split_list[vars.current_split])) && (current.height >= Math.Abs(vars.split_list[vars.current_split])) && vars.current_split <= vars.split_list.Count - 1) {
        if (vars.split_list[vars.current_split] < 0) {
            vars.current_split = vars.current_split + 1;
            return false;
        }else{
            vars.current_split = vars.current_split + 1;
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

onReset {
	vars.current_split = 0;
}
