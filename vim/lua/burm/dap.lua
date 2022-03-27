--- https://github.com/mfussenegger/nvim-dap/wiki/Debug-Adapter-installation

local keys = require('burm.keymaps')
local dap = require('dap')
require('dap-go').setup()
require('dapui').setup()

--- :h dap-mappings
keys.map('n', '<F5>', dap.continue)
keys.map('n', '<F6>', dap.step_over)
keys.map('n', '<F7>', dap.step_into)
keys.map('n', '<F8>', dap.step_out)
keys.map('n', '<leader>b', dap.toggle_breakpoint)
keys.map('n', '<leader>B', function() dap.set_breakpoint(vim.fn.input('Breakpoint condition: ')) end)
keys.map('n', '<leader>rpl', dap.repl.open)
keys.map('n', '<leader>rl', dap.run_last)
--- Go

