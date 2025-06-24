local builtin = require 'telescope.builtin'
local entry_display = require 'telescope.pickers.entry_display'
local make_entry = require 'telescope.make_entry'

-- Entry maker for simple path lists (find_files, buffers, etc.)
local function filename_only_entry_maker()
  return function(entry)
    local filename = vim.fn.fnamemodify(entry, ':t')
    return {
      value = entry,
      display = filename,
      ordinal = filename,
      path = entry,
    }
  end
end

-- Entry maker for LSP locations (definitions, references, etc.)
local function lsp_filename_entry_maker()
  local displayer = entry_display.create {
    separator = ' ',
    items = {
      { width = 20 },
      { remaining = true },
    },
  }

  return function(entry)
    local filename = vim.fn.fnamemodify(entry.filename, ':t')
    local lnum = entry.lnum and (entry.lnum + 1) or 0
    local text = entry.text or ''
    return {
      value = entry,
      display = function()
        return displayer {
          filename,
          string.format(':%d: %s', lnum, text),
        }
      end,
      ordinal = filename .. ' ' .. text,
      filename = entry.filename,
      lnum = entry.lnum,
      col = entry.col,
      text = text,
    }
  end
end

-- Wrapper for file-based pickers
local function filename_only_picker(picker_fn, opts)
  opts = opts or {}
  opts.entry_maker = filename_only_entry_maker()
  picker_fn(opts)
end

-- Wrapper for LSP-based pickers
local function lsp_filename_picker(picker_fn, opts)
  opts = opts or {}
  opts.entry_maker = lsp_filename_entry_maker()
  picker_fn(opts)
end

return {
  -- file pickers
  find_files = function(opts)
    filename_only_picker(builtin.find_files, opts)
  end,
  git_files = function(opts)
    filename_only_picker(builtin.git_files, opts)
  end,
  oldfiles = function(opts)
    filename_only_picker(builtin.oldfiles, opts)
  end,
  live_grep = function(opts)
    filename_only_picker(builtin.live_grep, opts)
  end,
  buffers = function(opts)
    filename_only_picker(builtin.buffers, opts)
  end,

  -- lsp pickers
  lsp_references = function(opts)
    lsp_filename_picker(builtin.lsp_references, opts)
  end,
  lsp_definitions = function(opts)
    lsp_filename_picker(builtin.lsp_definitions, opts)
  end,
  lsp_implementations = function(opts)
    lsp_filename_picker(builtin.lsp_implementations, opts)
  end,
  lsp_type_definitions = function(opts)
    lsp_filename_picker(builtin.lsp_type_definitions, opts)
  end,
  lsp_incoming_calls = function(opts)
    lsp_filename_picker(builtin.lsp_incoming_calls, opts)
  end,
  lsp_outgoing_calls = function(opts)
    lsp_filename_picker(builtin.lsp_outgoing_calls, opts)
  end,
  lsp_document_symbols = function(opts)
    lsp_filename_picker(builtin.lsp_document_symbols, opts)
  end,
  lsp_dynamic_workspace_symbols = function(opts)
    lsp_filename_picker(builtin.lsp_dynamic_workspace_symbols, opts)
  end,
}
