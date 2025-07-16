return {
  {
    "nvim-neorg/neorg",
    lazy = false,
    version = "*",
    config = function()
      vim.api.nvim_create_user_command("Dp", function()
        local target_path = vim.fn.expand("~/code/notes/dump.norg")
        local target_bufnr = nil

        -- Find the buffer
        for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
          local name = vim.api.nvim_buf_get_name(bufnr)
          if name == target_path then
            target_bufnr = bufnr
            break
          end
        end


        -- Check if the window is open
        local win_found = nil
        if target_bufnr then
          for _, win in ipairs(vim.api.nvim_list_wins()) do
            if vim.api.nvim_win_get_buf(win) == target_bufnr then
              win_found = win
              break
            end
          end
        end

        if win_found then
          vim.api.nvim_set_current_win(win_found)
        else
          vim.cmd("vsplit " .. vim.fn.fnameescape(target_path))
        end

        -- Move the cursor to the last line
        vim.api.nvim_win_set_cursor(0, { vim.api.nvim_buf_line_count(0), 0 })
      end, {})
      vim.api.nvim_create_user_command("Nt", ":e ~/code/notes/tasks.norg", {})
      vim.api.nvim_create_user_command("Nj", "Neorg journal today", {})
      require("neorg").setup {
        load = {
          ["core.defaults"] = {},
          ["core.concealer"] = {},
          ["core.dirman"] = {
            config = {
              workspaces = {
                notes = "~/code/notes",
              },
              default_workspace = "notes",
            },
          },
        },
      }

      vim.wo.foldlevel = 99
      vim.wo.conceallevel = 2
    end,
  }
}
