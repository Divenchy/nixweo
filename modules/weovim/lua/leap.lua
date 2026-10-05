-- Highly recommended: define a preview filter to reduce visual noise
-- and the blinking effect after the first keypress (see
-- `:h leap.opts.preview`).
-- For example, skip preview if the first character of the match is
-- whitespace or is in the middle of an alphabetic word:
local leap = require("leap")
leap.opts.preview = function(ch0, ch1, ch2)
  return not (ch1:match("%s") or (ch0:match("%a") and ch1:match("%a") and ch2:match("%a")))
end

-- Define equivalence classes for brackets and quotes, in addition to
-- the default whitespace group:
leap.opts.equivalence_classes = { " \t\r\n", "([{", ")]}", "'\"`" }

-- Use the traversal keys to repeat the previous motion without
-- explicitly invoking Leap:
require("leap.user").set_repeat_keys(";", ",")

-- Jump
vim.keymap.set({ "n", "x", "o" }, "s", "<Plug>(leap)", { desc = "Leap" })
vim.keymap.set("n", "S", "<Plug>(leap-from-window)", { desc = "Leap from window" })

-- Visit (jump - operate - jump back)
vim.keymap.set({ "n", "x", "o" }, "gs", "<Plug>(leap-visit)", { desc = "Leap visit" })
vim.keymap.set({ "x", "o" }, "ar", "<Plug>(leap-visit-text-object)")
vim.keymap.set({ "x", "o" }, "ir", "<Plug>(leap-visit-inner-text-object)")

-- Automatic paste on return
vim.api.nvim_create_autocmd("User", {
  pattern = "VisitDone",
  group = vim.api.nvim_create_augroup("Visit", {}),
  callback = function(event)
    if (event.data.mode:match("^[vV\22]") or vim.v.operator == "y") and event.data.register == '"' then
      vim.cmd("normal! p")
    end
  end,
})

-- Enhanced f/t (replacement for flit.nvim)
do
  local function ft(kwargs)
    require("leap").leap(vim.tbl_deep_extend("keep", kwargs, {
      inputlen = 1,
      inclusive = true,
      opts = {
        -- Always autojump to the first match (no labels in phase one).
        labels = "",
        -- Operator-pending mode: no labels at all.
        -- Normal/Visual: safe labels (default).
        safe_labels = vim.fn.mode(1):match("no?") and "" or nil,
      },
    }))
  end

  -- clever-f behavior: f/F and t/T repeat themselves.
  local clever = require("leap.user").with_traversal_keys
  local clever_f, clever_t = clever("f", "F"), clever("t", "T")

  vim.keymap.set({ "n", "x", "o" }, "f", function()
    ft({ opts = clever_f })
  end, { desc = "Leap f" })
  vim.keymap.set({ "n", "x", "o" }, "F", function()
    ft({ backward = true, opts = clever_f })
  end, { desc = "Leap F" })
  vim.keymap.set({ "n", "x", "o" }, "t", function()
    ft({ offset = -1, opts = clever_t })
  end, { desc = "Leap t" })
  vim.keymap.set({ "n", "x", "o" }, "T", function()
    ft({ backward = true, offset = 1, opts = clever_t })
  end, { desc = "Leap T" })
end
