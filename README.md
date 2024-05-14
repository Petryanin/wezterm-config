<h2 align="center">Petryanin's WezTerm Config</h2>

---

### Features

- [**Background Image Selector**](https://github.com/KevinSilvester/wezterm-config/blob/master/utils/backdrops.lua)

  Uses `wezterm.read_dir` to scan the `backdrops` directory for images.

  > See: [key bindings](#background-images) for usage

- [**GPU Adapter Selector**](https://github.com/KevinSilvester/wezterm-config/blob/master/utils/gpu_adapter.lua)

  > :bulb: Only works if the [`front_end`](https://github.com/KevinSilvester/wezterm-config/blob/master/config/appearance.lua#L8) option is set to `WebGpu`.

  A small utility to select the best GPU + Adapter (graphics API) combo for your machine.

  GPU + Adapter combo is selected based on the following criteria:

  1. <details>
      <summary>Best GPU available</summary>

      `Discrete` > `Integrated` > `Other` (for `wgpu`'s OpenGl implementation on Discrete GPU) > `Cpu`
      </details>

  2. <details>
      <summary>Best graphics API available (based off my very scientific scroll a big log file in Neovim test 😁)</summary>

      > :bulb:<br>
      > The available graphics API choices change based on your OS.<br>
      > These options correspond to the APIs the `wgpu` crate (which powers WezTerm's gui in `WebGpu` mode)<br>
      > currenly has support implemented for.<br>
      > See: <https://github.com/gfx-rs/wgpu#supported-platforms> for more info

      - Windows: `Dx12` > `Vulkan` > `OpenGl`
      - Linux: `Vulkan` > `OpenGl`
      - Mac: `Metal`

      </details>

---

### All Key Binbdings

Most of the key bindings revolve around a <kbd>SUPER</kbd>, <kbd>SUPER_REV</kbd>(super reversed) and <kbd>SUPER_SHIFT</kbd> keys.<br>

- On MacOs:
  - <kbd>SUPER</kbd> ⇨ <kbd>Command</kbd>
  - <kbd>SUPER_REV</kbd> ⇨ <kbd>Command</kbd>+<kbd>Option</kbd>
  - <kbd>SUPER_SHIFT</kbd> ⇨ <kbd>Command</kbd>+<kbd>Shift</kbd>
- On Windows and Linux
  - <kbd>SUPER</kbd> ⇨ <kbd>Ctrl</kbd>
  - <kbd>SUPER_REV</kbd> ⇨ <kbd>Ctrl</kbd>+<kbd>Alt</kbd>
  - <kbd>SUPER_SHIFT</kbd> ⇨ <kbd>Ctrl</kbd>+<kbd>Shift</kbd>
- On all platforms:
  - <kbd>LEADER</kbd> ⇨ <kbd>SUPER_REV</kbd>+<kbd>Space</kbd>

#### Miscellaneous/Useful

| Keys                          | Action                                      |
| ----------------------------- | ------------------------------------------- |
| <kbd>F1</kbd>                 | `ActivateCopyMode`                          |
| <kbd>SUPER_SHIFT</kbd>+<kbd>t</kbd> | `ShowLauncher` <sub>(tabs launch menu items and domains)</sub>                   |
| <kbd>SUPER_SHIFT</kbd>+<kbd>f</kbd> | `ActivateCommandPalette`                    |
| <kbd>F3</kbd>                 | `ShowLauncher`                              |
| <kbd>F4</kbd>                 | `ShowLauncher` <sub>(tabs only)</sub>       |
| <kbd>F5</kbd>                 | `ShowLauncher` <sub>(workspaces only)</sub> |
| <kbd>F11</kbd>                | `ToggleFullScreen`                          |
| <kbd>F12</kbd>                | `ShowDebugOverlay`                          |
| <kbd>SUPER</kbd>+<kbd>f</kbd> | Search Text                                 |
| <kbd>SUPER</kbd>+<kbd>u</kbd> | Open URL                                    |
| <kbd>SUPER</kbd>+<kbd>Backspace</kbd> | Delete whole line                                    |
| <kbd>SUPER</kbd>+<kbd>←</kbd> | Move cursor to the beginning of the line                                    |
| <kbd>SUPER</kbd>+<kbd>→</kbd> | Move cursor to the end of the line|

&nbsp;

#### Copy+Paste

| Keys                          | Action               |
| ----------------------------- | -------------------- |
| <kbd>SUPER</kbd>+<kbd>c</kbd> | Copy to Clipborad    |
| <kbd>SUPER</kbd>+<kbd>v</kbd> | Paste from Clipborad |

&nbsp;

#### Tabs

##### Tabs: Spawn+Close

| Keys                              | Action                                |
| --------------------------------- | ------------------------------------- |
| <kbd>SUPER</kbd>+<kbd>t</kbd>     | `SpawnTab` <sub>(CurrentPaneDomain)</sub> |
| <kbd>SUPER_REV</kbd>+<kbd>t</kbd> | `SpawnTab` <sub>(DefaultDomain)</sub>    |
| <kbd>SUPER</kbd>+<kbd>w</kbd>     | `CloseCurrentTab`                     |

##### Tabs: Navigation

| Keys                                     | Action                        |
| ---------------------------------------- | ----------------------------- |
| <kbd>SUPER_REV</kbd>+<kbd>→</kbd>        | Next Tab                      |
| <kbd>SUPER_REV</kbd>+<kbd>←</kbd>        | Previous Tab                  |
| <kbd>SUPER_REV</kbd>+<kbd>[</kbd>        | Move Tab Left                 |
| <kbd>SUPER_REV</kbd>+<kbd>]</kbd>        | Move Tab Right                |
| <kbd>SUPER</kbd>+<kbd><number 1-9></kbd> | Switch to Tab with the number |

&nbsp;

#### Windows

| Keys                          | Action        |
| ----------------------------- | ------------- |
| <kbd>SUPER</kbd>+<kbd>n</kbd> | `SpawnWindow` |

&nbsp;

#### Panes

##### Panes: Split Panes

| Keys                               | Action                                           |
| ---------------------------------- | ------------------------------------------------ |
| <kbd>SUPER</kbd>+<kbd>\\</kbd>     | `SplitHorizontal` <sub>(CurrentPaneDomain)</sub> |
| <kbd>SUPER_REV</kbd>+<kbd>\\</kbd> | `SplitVertical` <sub>(CurrentPaneDomain)</sub>   |

##### Panes: Zoom+Close Pane

| Keys                              | Action                |
| --------------------------------- | --------------------- |
| <kbd>SUPER</kbd>+<kbd>Enter</kbd> | `TogglePaneZoomState` |
| <kbd>SUPER</kbd>+<kbd>w</kbd>     | `CloseCurrentPane`    |

##### Panes: Navigation

| Keys                              | Action                  |
| --------------------------------- | ----------------------- |
| <kbd>SUPER_REV</kbd>+<kbd>k</kbd> | Move to Pane (Up)       |
| <kbd>SUPER_REV</kbd>+<kbd>j</kbd> | Move to Pane (Down)     |
| <kbd>SUPER_REV</kbd>+<kbd>h</kbd> | Move to Pane (Left)     |
| <kbd>SUPER_REV</kbd>+<kbd>l</kbd> | Move to Pane (Right)    |
| <kbd>SUPER_REV</kbd>+<kbd>p</kbd> | Swap with selected Pane |

&nbsp;

#### Background Images

| Keys                              | Action                  |
| --------------------------------- | ----------------------- |
| <kbd>SUPER</kbd>+<kbd>/</kbd>     | Select Random Image     |
| <kbd>SUPER</kbd>+<kbd>,</kbd>     | Cycle to next Image     |
| <kbd>SUPER</kbd>+<kbd>.</kbd>     | Cycle to previous Image |
| <kbd>SUPER_REV</kbd>+<kbd>/</kbd> | Fuzzy select Image      |

&nbsp;

#### Key Tables

> See: <https://wezfurlong.org/wezterm/config/key-tables.html>

| Keys                           | Action        |
| ------------------------------ | ------------- |
| <kbd>LEADER</kbd>+<kbd>f</kbd> | `resize_font` |
| <kbd>LEADER</kbd>+<kbd>p</kbd> | `resize_pane` |

##### Key Table: `resize_font`

| Keys           | Action                          |
| -------------- | ------------------------------- |
| <kbd>k</kbd>   | `IncreaseFontSize`              |
| <kbd>j</kbd>   | `DecreaseFontSize`              |
| <kbd>r</kbd>   | `ResetFontSize`                 |
| <kbd>q</kbd>   | `PopKeyTable` <sub>(exit)</sub> |
| <kbd>Esc</kbd> | `PopKeyTable` <sub>(exit)</sub> |

##### Key Table: `resize_pane`

| Keys           | Action                                         |
| -------------- | ---------------------------------------------- |
| <kbd>k</kbd>   | `AdjustPaneSize` <sub>(Direction: Up)</sub>    |
| <kbd>j</kbd>   | `AdjustPaneSize` <sub>(Direction: Down)</sub>  |
| <kbd>h</kbd>   | `AdjustPaneSize` <sub>(Direction: Left)</sub>  |
| <kbd>l</kbd>   | `AdjustPaneSize` <sub>(Direction: Right)</sub> |
| <kbd>q</kbd>   | `PopKeyTable` <sub>(exit)</sub>                |
| <kbd>Esc</kbd> | `PopKeyTable` <sub>(exit)</sub>                |
