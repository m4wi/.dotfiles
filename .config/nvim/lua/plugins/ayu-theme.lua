
return {
  {
    "Shatur/neovim-ayu",
    priority = 1000, -- para cargar el tema antes que otros plugins
    config = function()
      require("ayu").setup({
        mirage = dark, -- true para usar el modo mirage (oscuro suave), false para dark clásico
        overrides = {
            Normal = { bg = "#040404" },
            NormalNC = { bg = "#040404" },
            SignColumn = { bg = "#040404" },
            VertSplit = { bg = "#040404" },
            EndOfBuffer = { bg = "#040404" },
            LineNr = { bg = "#040404" },
        },
        term_colors = true,
      })

      -- Aplica el tema
      vim.cmd("colorscheme ayu")
    end,
  },
}
