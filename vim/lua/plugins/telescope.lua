return {
  {
    'nvim-telescope/telescope.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-tree/nvim-web-devicons',
      'nvim-telescope/telescope-live-grep-args.nvim'
    }
  },
  { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
}
