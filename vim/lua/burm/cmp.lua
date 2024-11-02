local M = {}

local function do_setup()
  local cmp = require 'cmp'
  cmp.setup({
    mapping = cmp.mapping.preset.insert {
      ['<C-n>'] = cmp.mapping.select_next_item(),
      ['<C-p>'] = cmp.mapping.select_prev_item(),
      ['<C-d>'] = cmp.mapping.scroll_docs( -4),
      ['<C-u>'] = cmp.mapping.scroll_docs(4),
      ['<tab>'] = cmp.config.disable,
      ['<C-y>'] = cmp.mapping.confirm {
        behavior = cmp.ConfirmBehavior.Insert,
        select = true
      },
      ['<C-q>'] = cmp.mapping.confirm {
        behavior = cmp.ConfirmBehavior.Replace,
        select = true,
      },
      ['<C-Space>'] = cmp.mapping.complete,
    },
    snippet = {
      expand = function(args)
        luasnip.lsp_expand(args.body)
      end
    },
    formatting = {
      format = lspkind.cmp_format({
        with_text = true,
        maxwidth = 50,
        mode = "symbol_text",
        menu = {
          nvim_lsp = "[LSP]",
          cody = "[cody]",
          path = "[path]",
          luasnip = "[snip]",
          buffer = "[buf]",
        }
      })
    },
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
      { name = 'cody',    priority = -50 },
      { name = 'luasnip' },
      { name = 'path' },
      { name = 'buffer' },
    }, {
      { name = 'buffer' },
    })
  })

  -- `/` cmdline setup.
  cmp.setup.cmdline('/', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
      { name = 'buffer' }
    }
  })

  -- `:` cmdline setup.
  cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
      { name = 'path' }
    }, {
      { name = 'cmdline' }
    })
  })
end

M.setup = function()
  if true then
    return nil
  else
    do_setup()
  end
end

return M

