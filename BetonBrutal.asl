state("BetonBrutal") {}

startup
{
    Assembly.Load(File.ReadAllBytes("Components/asl-help")).CreateInstance("Unity");
    vars.Helper.GameName = "Beton Brutal";

    vars.Heights = new List<int>();

    vars.Helper.AlertGameTime();
}

onStart
{
    vars.Heights.Clear();

    using (var cfg = new StreamReader("BetonBrutalSplits.cfg"))
    {
        string line;
        while ((line = cfg.ReadLine()) != null)
        {
            foreach (var height in line.Split(','))
                vars.Heights.Add(Math.Abs(int.Parse(height)));
        }
    }

    // If user did not include 500m in their split file, add it automatically.
    if (vars.Heights.LastOrDefault() != 500)
        vars.Heights.Add(500);
}

init
{
    vars.Helper.TryLoad = (Func<dynamic, bool>)(mono =>
    {
        var gmm = mono["GameModeManager"];

        vars.Helper["Runs"] = mono.Make<int>(gmm, "Instance", "stats", "numRuns");
        vars.Helper["Height"] = mono.Make<int>(gmm, "Instance", "stats", "currentHeight");
        vars.Helper["Time"] = mono.Make<float>(gmm, "Instance", "stats", "currentTime");
        vars.Helper["ActiveGameMode"] = mono.Make<IntPtr>(gmm, "Instance", "ActiveGameMode");

        // 0: MenuGameMode, 1: MainGameMode, 2: PracticeGameMode, 3: CustomMapGameMode, 4: MapEditorGameMode
        vars.GameModes = vars.Helper.ReadList<IntPtr>(gmm.Static + gmm["Instance"], gmm["gameModes"]);

        return true;
    });
}

update
{
    current.IsOnMenu = current.ActiveGameMode == vars.GameModes[0];
}

start
{
    return old.IsOnMenu && !current.IsOnMenu
        && current.Time <= 0.05 && current.Height == 0;
}

split
{
    // Only care about splitting when height increased.
    if (old.Height >= current.Height)
        return false;

    // Only consider the configured heights if the current split index is within the range of the list.
    // Otherwise, only split once reaching 500m.
    // Could result in issues if configured splits and the actual split file do not match in length.
    var i = timer.CurrentSplitIndex;
    return i < vars.Heights.Count && old.Height < vars.Heights[i] && current.Height >= vars.Heights[i]
        || current.Height >= 500;
}

reset
{
    // Reset when user restarts the run.
    // Could also add a reset after the run was completed, but that does not make sense;
    // auto splitters cannot reset the timer when timer.CurrentPhase == TimerPhase.Completed.
    return old.Runs < current.Runs;
}

gameTime
{
    return TimeSpan.FromSeconds(current.Time);
}

isLoading
{
    return true;
}
