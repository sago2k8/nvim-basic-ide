local M = {
  "neovim/nvim-lspconfig",
  commit = "649137cbc53a044bffde36294ce3160cb18f32c7",
  lazy = false,
  event = { "BufReadPre" },
  dependencies = {
    {
      "hrsh7th/cmp-nvim-lsp",
      commit = "0e6b2ed705ddcff9738ec4ea838141654f12eeef",
    },
  },
}

function M.config()
  local cmp_nvim_lsp = require "cmp_nvim_lsp"

  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities.textDocument.completion.completionItem.snippetSupport = true
  capabilities = cmp_nvim_lsp.default_capabilities(M.capabilities)

  local function lsp_keymaps(bufnr)
    local keymap = function(keys, func, desc)
      if desc then
        desc = 'LSP: ' .. desc
      end

     vim.api.nvim_buf_set_keymap(bufnr, "n", keys, func, { noremap = true, silent = true, desc = desc })
    end
    keymap("gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", "Goto Declaration")
    keymap("gd", "<cmd>lua vim.lsp.buf.definition()<CR>", "Goto definition")
    keymap("K", "<cmd>lua vim.lsp.buf.hover()<CR>", "Hover documentation")
    keymap("gI", "<cmd>lua vim.lsp.buf.implementation()<CR>", "Goto implementation")
    keymap("gr", "<cmd>lua vim.lsp.buf.references()<CR>", "Goto references")
    keymap("gl", "<cmd>lua vim.diagnostic.open_float()<CR>", "Hover diagnostics")
    keymap("<leader>li", "<cmd>LspInfo<cr>", "Hover info")
    keymap("<leader>lI", "<cmd>Mason<cr>", "Hover Mason info")
    keymap("<leader>la", "<cmd>lua vim.lsp.buf.code_action()<cr>", "Code actions")
    keymap("<leader>lj", "<cmd>lua vim.diagnostic.goto_next({buffer=0})<cr>", "Next diagnostic")
    keymap("<leader>lk", "<cmd>lua vim.diagnostic.goto_prev({buffer=0})<cr>", "Previous diagnostic")
    keymap("<leader>lr", "<cmd>lua vim.lsp.buf.rename()<cr>", "Rename")
    keymap("<leader>ls", "<cmd>lua vim.lsp.buf.signature_help()<CR>", "Signature")
    keymap("<leader>lq", "<cmd>lua vim.diagnostic.setloclist()<CR>", "hover list")
  end

  local lspconfig = require "lspconfig"
  local on_attach = function(client, bufnr)
    lsp_keymaps(bufnr)
    require("illuminate").on_attach(client)

    -- Create a command `:Format` local to the LSP buffer
    vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
      vim.lsp.buf.format()
    end, { desc = 'Format current buffer with LSP' })
  end

  for _, server in pairs(require("utils").servers) do
    Opts = {
      on_attach = on_attach,
      capabilities = capabilities,
    }

    server = vim.split(server, "@")[1]

    local require_ok, conf_opts = pcall(require, "settings." .. server)
    if require_ok then
      Opts = vim.tbl_deep_extend("force", conf_opts, Opts)
    end

    lspconfig[server].setup(Opts)
  end

  local signs = {
    { name = "DiagnosticSignError", text = "" },
    { name = "DiagnosticSignWarn", text = "" },
    { name = "DiagnosticSignHint", text = "" },
    { name = "DiagnosticSignInfo", text = "" },
  }

  for _, sign in ipairs(signs) do
    vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
  end

  local config = {
    -- disable virtual text
    virtual_text = false,
    -- show signs
    signs = {
      active = signs,
    },
    update_in_insert = true,
    underline = true,
    severity_sort = true,
    float = {
      focusable = false,
      style = "minimal",
      border = "rounded",
      source = "always",
      header = "",
      prefix = "",
      suffix = "",
    },
  }

  vim.diagnostic.config(config)

  vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
    border = "rounded",
  })

  vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
    border = "rounded",
  })
end

return M
