-- Enable faster startup by caching compiled Lua modules
vim.loader.enable()
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.o.wrap = false
vim.o.swapfile = false
vim.o.number = true
vim.o.relativenumber = true
vim.o.signcolumn = 'yes'
vim.o.mouse = 'a'
vim.o.showmode = false
vim.o.breakindent = true
vim.o.undofile = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.list = true
vim.opt.listchars = { tab = '  ', trail = '·', nbsp = '␣' }
vim.o.cursorline = true
vim.o.scrolloff = 10
vim.o.confirm = true
vim.o.winborder = "rounded"

vim.schedule(function() vim.o.clipboard = 'unnamedplus' end)

vim.keymap.set('n', '<leader>o', ':update<CR> :source<CR>')
vim.keymap.set('n', '<leader>w', ':write<CR>')
vim.keymap.set('n', '<leader>q', ':quit<CR>')


vim.pack.add({
  { src = 'https://github.com/stevearc/oil.nvim' },
  { src = 'https://github.com/folke/which-key.nvim' },
  { src = 'https://github.com/echasnovski/mini.pick' },
  { src = 'https://github.com/nvim-mini/mini.nvim' },
  { src = 'https://github.com/neovim/nvim-lspconfig' },
  { src = 'https://github.com/mason-org/mason.nvim' },
})

require('mini.pick').setup {}
require('oil').setup {}
require('which-key').setup {
  delay = 0,
  spec = {
    { '<leader>s', group = '[S]earch',    mode = { 'n', 'v' } },
    { '<leader>t', group = '[T]oggle' },
    { 'g',         group = 'LSP Actions', mode = { 'n' } },
  },
}
require('mason').setup {}
require('mini.statusline').setup({})
vim.lsp.enable({ "lua_ls" })

vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(event)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    if client:supports_method('textDocument/completion') then
      vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
    end
    local buf = event.buf
    -- To jump back, press <C-t>.
    vim.keymap.set('n', 'gd', vim.diagnostic.setloclist, { desc = 'Open [D]iagnostics list' })
    vim.keymap.set('n', 'gr', builtin.lsp_references, { buffer = buf, desc = '[G]oto [R]eferences' })
    vim.keymap.set('n', 'gi', builtin.lsp_implementations, { buffer = buf, desc = '[G]oto [I]mplementation' })
    vim.keymap.set('n', 'gd', builtin.lsp_definitions, { buffer = buf, desc = '[G]oto [D]efinition' })
    vim.keymap.set('n', 'gt', builtin.lsp_type_definitions, { buffer = buf, desc = '[G]oto [T]ype Definition' })
    vim.keymap.set('n', 'gSD', builtin.lsp_document_symbols, { buffer = buf, desc = 'Open Document Symbols' })
    vim.keymap.set('n', 'gSW', builtin.lsp_dynamic_workspace_symbols, { buffer = buf, desc = 'Open Workspace Symbols' })
  end,
})



vim.keymap.set('n', '<leader>f', ":Pick files<CR>")
vim.keymap.set('n', '<leader>h', ":Pick help<CR>")
vim.keymap.set('n', '<leader>e', ":Oil<CR>")

vim.keymap.set('n', '<leader>lf', vim.lsp.buf.format)
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function() vim.hl.on_yank() end,
})

-- [[ Colorscheme ]]
local silent_bonsai = require 'colors.silentbonsai'
silent_bonsai.setup {
  transparent = false,    -- enable transparent background
  terminal_colors = true, -- set terminal colors
  dim_inactive = false,   -- dim inactive windows
  styles = {
    comments = { italic = true },
    keywords = { italic = true },
    functions = {},
    variables = {},
    sidebars = 'dark', -- "dark", "transparent", or "normal"
    floats = 'dark',   -- "dark", "transparent", or "normal"
  },
}
silent_bonsai.load()


