return {
  "nvim-treesitter/nvim-treesitter", 
  branch = 'master', 
  lazy = false, 
  build = ":TSUpdate",
  config = function() 
    require('nvim-treesitter.configs').setup {
      ensure_installed = { "c", "cpp", "python", "java", "lua", "javascript", "typescript", "html", "css", "json", "bash" },
      highlight = { enable = true },
      indent = { enable = true },
    }
  end
}
