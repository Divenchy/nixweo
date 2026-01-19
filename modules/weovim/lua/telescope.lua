local telescope = require("telescope")
local actions = require("telescope.actions")
telescope.setup({
  defaults = {
    mappings = {
      i = {
        ['<C-enter>'] = 'to_fuzzy_refine',
        ["<C-e>"] = actions.move_selection_previous, --move to prev result
        ["<C-n>"] = actions.move_selection_next, --move to next result
        ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist, --quit
      },
    },
    extensions = {
      [ 'ui-select' ] = {
        require('telescope.themes').get_dropdown(),
      },
    },
  },
})

telescope.load_extension("fzf");
telescope.load_extension("ui-select");