-- require('telescope').setup {
--   extensions = {
--     ['ui-select'] = { require('telescope.themes').get_dropdown() },-   },
-- }
--
-- -- Enable Telescope extensions if they are installed
-- pcall(require('telescope').load_extension, 'fzf')
-- pcall(require('telescope').load_extension, 'ui-select')
--
-- -- See `:help telescope.builtin`
-- local builtin = require 'telescope.builtin'
-- vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
-- vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
-- vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
-- vim.keymap.set('n', '<leader>ss', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })
-- vim.keymap.set({ 'n', 'v' }, '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
-- vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
-- vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
-- vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
-- vim.keymap.set('n', '<leader>s.', builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
-- vim.keymap.set('n', '<leader>sc', builtin.commands, { desc = '[S]earch [C]ommands' })
-- vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })
-- -- Add Telescope-based LSP pickers when an LSP attaches to a buffer.
-- -- If you later switch picker plugins, this is where to update these mappings.
-- vim.api.nvim_create_autocmd('LspAttach', {
--   group = vim.api.nvim_create_augroup('telescope-lsp-attach', { clear = true }),
--   callback = function(event)
--     local buf = event.buf
--
--     -- Find references for the word under your cursor.
--     vim.keymap.set('n', 'grr', builtin.lsp_references, { buffer = buf, desc = '[G]oto [R]eferences' })
--     vim.keymap.set('n', 'gri', builtin.lsp_implementations, { buffer = buf, desc = '[G]oto [I]mplementation' })
--     -- To jump back, press <C-t>.
--     vim.keymap.set('n', 'grd', builtin.lsp_definitions, { buffer = buf, desc = '[G]oto [D]efinition' })
--     vim.keymap.set('n', 'gO', builtin.lsp_document_symbols, { buffer = buf, desc = 'Open Document Symbols' })
--     vim.keymap.set('n', 'gW', builtin.lsp_dynamic_workspace_symbols, { buffer = buf, desc = 'Open Workspace Symbols' })
--     vim.keymap.set('n', 'grt', builtin.lsp_type_definitions, { buffer = buf, desc = '[G]oto [T]ype Definition' })
--   end,
-- })
--
-- -- Override default behavior and theme when searching
-- vim.keymap.set(
--   'n',
--   '<leader>/',
--   function()
--     builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
--       winblend = 10,
--       previewer = false,
--     })
--   end,
--   { desc = '[/] Fuzzily search in current buffer' }
-- )

-- require('blink.cmp').setup {
--   keymap = {
--     -- 'default' (recommended) for mappings similar to built-in completions
--     --   <c-y> to accept ([y]es) the completion.
--     --    This will auto-import if your LSP supports it.
--     --    This will expand snippets if the LSP sent a snippet.
--     -- 'super-tab' for tab to accept
--     -- 'enter' for enter to accept
--     -- 'none' for no mappings
--     --
--     -- For an understanding of why the 'default' preset is recommended,
--     -- you will need to read `:help ins-completion`
--     --
--     -- No, but seriously. Please read `:help ins-completion`, it is really good!
--     --
--     -- All presets have the following mappings:
--     -- <tab>/<s-tab>: move to right/left of your snippet expansion
--     -- <c-space>: Open menu or open docs if already open
--     -- <c-n>/<c-p> or <up>/<down>: Select next/previous item
--     -- <c-e>: Hide menu
--     -- <c-k>: Toggle signature help
--     --
--     -- See `:help blink-cmp-config-keymap` for defining your own keymap
--     preset = 'default',
--   },
--
--   appearance = {
--     -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
--     -- Adjusts spacing to ensure icons are aligned
--     nerd_font_variant = 'mono',
--   },
--
--   completion = {
--     -- By default, you may press `<c-space>` to show the documentation.
--     -- Optionally, set `auto_show = true` to show the documentation after a delay.
--     documentation = { auto_show = false, auto_show_delay_ms = 500 },
--   },
--
--   sources = {
--     default = { 'lsp', 'path', 'snippets' },
--   },
--
--   fuzzy = { implementation = 'lua' },
--   signature = { enabled = true },
-- }
--


