--  AUTHOR: DoFF - https://github.com/daroczi/doff_scoreboard
-- 
-- /$$$$$$$          /$$$$$$$$/$$$$$$$$        /$$$$$$                                     /$$                                       /$$
-- | $$__  $$        | $$_____| $$_____/       /$$__  $$                                   | $$                                      | $$
-- | $$  \ $$ /$$$$$$| $$     | $$            | $$  \__/ /$$$$$$$ /$$$$$$  /$$$$$$  /$$$$$$| $$$$$$$  /$$$$$$  /$$$$$$  /$$$$$$  /$$$$$$$
-- | $$  | $$/$$__  $| $$$$$  | $$$$$         |  $$$$$$ /$$_____//$$__  $$/$$__  $$/$$__  $| $$__  $$/$$__  $$|____  $$/$$__  $$/$$__  $$
-- | $$  | $| $$  \ $| $$__/  | $$__/          \____  $| $$     | $$  \ $| $$  \__| $$$$$$$| $$  \ $| $$  \ $$ /$$$$$$| $$  \__| $$  | $$
-- | $$  | $| $$  | $| $$     | $$             /$$  \ $| $$     | $$  | $| $$     | $$_____| $$  | $| $$  | $$/$$__  $| $$     | $$  | $$
-- | $$$$$$$|  $$$$$$| $$     | $$            |  $$$$$$|  $$$$$$|  $$$$$$| $$     |  $$$$$$| $$$$$$$|  $$$$$$|  $$$$$$| $$     |  $$$$$$$
-- |_______/ \______/|__/     |__/             \______/ \_______/\______/|__/      \_______|_______/ \______/ \_______|__/      \_______/
--
--

Config                              = {}                            -- Initialize Config table

Config.systemLocal                  = "en"                          -- Set your language. List of languages: hu, en, de
Config.serverName                   = "Example Server Name"         -- Set your server name here
Config.keymap                       = "F10"                         -- Set the scoreboard action button with keymap easily
Config.pingRate                     = 15000                         -- Set ping/lvl transition time in ms (recommended 15000)

Config.backgroundColor              = "rgba(31, 31, 31, 0.7)"       -- Main background color. Formats: rgb, rgba, hex, hsl
Config.backgroundTopColor           = "rgba(31, 31, 31, 0.8)"       -- Top section (jobs, server name, etc.) background color. Formats: rgb, rgba, hex, hsl
Config.frameColor                   = "rgb(0, 64, 255)"             -- Border alias frame color. Formats: rgb, rgba, hex, hsl
Config.listElementBackgroundColor   = "rgba(12, 12, 12, 0.6)"       -- Player list elements background color. Formats: rgb, rgba, hex, hsl
Config.headingBackgroundColor       = "rgba(0, 64, 255, 0.6)"       -- Above the player list (heading --> id, name, lvl/ms) background color. Formats: rgb, rgba, hex, hsl
Config.globalRadius                 = "7px"                         -- Global radius size. Formats: px or percentage (%)

Config.shopRobbery                  = false                          -- You can turn on/off shop robbery status
Config.minimumShop                  = 1                             -- Minimum police officer number for turn shop robbery status on

Config.bankRobbery                  = true                          -- You can turn on/off bank robbery status
Config.minimumBank                  = 2                             -- Minimum police officer number for turn bank robbery status on

Config.jobList = {                                                  -- Set your job list for jobs status
    ["police"] = {                                                  -- Job name
        align = "left",                                             -- Align in scoreboard (left or right)
        emoji = "👮"                                                -- Job emoji
    },
    ["sheriff"] = {
        align = "right",
        emoji = "🤠"
    },
    ["ambulance"] = {
        align = "left",
        emoji = "🚑"
    },
    ["mechanic"] = {
        align = "right",
        emoji = "👨‍🔧"
    },
}