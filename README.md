This is a simple plugin that allows you to quickly and painlessly duplicate files in Neovim.

## Video Demonstration
[Demo video for DupliFile plugin](./video-demo.mkv)

## Keybinding Options

| Action | Shortcuts | Description |
| ------ | --------- | ----------- |
| ``:DupliFile`` | ``<leader>df`` | Choose the file to duplicate, pick where to duplicate it, and then name the new file (Requires [Telescope](https://github.com/nvim-telescope/telescope.nvim) if you don't have it). |
| ``DupliFileActive`` | ``<leader>da`` | Pick where to duplicate the active file, and then rename the new file. |

The directory you want duplicate to will default to the one you are currently in. The file extension will be added to the end of the file by default as well (i.e., no need to add ".lua" to the end of the file name).