-- Diagnostics
-- vim.diagnostic.config {
--   update_in_insert = false,
--   severity_sort = true,
--   float = { border = 'rounded', source = 'if_many' },
--   underline = { severity = { min = vim.diagnostic.severity.WARN } },
--   virtual_text = false, -- Text shows up at the end of the line
--   virtual_lines = true, -- Text shows up underneath the line, with virtual lines
--   jump = {
--     on_jump = function(_, bufnr)
--       vim.diagnostic.open_float {
--         bufnr = bufnr,
--         scope = 'cursor',
--         focus = false,
--       }
--     end,
--   },
-- }

-- local function run_build(name, cmd, cwd)
--   local result = vim.system(cmd, { cwd = cwd }):wait()
--   if result.code ~= 0 then
--     local stderr = result.stderr or ''
--     local stdout = result.stdout or ''
--     local output = stderr ~= '' and stderr or stdout
--     if output == '' then output = 'No output from build command.' end
--     vim.notify(('Build failed for %s:\n%s'):format(name, output), vim.log.levels.ERROR)
--   end
-- end
--
-- -- This autocommand runs after a plugin is installed or updated and
-- --  runs the appropriate build command for that plugin if necessary.
-- --
-- -- See `:help vim.pack-events`
-- vim.api.nvim_create_autocmd('PackChanged', {
--   callback = function(ev)
--     local name = ev.data.spec.name
--     local kind = ev.data.kind
--     if kind ~= 'install' and kind ~= 'update' then return end
--
--     if name == 'telescope-fzf-native.nvim' and vim.fn.executable 'make' == 1 then
--       run_build(name, { 'make' }, ev.data.path)
--       return
--     end
--
--     if name == 'nvim-treesitter' then
--       if not ev.data.active then vim.cmd.packadd 'nvim-treesitter' end
--       vim.cmd 'TSUpdate'
--       return
--     end
--   end,
-- })
--
---Because most plugins are hosted on GitHub, you can use the helper
---function to have less repetition in the following sections.
-- ---@param repo string
-- ---@return string
-- local function gh(repo) return 'https://github.com/' .. repo end
--
-- ============================================================
-- SECTION 3: UI / CORE UX PLUGINS
-- guess-indent, gitsigns, which-key, colorscheme, todo-comments, mini modules
-- ============================================================
-- vim.pack.add { gh 'lewis6991/gitsigns.nvim' }
-- require('gitsigns').setup {
--   signs = {
--     add = { text = '+' }, ---@diagnostic disable-line: missing-fields
--     change = { text = '~' }, ---@diagnostic disable-line: missing-fields
--     delete = { text = '_' }, ---@diagnostic disable-line: missing-fields
--     topdelete = { text = '‾' }, ---@diagnostic disable-line: missing-fields
--     changedelete = { text = '~' }, ---@diagnostic disable-line: missing-fields
--   },
-- }
-- Highlight todo, notes, etc in comments
-- vim.pack.add { gh 'folke/todo-comments.nvim' }
-- require('todo-comments').setup { signs = false }
--
-- vim.pack.add { gh 'nvim-mini/mini.nvim' }
--
-- require('mini.ai').setup {
--   mappings = {
--     around_next = 'aa',
--     inside_next = 'ii',
--   },
--   n_lines = 500,
-- }
-- require('mini.surround').setup()

-- [[ Fuzzy Finder (files, lsp, etc) ]]
--
-- Telescope is a fuzzy finder that comes with a lot of different things that
-- it can fuzzy find! It's more than just a "file finder", it can search
-- many different aspects of Neovim, your workspace, LSP, and more!
--
-- The easiest way to use Telescope, is to start by doing something like:
--  :Telescope help_tags
--
-- After running this command, a window will open up and you're able to
-- type in the prompt window. You'll see a list of `help_tags` options and
-- a corresponding preview of the help.
--
-- Two important keymaps to use while in Telescope are:
--  - Insert mode: <c-/>
--  - Normal mode: ?
--
-- This opens a window that shows you all of the keymaps for the current
-- Telescope picker. This is really useful to discover what Telescope can
-- do as well as how to actually do it!

