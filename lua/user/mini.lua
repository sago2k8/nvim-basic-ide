local M = {
  {
    'echasnovski/mini.align',
    version = false,
    event = "BufEnter",
    config = function()
      require("mini.align").setup({})
    end,
  },
  {
    'echasnovski/mini.jump',
    version = false,

    event = "BufEnter",
    config = function()
      require("mini.jump").setup({})
    end,
  },
  {
    'echasnovski/mini.surround',
    version = false,

    event = "BufEnter",
    config = function()
      require("mini.surround").setup({})
    end,
  },
  {
    'echasnovski/mini.move',
    version = false,

    event = "BufEnter",
    config = function()
      require("mini.move").setup({})
    end,
  },

  {
    'echasnovski/mini.bracketed',
    version = false,

    event = "BufEnter",
    config = function()
      require("mini.bracketed").setup({})
    end,
  },

  { 'echasnovski/mini.clue',
    version = false,
    event = "BufEnter",
    config = function()
      require("mini.clue").setup({})
    end,
  },

}


-- function M.config()
--   local align = require "mini.align"
--   local jump = require "mini.jump"
--   local surround = require "mini.surround"
--   align.setup()
--   jump.setup()
--   surround.setup()
-- end

return M
