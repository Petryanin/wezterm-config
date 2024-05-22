local platform = require('utils.platform')()

local options = {
   default_prog = {},
   launch_menu = {},
}

if platform.is_win then
   options.default_prog = { 'wsl.exe', '~' }
   options.launch_menu = {
      { label = 'WSL:Ubuntu', args = { 'wsl.exe', '~' } },
      { label = 'PowerShell Desktop', args = { 'powershell' } },
      { label = 'Command Prompt', args = { 'cmd.exe' } },
      {
         label = 'Git Bash',
         args = {'C:\\Program Files\\Git\\bin\\bash.exe', '-i', '-l'},
      },
   }
elseif platform.is_mac then
   options.default_prog = { 'zsh', '-l'}
   options.launch_menu = {
      { label = 'Bash', args = { 'bash', '-l' } },
      { label = 'Zsh', args = { 'zsh', '-l' } },
   }
elseif platform.is_linux then
   options.default_prog = { 'bash', '-l' }
   options.launch_menu = {
      { label = 'Bash', args = { 'bash', '-l' } },
      { label = 'Zsh', args = { 'zsh', '-l' } },
   }
end

return options
