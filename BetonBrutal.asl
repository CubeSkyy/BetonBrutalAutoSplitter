state("BetonBrutal") {
		string60 version : "UnityPlayer.dll", 0x01C18E20, 0x468, 0x18, 0x0, 0x0, 0x10, 0x18, 0x380;
}

startup
{
	// Dummy setting, just an info to the user.
    settings.Add("Loc", true, "Add your splits in LiveSplit\\BetonBrutalSplits.cfg file. Checking this does nothing");

    Assembly.Load(File.ReadAllBytes("Components/asl-help")).CreateInstance("Unity");
    vars.Helper.GameName = "Beton Brutal";

    vars.Heights = new List<int>();

    vars.Helper.AlertGameTime();
}

onStart
{
	vars.CustomSplitIndex = 0;

    vars.Heights.Clear();

    using (var cfg = new StreamReader("BetonBrutalSplits.cfg"))
    {
        string line;
        while ((line = cfg.ReadLine()) != null)
        {
            foreach (var height in line.Split(',')){
                vars.Heights.Add(int.Parse(height.Trim()));
				}
        }
    }

    // If user did not include 500m in their split file, add it automatically.
	
    if (vars.Heights[vars.Heights.Count - 1] != 500)
        vars.Heights.Add(500);
	
	vars.PositiveHeightCount = vars.Heights.FindAll(new Predicate<int>(height => height > 0)).Count;
}

init
{
	vars.IsScoutVersion = current.version.Contains("Scout");

	vars.Helper.TryLoad = (Func<dynamic, bool>)(mono =>
    {
        var gui = mono["GameUI"];
        vars.Helper["Runs"] = mono.Make<int>(gui, "Instance", "stats", "numRuns");
        vars.Helper["Height"] = mono.Make<int>(gui, "Instance", "stats", "currentHeight");
		vars.Helper["Time"] = mono.Make<float>(gui, "Instance", "stats", "currentTime");
		
		if (vars.IsScoutVersion) 
			vars.Helper["ActiveScreen"] = mono.Make<IntPtr>(gui, "Instance", "activeScreen");
		else 
			vars.Helper["ActiveScreen"] = mono.Make<IntPtr>(gui, "Instance", "ActiveScreen");
			
        // 0:LogoScreen (When game starts), 1:MainScreen , 2:PlayingScreen
        vars.Screens = vars.Helper.ReadList<IntPtr>(gui.Static + gui["Instance"], gui["screens"]);
        return true;
    });
	
	vars.CustomSplitIndex = 0;
	current.IsPlaying = true;
}

update
{
	current.IsPlaying = current.ActiveScreen == vars.Screens[2];
}

start
{
    return !old.IsPlaying && current.IsPlaying && current.Time <= 0.05 && current.Height == 0;
}

split
{
    // Only care about splitting when height increased.
    if (old.Height >= current.Height)
        return false;

    // Only consider the configured POSITIVE heights if the current split index is within the range of the list.
	// Could result in issues if configured splits and the actual split file do not match in length.
	if (timer.CurrentSplitIndex > vars.PositiveHeightCount)
		return false;

	//Custom logic to allow negative heights to be used as required checkpoints but without spliting
	var heightCheck = vars.Heights[vars.CustomSplitIndex];
	var absHeightCheck = Math.Abs(heightCheck);
	if (old.Height < absHeightCheck && current.Height >= absHeightCheck || current.Height >= 500){
		vars.CustomSplitIndex++;
		return heightCheck > 0;
	}
}

reset
{
    // Reset when user restarts the run.
    return old.Runs < current.Runs;
}

gameTime
{	
	// Since scout version stored in-game time in seconds, we use LiveSplit timer instead if we are in a Scout Version
	if (!vars.IsScoutVersion)
		return TimeSpan.FromSeconds(current.Time);
}

isLoading
{
    return !vars.IsScoutVersion;
}
