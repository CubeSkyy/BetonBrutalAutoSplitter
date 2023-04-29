# BetonBrutalAutoSplitter

![Split_example](https://user-images.githubusercontent.com/16226383/233757140-5b62897a-1534-4544-b99a-ea4e9d9e77dc.gif)

This is an Auto Splitter for [Beton Brutal](https://store.steampowered.com/app/2330500/BETON_BRUTAL/). It is a [LiveSplit](https://livesplit.org/downloads/) plugin that reads the in-game memory to determine when to split/reset.

## Setup

1. Download [LiveSplit](https://livesplit.org/downloads/) and extract it somewhere (Ex:`C:\Program Files (x86)`)
2. Open LiveSplit.exe and right-click the timer that just opened, press `Edit Splits` and fill them with the splits you want. __The game name must match "BETON BRUTAL"__ Optionally, you can use the ones in this repository.

![image](https://user-images.githubusercontent.com/16226383/235325588-28abea04-c3bd-449a-b6f1-8e2415a72b7e.png)

3. Press `Activate` next to `Auto splits and resets based on in-game height`

![image](https://user-images.githubusercontent.com/16226383/235325693-f7292c01-7bc4-4a5f-8859-291771a5609f.png)


4. Create a file inside LiveSplit folder named `BetonBrutalSplits.cfg`

    The file is a list of heights separated by commas (Ex: `39, 102, 144`). After the run starts, when the player reaches the first height it will split and start looking for the next height. The last check (500M) is not required in the list.

    For the splitter to work, the number of splits in your LiveSplit file needs to match the splits inside the `BetonBrutalSplits.cfg` file.

    You can also define negative heights, these will be treated as requirements but it will not split the timer. This is useful when you want to reach a certain height, descend and then split after ascending again. 

    For example, if your splits file is `10, -30, 20`, then it will split at 10M, but it won't split at 20M, instead you will need to reach 30M first then descend to a height below 20M and finally after reaching 20M again it will split.
    
5. The autosplitter should now work. Just open the game and start playing.
