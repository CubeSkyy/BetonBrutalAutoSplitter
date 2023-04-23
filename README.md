# BetonBrutalAutoSplitter

![Split_example](https://user-images.githubusercontent.com/16226383/233757140-5b62897a-1534-4544-b99a-ea4e9d9e77dc.gif)

This is an Auto Splitter for [Beton Brutal](https://store.steampowered.com/app/2330500/BETON_BRUTAL/). It is a [LiveSplit](https://livesplit.org/downloads/) plugin that reads the in-game memory to determine when to split/reset.

## Setup

1. Download [LiveSplit](https://livesplit.org/downloads/) and extract it somewhere (Ex:`C:\Program Files (x86)`)
2. Download [the files in this repository](https://github.com/CubeSkyy/BetonBrutalAutoSplitter/releases) and extract them inside the LiveSplit installation folder (Ex:`C:\Program Files (x86)\LiveSplit`)
3. Open LiveSplit
4. Right-click the timer that just opened,, press `Open Splits` -> `From File...` and choose a category from the files you just downloaded (Ex: `BETON BRUTAL - any%.lss`)
![Step4](https://user-images.githubusercontent.com/16226383/233817875-173e54df-4e9b-46b9-aa73-a879a1b1793f.gif)
5. Right-click the timer and press `Open Layout` -> `From File...` and choose the layout you just downloaded (`Beton Brutal.lsl`). Otherwise, you can use your own, but you need to add the `Scriptable Auto Splitter` component under `Control` in the Layout Editor.
![Step5](https://user-images.githubusercontent.com/16226383/233818002-538e9d96-3c25-4a37-80f7-57557231d7a3.gif)
6. Right-click the timer and press `Edit Layout` -> `Layout Settings` and navigate to the `Scriptable Auto Splitter` tab. Click `Browse` and select the `BetonBrutalSplits.cfg` that __NEEDS__ to be under your LiveSplit folder. They should look like this:
![image](https://user-images.githubusercontent.com/16226383/233818092-961298b7-3240-4af8-af0b-c98b36eead8d.png)

## Defining Split times

The splitter will look at the `BetonBrutalSplits.cfg` file to determine when to split.

The file is a list of heights separated by commas (Ex: `39, 102, 144`). After the run starts, when the player reaches the first height it will split and start looking for the next height. The last check (500M) is not required in the list.

For the splitter to work, the number of splits in your LiveSplit file needs to match the splits inside the `BetonBrutalSplits.cfg` file.

You can also define negative heights, these will be treated as requirements but it will not split the timer. This is useful when you want to reach a certain height, descend and then split after ascending again. 
For example, if your splits file is `10, -30, 20`, then it will split at 10M, but it won't split at 20M, instead you will need to reach 30M first then descend to a height below 20M and finally after reaching 20M again it will split.
