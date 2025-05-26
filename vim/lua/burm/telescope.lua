local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local make_entry = require("telescope.make_entry")
local conf = require("telescope.config").values
local builtin = require("telescope.builtin")
local themes = require("telescope.themes")

local M = {}

function M.fuzzy_browser(_opts)
  builtin.current_buffer_fuzzy_find(themes.get_ivy {
    previewer = false,
    winblend = 10,
  })
end

function M.quick_file_browser(_opts)
  builtin.find_files(
    themes.get_ivy(
      {
        previewer = false, layout_config = { width = 0.65 }
      })
  )
end

function M.grep_with_glob(opts)
  opts = opts or {}
  opts.cwd = opts.cwd or vim.uv.cwd()

  local finder = finders.new_async_job {
    command_generator = function(prompt)
      if not prompt or prompt == "" then
        return nil
      end

      local parts = vim.split(prompt, "  ")
      local args = { "rg" }
      if parts[1] then
        table.insert(args, "-e")
        table.insert(args, parts[1])
      end
      -- add the text after "  " as an argument to -g, which is the glob
      if parts[2] then
        table.insert(args, "-g")
        table.insert(args, parts[2])
      end

      return vim.flatten(args,
        { "--color=never", "--no-heading", "--with-filename", "--line-number", "--column", "--smart-case" }
      )
    end,
    entry_maker = make_entry.gen_from_vimgrep(opts),
    cwd = opts.cwd,
  }

  pickers.new(opts, {
    debounce = 100,
    prompt_title = "Grep with glob",
    finder = finder,
    preview = conf.grep_previewer(opts),
    sorter = require("telescope.sorters").empty(), -- ripgrep already sorts
  }):find()
end

return M