-- [[ LSP Configuration ]]
-- Brief aside: **What is LSP?**
--
-- LSP is an initialism you've probably heard, but might not understand what it is.
--
-- LSP stands for Language Server Protocol. It's a protocol that helps editors
-- and language tooling communicate in a standardized fashion.
--
-- In general, you have a "server" which is some tool built to understand a particular
-- language (such as `gopls`, `lua_ls`, `rust_analyzer`, etc.). These Language Servers
-- (sometimes called LSP servers, but that's kind of like ATM Machine) are standalone
-- processes that communicate with some "client" - in this case, Neovim!
--
-- LSP provides Neovim with features like:
--  - Go to definition
--  - Find references
--  - Autocompletion
--  - Symbol Search
--  - and more!
--
-- Thus, Language Servers are external tools that must be installed separately from
-- Neovim. This is where `mason` and related plugins come into play.
--
-- If you're wondering about lsp vs treesitter, you can check out the wonderfully
-- and elegantly composed help section, `:help lsp-vs-treesitter`

-- Useful status updates for LSP.
-- vim.pack.add { gh 'j-hui/fidget.nvim' }
-- require('fidget').setup {}
--
-- vim.api.nvim_create_autocmd('LspAttach', {
--   group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
--   callback = function(event)
--     local map = function(keys, func, desc, mode)
--       mode = mode or 'n'
--       vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
--     end
--
--     map('gra', vim.lsp.buf.code_action, '[G]oto Code [A]ction', { 'n', 'x' })
--     map('grD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
--     -- The following two autocommands are used to highlight references of the
--  end,
-- })
--
-- Enable the following language servers
--  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
--  See `:help lsp-config` for information about keys and how to configure
-- ---@type table<string, vim.lsp.Config>
-- local servers = {
--   -- clangd = {},
--   -- gopls = {},
--   -- pyright = {},
--   -- rust_analyzer = {},
--   --
--   -- Some languages (like typescript) have entire language plugins that can be useful:
--   --    https://github.com/pmizio/typescript-tools.nvim
--   --
--   -- But for many setups, the LSP (`ts_ls`) will work just fine
--   -- ts_ls = {},
--
--   stylua = {}, -- Used to format Lua code
--
--   -- Special Lua Config, as recommended by neovim help docs
--   lua_ls = {
--     on_init = function(client)
--       client.server_capabilities.documentFormattingProvider = false -- Disable formatting (formatting is done by stylua)
--       if client.workspace_folders then
--         local path = client.workspace_folders[1].name
--         if path ~= vim.fn.stdpath 'config' and (vim.uv.fs_stat(path .. '/.luarc.json') or vim.uv.fs_stat(path .. '/.luarc.jsonc')) then return end
--       end
--       client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
--         runtime = {
--           version = 'LuaJIT',
--           path = { 'lua/?.lua', 'lua/?/init.lua' },
--         },
--         workspace = {
--           checkThirdParty = false,
--           -- NOTE: this is a lot slower and will cause issues when working on your own configuration.
--           --  See https://github.com/neovim/nvim-lspconfig/issues/3189
--           library = vim.tbl_extend('force', vim.api.nvim_get_runtime_file('', true), {
--             '${3rd}/luv/library',
--             '${3rd}/busted/library',
--           }),
--         },
--       })
--     end,
--     ---@type lspconfig.settings.lua_ls
--     settings = {
--       Lua = {
--         format = { enable = false }, -- Disable formatting (formatting is done by stylua)
--       },
--     },
--   },
-- }
-- ============================================================
-- SECTION 6: FORMATTING
-- conform.nvim setup and keymap
-- ============================================================
-- do
--   -- [[ Formatting ]]
--   vim.pack.add { gh 'stevearc/conform.nvim' }
--   require('conform').setup {
--     notify_on_error = false,
--     format_on_save = function(bufnr)
--       local enabled_filetypes = {
--         lua = true,
--         -- python = true,
--       }
--       if enabled_filetypes[vim.bo[bufnr].filetype] then
--         return { timeout_ms = 500 }
--       else
--         return nil
--       end
--     end,
--     default_format_opts = {
--       lsp_format = 'fallback', -- Use external formatters if configured below, otherwise use LSP formatting. Set to `false` to disable LSP formatting entirely.
--     },
--     -- You can also specify external formatters in here.
--     formatters_by_ft = {
--       -- rust = { 'rustfmt' },
--       -- Conform can also run multiple formatters sequentially
--       -- python = { "isort", "black" },
--       --
--       -- You can use 'stop_after_first' to run the first available formatter from the list
--       -- javascript = { "prettierd", "prettier", stop_after_first = true },
--     },
--   }
--
--   vim.keymap.set({ 'n', 'v' }, '<leader>f', function() require('conform').format { async = true } end, { desc = '[F]ormat buffer' })
-- end
--
-- ============================================================
-- SECTION 7: AUTOCOMPLETE & SNIPPETS
-- blink.cmp and luasnip setup
-- ============================================================
-- [[ Autocomplete Engine ]]
-- vim.pack.add { { src = gh 'saghen/blink.cmp', version = vim.version.range '1.*' } }
-- ============================================================
-- SECTION 8: TREESITTER
-- Parser installation, syntax highlighting, folds, indentation
-- ============================================================
-- do
--   -- [[ Configure Treesitter ]]
--   --  Used to highlight, edit, and navigate code
--   --
--   --  See `:help nvim-treesitter-intro`
--
--   -- NOTE: You can also specify a branch or a specific commit
--   vim.pack.add { { src = gh 'nvim-treesitter/nvim-treesitter', version = 'main' } }
--
--   -- Ensure basic parsers are installed
--   local parsers = { 'bash', 'c', 'diff', 'html', 'lua', 'luadoc', 'markdown', 'markdown_inline', 'query', 'vim', 'vimdoc' }
--   require('nvim-treesitter').install(parsers)
--
--   ---@param buf integer
--   ---@param language string
--   local function treesitter_try_attach(buf, language)
--     -- Check if a parser exists and load it
--     if not vim.treesitter.language.add(language) then return end
--     -- Enable syntax highlighting and other treesitter features
--     vim.treesitter.start(buf, language)
--
--     -- Enable treesitter based folds
--     -- For more info on folds see `:help folds`
--     -- vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
--     -- vim.wo.foldmethod = 'expr'
--
--     -- Check if treesitter indentation is available for this language, and if so enable it
--     -- in case there is no indent query, the indentexpr will fallback to the vim's built in one
--     local has_indent_query = vim.treesitter.query.get(language, 'indents') ~= nil
--
--     -- Enable treesitter based indentation
--     if has_indent_query then vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()" end
--   end
--
--   local available_parsers = require('nvim-treesitter').get_available()
--   vim.api.nvim_create_autocmd('FileType', {
--     callback = function(args)
--       local buf, filetype = args.buf, args.match
--
--       local language = vim.treesitter.language.get_lang(filetype)
--       if not language then return end
--
--       local installed_parsers = require('nvim-treesitter').get_installed 'parsers'
--
--       if vim.tbl_contains(installed_parsers, language) then
--         -- Enable the parser if it is already installed
--         treesitter_try_attach(buf, language)
--       elseif vim.tbl_contains(available_parsers, language) then
--         -- If a parser is available in `nvim-treesitter`, auto-install it and enable it after the installation is done
--         require('nvim-treesitter').install(language):await(function() treesitter_try_attach(buf, language) end)
--       else
--         -- Try to enable treesitter features in case the parser exists but is not available from `nvim-treesitter`
--         treesitter_try_attach(buf, language)
--       end
--     end,
--   })
-- end
--
-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
