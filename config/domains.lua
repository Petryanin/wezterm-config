local wezterm = require('wezterm')

local ssh_domains = {}
for _, domain in ipairs(wezterm.default_ssh_domains()) do
    if string.sub(domain.name, 1, 4) == "SSH:" then
        table.insert(ssh_domains, domain)
    end
end

return {
   -- ref: https://wezfurlong.org/wezterm/config/lua/SshDomain.html
   ssh_domains = ssh_domains,

   -- ref: https://wezfurlong.org/wezterm/multiplexing.html#unix-domains
   unix_domains = {},

   -- ref: https://wezfurlong.org/wezterm/config/lua/WslDomain.html
   wsl_domains = wezterm.default_wsl_domains()
}
