return {
  "danymat/neogen",
  dependencies = "nvim-treesitter/nvim-treesitter",
  config = function()
    require("neogen").setup {
      enabled = true,
      languages = {
        typescript = {
          annotation_convention = "tsdoc"
        }
      }
    }
  end,
}
