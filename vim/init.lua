require('burm.plugins')
require('burm.funcs')
require('burm.options')
require('burm.colorscheme')
require('burm.config')
require('burm.autocmd')
require('burm.keymaps')

function RELOAD_ALL()
    R('burm.funcs')
    R('burm.options')
    R('burm.plugins')
    R('burm.colorscheme')
    R('burm.config')
    R('burm.keymaps')
    R('burm.autocmd')
    print("reloaded all")
end

require('burm.keymaps').map("n", "<leader>R", RELOAD_ALL)

print("config loaded")
