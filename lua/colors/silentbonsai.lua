local M = {}

M.defaults = {
  transparent = false,
  terminal_colors = true,
  styles = {
    comments = { italic = true },
    keywords = { italic = true },
    functions = {},
    variables = {},
    sidebars = 'dark',
    floats = 'dark',
  },
  dim_inactive = false,
  on_colors = function(_colors) end,
  on_highlights = function(_highlights, _colors) end,
}

M.options = nil

-- Derived from arvore-dark.json
-- stylua: ignore
local palette = {
  bg           = '#151E23',
  bg_dark      = '#121D24',
  bg_darker    = '#0D1B22',
  bg_float     = '#1A2830',
  bg_highlight = '#1A2A2E',
  bg_popup     = '#1A2830',
  bg_sidebar   = '#121D24',
  bg_statusline = '#0D1B22',
  bg_visual    = '#2b4040',
  bg_search    = '#eddcc8',
  border       = '#eddcc8',
  border_highlight = '#eddcc8',
  comment      = '#7C98A1',
  fg           = '#f5e6de',
  fg_dark      = '#e7cbac',
  fg_gutter    = '#345760',
  fg_sidebar   = '#e7cbac',
  none         = 'NONE',

  -- Core palette
  black        = '#010609',
  red          = '#fa7578',
  red1         = '#f83a3d',
  green        = '#8edac5',
  green1       = '#8edac5',
  green2       = '#8edac5',
  yellow       = '#FDD351',
  yellow1      = '#FDC200',
  orange       = '#f6c198',
  orange1      = '#f6c198',
  blue         = '#6394F3',
  blue1        = '#4F81F1',
  blue2        = '#8DAEF6',
  cyan         = '#8edac5',
  cyan1        = '#8edac5',
  cyan2        = '#8edac5',
  cyan3        = '#8edac5',
  teal         = '#8edac5',
  purple       = '#B29CE7',
  purple1      = '#9272DC',
  purple2      = '#C8B9EE',
  magenta      = '#FC98AB',
  pink         = '#FDC3B1',

  -- Semantic
  error        = '#fa7578',
  warning      = '#f6c198',
  info         = '#7C98A1',
  hint         = '#7C98A1',
  todo         = '#8edac5',

  -- Terminal
  terminal_black = '#7C98A1',

  -- Diff
  diff = {
    add    = '#1E2E24',
    delete = '#2E1A1E',
    change = '#1A2230',
    text   = '#1E2840',
  },

  -- Git
  git = {
    add    = '#8edac5',
    change = '#8edac5',
    delete = '#fa7578',
    ignore = '#406A76',
  },

  -- Rainbow brackets
  rainbow = { '#fadfcb', '#f6c198', '#f0a05a', '#f0a05a', '#d57400', '#844700' },
}

---@param fg string foreground color
---@param alpha number number between 0 and 1
---@param bg string background color
function M.blend(fg, alpha, bg)
  local function rgb(c)
    c = string.lower(c)
    return { tonumber(c:sub(2, 3), 16), tonumber(c:sub(4, 5), 16), tonumber(c:sub(6, 7), 16) }
  end
  alpha = type(alpha) == 'string' and (tonumber(alpha, 16) / 0xff) or alpha
  local b = rgb(bg)
  local f = rgb(fg)
  local blend = function(i)
    local ret = (alpha * f[i] + ((1 - alpha) * b[i]))
    return math.floor(math.min(math.max(0, ret), 255) + 0.5)
  end
  return string.format('#%02x%02x%02x', blend(1), blend(2), blend(3))
end

local function get_highlights(c, opts)
  local transparent = opts.transparent
  local blend = M.blend

  -- stylua: ignore
  local hl = {
    -- Base editor highlights
    Comment                     = { fg = c.comment, style = opts.styles.comments },
    ColorColumn                 = { bg = c.black },
    Conceal                     = { fg = c.fg_gutter },
    Cursor                      = { fg = c.bg, bg = c.fg },
    lCursor                     = { fg = c.bg, bg = c.fg },
    CursorIM                    = { fg = c.bg, bg = c.fg },
    CursorColumn                = { bg = c.bg_highlight },
    CursorLine                  = { bg = c.bg_highlight },
    Directory                   = { fg = c.fg_dark },
    DiffAdd                     = { bg = c.diff.add },
    DiffChange                  = { bg = c.diff.change },
    DiffDelete                  = { bg = c.diff.delete },
    DiffText                    = { bg = c.diff.text },
    EndOfBuffer                 = { fg = c.bg },
    ErrorMsg                    = { fg = c.error },
    VertSplit                   = { fg = c.border },
    WinSeparator                = { fg = c.border, bold = true },
    Folded                      = { fg = c.fg, bg = c.fg_gutter },
    FoldColumn                  = { bg = transparent and c.none or c.bg, fg = c.comment },
    SignColumn                  = { bg = transparent and c.none or c.bg, fg = c.fg_gutter },
    SignColumnSB                = { bg = c.bg_sidebar, fg = c.fg_gutter },
    Substitute                  = { bg = c.red, fg = c.black },
    LineNr                      = { fg = c.fg_gutter },
    CursorLineNr                = { fg = c.fg, bold = true },
    LineNrAbove                 = { fg = c.fg_gutter },
    LineNrBelow                 = { fg = c.fg_gutter },
    MatchParen                  = { fg = c.fg_dark, bold = true },
    ModeMsg                     = { fg = c.fg_dark, bold = true },
    MsgArea                     = { fg = c.fg },
    MoreMsg                     = { fg = c.fg },
    NonText                     = { fg = c.border },
    Normal                      = { fg = c.fg, bg = transparent and c.none or c.bg },
    NormalNC                    = { fg = c.fg, bg = transparent and c.none or opts.dim_inactive and c.bg_dark or c.bg },
    NormalSB                    = { fg = c.fg_sidebar, bg = c.bg_sidebar },
    NormalFloat                 = { fg = c.fg, bg = c.bg_float },
    FloatBorder                 = { fg = c.border_highlight, bg = c.bg_float },
    FloatTitle                  = { fg = c.border_highlight, bg = c.bg_float },
    Pmenu                       = { bg = c.bg_popup, fg = c.fg },
    PmenuMatch                  = { bg = c.bg_popup, fg = c.fg_dark },
    PmenuSel                    = { bg = blend(c.fg_gutter, 0.8, c.bg) },
    PmenuMatchSel               = { bg = blend(c.fg_gutter, 0.8, c.bg), fg = c.fg_dark },
    PmenuSbar                   = { bg = blend(c.bg_popup, 0.95, c.fg) },
    PmenuThumb                  = { bg = c.fg_gutter },
    Question                    = { fg = c.fg },
    QuickFixLine                = { bg = c.bg_visual, bold = true },
    Search                      = { bg = c.bg_search, fg = c.fg },
    IncSearch                   = { bg = c.orange, fg = c.black },
    CurSearch                   = 'IncSearch',
    SpecialKey                  = { fg = c.border },
    SpellBad                    = { sp = c.error, undercurl = true },
    SpellCap                    = { sp = c.warning, undercurl = true },
    SpellLocal                  = { sp = c.info, undercurl = true },
    SpellRare                   = { sp = c.hint, undercurl = true },
    StatusLine                  = { fg = c.fg_sidebar, bg = c.bg_statusline },
    StatusLineNC                = { fg = c.fg_gutter, bg = c.bg_statusline },
    TabLine                     = { bg = c.bg_statusline, fg = c.fg_gutter },
    TabLineFill                 = { bg = transparent and c.none or c.black },
    TabLineSel                  = { fg = c.black, bg = c.cyan2 },
    Title                       = { fg = c.fg_dark, bold = true },
    Visual                      = { bg = c.bg_visual },
    VisualNOS                   = { bg = c.bg_visual },
    WarningMsg                  = { fg = c.warning },
    Whitespace                  = { fg = c.fg_gutter },
    WildMenu                    = { bg = c.bg_visual },
    WinBar                      = 'StatusLine',
    WinBarNC                    = 'StatusLineNC',

    -- Syntax highlights
    Bold                        = { bold = true, fg = c.fg },
    Character                   = { fg = c.fg },
    Constant                    = { fg = c.fg },
    Debug                       = { fg = c.orange },
    Delimiter                   = 'Special',
    Error                       = { fg = c.error },
    Function                    = { fg = c.fg, style = opts.styles.functions },
    Identifier                  = { fg = c.fg, style = opts.styles.variables },
    Italic                      = { italic = true, fg = c.fg },
    Keyword                     = { fg = c.orange, style = opts.styles.keywords },
    Operator                    = { fg = c.fg },
    PreProc                     = { fg = c.fg },
    Special                     = { fg = c.fg },
    Statement                   = { fg = c.fg },
    String                      = { fg = c.cyan },
    Todo                        = { bg = c.todo, fg = c.bg },
    Type                        = { fg = c.fg_dark },
    Underlined                  = { underline = true },
    debugBreakpoint             = { bg = blend(c.info, 0.1, c.bg), fg = c.info },
    debugPC                     = { bg = c.bg_sidebar },
    dosIniLabel                 = '@property',
    helpCommand                 = { bg = c.terminal_black, fg = c.blue },
    htmlH1                      = { fg = c.fg, bold = true },
    htmlH2                      = { fg = c.fg, bold = true },
    qfFileName                  = { fg = c.fg },
    qfLineNr                    = { fg = c.fg_gutter },
    Number                      = { fg = c.orange },
    Float                       = { fg = c.orange },
    Boolean                     = { fg = c.orange },

    -- LSP
    LspReferenceText            = { bg = c.fg_gutter },
    LspReferenceRead            = { bg = c.fg_gutter },
    LspReferenceWrite           = { bg = c.fg_gutter },
    LspSignatureActiveParameter = { bg = blend(c.bg_visual, 0.4, c.bg), bold = true },
    LspCodeLens                 = { fg = c.comment },
    LspInlayHint                = { bg = c.bg_highlight, fg = c.comment },
    LspInfoBorder               = { fg = c.border_highlight, bg = c.bg_float },

    -- Diagnostics
    DiagnosticError             = { fg = c.error },
    DiagnosticWarn              = { fg = c.warning },
    DiagnosticInfo              = { fg = c.info },
    DiagnosticHint              = { fg = c.hint },
    DiagnosticUnnecessary       = { fg = c.terminal_black },
    DiagnosticVirtualTextError  = { bg = blend(c.error, 0.1, c.bg), fg = c.error },
    DiagnosticVirtualTextWarn   = { bg = blend(c.warning, 0.1, c.bg), fg = c.warning },
    DiagnosticVirtualTextInfo   = { bg = blend(c.info, 0.1, c.bg), fg = c.info },
    DiagnosticVirtualTextHint   = { bg = blend(c.hint, 0.1, c.bg), fg = c.hint },
    DiagnosticUnderlineError    = { undercurl = true, sp = c.error },
    DiagnosticUnderlineWarn     = { undercurl = true, sp = c.warning },
    DiagnosticUnderlineInfo     = { undercurl = true, sp = c.info },
    DiagnosticUnderlineHint     = { undercurl = true, sp = c.hint },

    -- Health
    healthError                 = { fg = c.error },
    healthSuccess               = { fg = c.green },
    healthWarning               = { fg = c.warning },

    -- Diff
    diffAdded                   = { bg = c.diff.add, fg = c.git.add },
    diffRemoved                 = { bg = c.diff.delete, fg = c.git.delete },
    diffChanged                 = { bg = c.diff.change, fg = c.git.change },
    diffOldFile                 = { fg = c.blue, bg = c.diff.delete },
    diffNewFile                 = { fg = c.blue, bg = c.diff.add },
    diffFile                    = { fg = c.blue },
    diffLine                    = { fg = c.comment },
    diffIndexLine               = { fg = c.purple },
    helpExample                 = { fg = c.comment },

    -- Treesitter
    ['@annotation']                 = 'PreProc',
    ['@attribute']                  = 'PreProc',
    ['@boolean']                    = 'Boolean',
    ['@character']                  = 'Character',
    ['@character.printf']           = 'SpecialChar',
    ['@character.special']          = 'SpecialChar',
    ['@comment']                    = 'Comment',
    ['@comment.error']              = { fg = c.error },
    ['@comment.hint']               = { fg = c.hint },
    ['@comment.info']               = { fg = c.info },
    ['@comment.note']               = { fg = c.hint },
    ['@comment.todo']               = { fg = c.todo },
    ['@comment.warning']            = { fg = c.warning },
    ['@constant']                   = 'Constant',
    ['@constant.builtin']           = 'Special',
    ['@constant.macro']             = 'Define',
    ['@constructor']                = { fg = c.fg },
    ['@constructor.tsx']            = { fg = c.fg },
    ['@diff.delta']                 = 'DiffChange',
    ['@diff.minus']                 = 'DiffDelete',
    ['@diff.plus']                  = 'DiffAdd',
    ['@function']                   = 'Function',
    ['@function.builtin']           = 'Special',
    ['@function.call']              = '@function',
    ['@function.macro']             = 'Macro',
    ['@function.method']            = 'Function',
    ['@function.method.call']       = '@function.method',
    ['@keyword']                    = { fg = c.fg_dark, style = opts.styles.keywords },
    ['@keyword.conditional']        = 'Conditional',
    ['@keyword.coroutine']          = '@keyword',
    ['@keyword.debug']              = 'Debug',
    ['@keyword.directive']          = 'PreProc',
    ['@keyword.directive.define']   = 'Define',
    ['@keyword.exception']          = 'Exception',
    ['@keyword.function']           = { fg = c.fg_dark, style = opts.styles.functions },
    ['@keyword.import']             = 'Include',
    ['@keyword.operator']           = '@operator',
    ['@keyword.repeat']             = 'Repeat',
    ['@keyword.return']             = '@keyword',
    ['@keyword.storage']            = 'StorageClass',
    ['@label']                      = { fg = c.fg },
    ['@markup']                     = '@none',
    ['@markup.emphasis']            = { italic = true },
    ['@markup.environment']         = 'Macro',
    ['@markup.environment.name']    = 'Type',
    ['@markup.heading']             = 'Title',
    ['@markup.italic']              = { italic = true },
    ['@markup.link']                = { fg = c.cyan },
    ['@markup.link.label']          = 'SpecialChar',
    ['@markup.link.label.symbol']   = 'Identifier',
    ['@markup.link.url']            = 'Underlined',
    ['@markup.list']                = { fg = c.fg_dark },
    ['@markup.list.checked']        = { fg = c.cyan },
    ['@markup.list.markdown']       = { fg = c.orange, bold = true },
    ['@markup.list.unchecked']      = { fg = c.orange },
    ['@markup.math']                = 'Special',
    ['@markup.raw']                 = 'String',
    ['@markup.raw.markdown_inline'] = { bg = c.terminal_black, fg = c.fg },
    ['@markup.strikethrough']       = { strikethrough = true },
    ['@markup.strong']              = { bold = true },
    ['@markup.underline']           = { underline = true },
    ['@module']                     = 'Include',
    ['@module.builtin']             = { fg = c.fg },
    ['@namespace.builtin']          = '@variable.builtin',
    ['@none']                       = {},
    ['@number']                     = 'Number',
    ['@number.float']               = 'Float',
    ['@operator']                   = { fg = c.fg },
    ['@property']                   = { fg = c.fg },
    ['@punctuation.bracket']        = { fg = c.fg },
    ['@punctuation.delimiter']      = { fg = c.fg },
    ['@punctuation.special']        = { fg = c.fg },
    ['@punctuation.special.markdown'] = { fg = c.fg },
    ['@string']                     = 'String',
    ['@string.documentation']       = { fg = c.fg },
    ['@string.escape']              = { fg = c.cyan },
    ['@string.regexp']              = { fg = c.cyan },
    ['@tag']                        = { fg = c.fg },
    ['@tag.attribute']              = { fg = c.fg, italic = true },
    ['@tag.delimiter']              = 'Delimiter',
    ['@tag.delimiter.tsx']          = { fg = c.fg },
    ['@tag.tsx']                    = { fg = c.fg },
    ['@tag.javascript']             = { fg = c.fg },
    ['@type']                       = 'Type',
    ['@type.builtin']               = { fg = c.fg },
    ['@type.definition']            = 'Typedef',
    ['@type.qualifier']             = '@keyword',
    ['@variable']                   = { fg = c.fg, style = opts.styles.variables },
    ['@variable.builtin']           = { fg = c.fg },
    ['@variable.member']            = { fg = c.fg },
    ['@variable.parameter']         = { fg = c.fg },
    ['@variable.parameter.builtin'] = { fg = c.fg },

    -- LSP semantic tokens
    ['@lsp.type.boolean']                      = '@boolean',
    ['@lsp.type.builtinType']                  = '@type.builtin',
    ['@lsp.type.comment']                      = '@comment',
    ['@lsp.type.decorator']                    = '@attribute',
    ['@lsp.type.deriveHelper']                 = '@attribute',
    ['@lsp.type.enum']                         = '@type',
    ['@lsp.type.enumMember']                   = { fg = c.cyan },
    ['@lsp.type.escapeSequence']               = '@string.escape',
    ['@lsp.type.formatSpecifier']              = '@markup.list',
    ['@lsp.type.generic']                      = '@variable',
    ['@lsp.type.interface']                    = { fg = c.cyan },
    ['@lsp.type.keyword']                      = '@keyword',
    ['@lsp.type.lifetime']                     = '@keyword.storage',
    ['@lsp.type.namespace']                    = '@module',
    ['@lsp.type.namespace.python']             = '@variable',
    ['@lsp.type.number']                       = '@number',
    ['@lsp.type.operator']                     = '@operator',
    ['@lsp.type.parameter']                    = '@variable.parameter',
    ['@lsp.type.property']                     = '@property',
    ['@lsp.type.selfKeyword']                  = '@variable.builtin',
    ['@lsp.type.selfTypeKeyword']              = '@variable.builtin',
    ['@lsp.type.string']                       = '@string',
    ['@lsp.type.typeAlias']                    = '@type.definition',
    ['@lsp.type.unresolvedReference']          = { undercurl = true, sp = c.error },
    ['@lsp.type.variable']                     = {},
    ['@lsp.typemod.class.defaultLibrary']      = '@type.builtin',
    ['@lsp.typemod.enum.defaultLibrary']       = '@type.builtin',
    ['@lsp.typemod.enumMember.defaultLibrary'] = '@constant.builtin',
    ['@lsp.typemod.function.defaultLibrary']   = '@function.builtin',
    ['@lsp.typemod.keyword.async']             = '@keyword.coroutine',
    ['@lsp.typemod.keyword.injected']          = '@keyword',
    ['@lsp.typemod.macro.defaultLibrary']      = '@function.builtin',
    ['@lsp.typemod.method.defaultLibrary']     = '@function.builtin',
    ['@lsp.typemod.operator.injected']         = '@operator',
    ['@lsp.typemod.string.injected']           = '@string',
    ['@lsp.typemod.struct.defaultLibrary']     = '@type.builtin',
    ['@lsp.typemod.type.defaultLibrary']       = { fg = c.cyan },
    ['@lsp.typemod.typeAlias.defaultLibrary']  = { fg = c.cyan },
    ['@lsp.typemod.variable.callable']         = '@function',
    ['@lsp.typemod.variable.defaultLibrary']   = '@variable.builtin',
    ['@lsp.typemod.variable.injected']         = '@variable',
    ['@lsp.typemod.variable.static']           = '@constant',

    -- Completion item kinds
    CmpItemKindDefault          = { fg = c.fg },
    CmpItemKindClass            = { fg = c.fg_dark },
    CmpItemKindColor            = { fg = c.cyan },
    CmpItemKindConstant         = { fg = c.fg },
    CmpItemKindConstructor      = { fg = c.fg },
    CmpItemKindEnum             = { fg = c.fg_dark },
    CmpItemKindEnumMember       = { fg = c.fg },
    CmpItemKindEvent            = { fg = c.fg },
    CmpItemKindField            = { fg = c.fg },
    CmpItemKindFile             = { fg = c.fg },
    CmpItemKindFolder           = { fg = c.fg_dark },
    CmpItemKindFunction         = { fg = c.fg },
    CmpItemKindInterface        = { fg = c.fg },
    CmpItemKindKeyword          = { fg = c.fg_dark },
    CmpItemKindMethod           = { fg = c.fg },
    CmpItemKindModule           = { fg = c.fg_dark },
    CmpItemKindOperator         = { fg = c.fg },
    CmpItemKindProperty         = { fg = c.fg },
    CmpItemKindReference        = { fg = c.fg },
    CmpItemKindSnippet          = { fg = c.fg },
    CmpItemKindStruct           = { fg = c.fg },
    CmpItemKindText             = { fg = c.fg },
    CmpItemKindTypeParameter    = { fg = c.fg },
    CmpItemKindUnit             = { fg = c.fg },
    CmpItemKindValue            = { fg = c.fg },
    CmpItemKindVariable         = { fg = c.fg },

    -- Telescope
    TelescopeNormal             = { fg = c.fg, bg = c.bg_float },
    TelescopeBorder             = { fg = c.border_highlight, bg = c.bg_float },
    TelescopePromptNormal       = { bg = c.bg_float },
    TelescopePromptBorder       = { fg = c.border_highlight, bg = c.bg_float },
    TelescopePromptTitle        = { fg = c.bg, bg = c.fg_dark },
    TelescopePreviewTitle       = { fg = c.bg, bg = c.orange },
    TelescopeResultsTitle       = { fg = c.bg_float, bg = c.bg_float },
    TelescopeMatching           = { fg = c.cyan },
    TelescopeSelection          = { bg = c.bg_highlight },

    -- Gitsigns
    GitSignsAdd                 = { fg = c.git.add },
    GitSignsChange              = { fg = c.git.change },
    GitSignsDelete              = { fg = c.git.delete },

    -- Indent Blankline
    IblIndent                   = { fg = c.border, nocombine = true },
    IblScope                    = { fg = c.cyan2, nocombine = true },

    -- Notify
    NotifyERRORBorder           = { fg = blend(c.error, 0.3, c.bg) },
    NotifyWARNBorder            = { fg = blend(c.warning, 0.3, c.bg) },
    NotifyINFOBorder            = { fg = blend(c.info, 0.3, c.bg) },
    NotifyDEBUGBorder           = { fg = c.border },
    NotifyTRACEBorder           = { fg = blend(c.fg, 0.3, c.bg) },
    NotifyERRORIcon             = { fg = c.error },
    NotifyWARNIcon              = { fg = c.warning },
    NotifyINFOIcon              = { fg = c.info },
    NotifyDEBUGIcon             = { fg = c.comment },
    NotifyTRACEIcon             = { fg = c.fg },
    NotifyERRORTitle            = { fg = c.error },
    NotifyWARNTitle             = { fg = c.warning },
    NotifyINFOTitle             = { fg = c.info },
    NotifyDEBUGTitle            = { fg = c.comment },
    NotifyTRACETitle            = { fg = c.fg },
    NotifyERRORBody             = 'Normal',
    NotifyWARNBody              = 'Normal',
    NotifyINFOBody              = 'Normal',
    NotifyDEBUGBody             = 'Normal',
    NotifyTRACEBody             = 'Normal',

    -- NeoTree
    NeoTreeNormal               = { fg = c.fg_sidebar, bg = c.bg_sidebar },
    NeoTreeNormalNC             = { fg = c.fg_sidebar, bg = c.bg_sidebar },
    NeoTreeDimText              = { fg = c.fg_gutter },
    NeoTreeGitAdded             = { fg = c.git.add },
    NeoTreeGitModified          = { fg = c.git.change },
    NeoTreeGitDeleted           = { fg = c.git.delete },
    NeoTreeGitUntracked         = { fg = c.fg },
    NeoTreeIndentMarker         = { fg = c.border },
    NeoTreeRootName             = { fg = c.fg_dark, bold = true },

    -- Which-key
    WhichKey                    = { fg = c.cyan },
    WhichKeyGroup               = { fg = c.fg },
    WhichKeyDesc                = { fg = c.fg_dark },
    WhichKeySeparator           = { fg = c.comment },
    WhichKeyValue               = { fg = c.fg_gutter },

    -- Dashboard / Alpha
    DashboardHeader             = { fg = c.cyan2 },
    DashboardFooter             = { fg = c.comment },
    DashboardCenter             = { fg = c.cyan },
    DashboardShortCut           = { fg = c.purple },

    -- Trouble
    TroubleNormal               = { fg = c.fg, bg = c.bg_sidebar },

    -- Flash
    FlashBackdrop               = { fg = c.comment },
    FlashLabel                  = { bg = c.cyan2, fg = c.bg, bold = true },

    -- Noice
    NoiceCmdlinePopupBorder     = { fg = c.border_highlight },
    NoiceCmdlinePopupTitle      = { fg = c.border_highlight },
    NoiceCmdlineIcon            = { fg = c.fg },

    -- Mini
    MiniIndentscopeSymbol       = { fg = c.cyan2, nocombine = true },
    MiniStatuslineFilename      = { fg = c.fg, bg = c.bg_statusline },
    MiniStatuslineInactive      = { fg = c.comment, bg = c.bg_statusline },
    MiniCursorword              = { bg = c.fg_gutter },

    -- Snacks
    SnacksIndent                = { fg = c.border, nocombine = true },
    SnacksIndentScope           = { fg = c.cyan2, nocombine = true },
    SnacksDashboardHeader       = { fg = c.cyan2 },
    SnacksDashboardFooter       = { fg = c.comment },
    SnacksDashboardDesc         = { fg = c.fg },
    SnacksDashboardIcon         = { fg = c.cyan2 },
    SnacksDashboardKey          = { fg = c.fg },
    SnacksDashboardTitle        = { fg = c.cyan2, bold = true },
    SnacksDashboardSpecial      = { fg = c.fg },
    SnacksNotifierInfo          = { fg = c.info },
    SnacksNotifierWarn          = { fg = c.warning },
    SnacksNotifierError         = { fg = c.error },
    SnacksNotifierDebug         = { fg = c.comment },
    SnacksNotifierTrace         = { fg = c.fg },

    -- Blink.cmp
    BlinkCmpMenu                = { fg = c.fg, bg = c.bg_popup },
    BlinkCmpMenuBorder          = { fg = c.border_highlight, bg = c.bg_popup },
    BlinkCmpMenuSelection       = { bg = blend(c.fg_gutter, 0.8, c.bg) },
    BlinkCmpLabel               = { fg = c.fg },
    BlinkCmpLabelMatch          = { fg = c.cyan, bold = true },
    BlinkCmpKindDefault         = { fg = c.fg_dark },
    BlinkCmpKindClass           = { fg = c.cyan },
    BlinkCmpKindConstant        = { fg = c.orange },
    BlinkCmpKindConstructor     = { fg = c.cyan },
    BlinkCmpKindEnum            = { fg = c.cyan },
    BlinkCmpKindEnumMember      = { fg = c.pink },
    BlinkCmpKindField           = { fg = c.cyan3 },
    BlinkCmpKindFile            = { fg = c.blue },
    BlinkCmpKindFolder          = { fg = c.blue },
    BlinkCmpKindFunction        = { fg = c.blue2 },
    BlinkCmpKindInterface       = { fg = c.green2 },
    BlinkCmpKindKeyword         = { fg = c.purple },
    BlinkCmpKindMethod          = { fg = c.blue2 },
    BlinkCmpKindModule          = { fg = c.cyan },
    BlinkCmpKindOperator        = { fg = c.fg_dark },
    BlinkCmpKindProperty        = { fg = c.cyan3 },
    BlinkCmpKindSnippet         = { fg = c.purple },
    BlinkCmpKindStruct          = { fg = c.cyan },
    BlinkCmpKindText            = { fg = c.fg_dark },
    BlinkCmpKindTypeParameter   = { fg = c.green2 },
    BlinkCmpKindVariable        = { fg = c.fg },

    -- Rainbow delimiters
    RainbowDelimiterRed         = { fg = c.red },
    RainbowDelimiterYellow      = { fg = c.yellow },
    RainbowDelimiterBlue        = { fg = c.blue },
    RainbowDelimiterOrange      = { fg = c.orange },
    RainbowDelimiterGreen       = { fg = c.green },
    RainbowDelimiterViolet      = { fg = c.purple },
    RainbowDelimiterCyan        = { fg = c.cyan },
  }

  -- Markdown heading colors
  for i, color in ipairs(c.rainbow) do
    hl['@markup.heading.' .. i .. '.markdown'] = { fg = color, bold = true, bg = blend(color, 0.1, c.bg) }
  end

  return hl
end

function M.setup(opts)
  M.options = vim.tbl_deep_extend('force', {}, M.defaults, opts or {})
end

function M.extend(opts)
  return opts and vim.tbl_deep_extend('force', {}, M.options or M.defaults, opts) or (M.options or M.defaults)
end

function M.load(opts)
  opts = M.extend(opts)

  local p = vim.deepcopy(palette)
  local blend = M.blend

  p.bg_sidebar = opts.styles.sidebars == 'transparent' and p.none
    or opts.styles.sidebars == 'dark' and p.bg_dark
    or p.bg
  p.bg_float = opts.styles.floats == 'transparent' and p.none
    or opts.styles.floats == 'dark' and p.bg_dark
    or p.bg

  opts.on_colors(p)

  local c = p
  local hl = get_highlights(c, opts)

  opts.on_highlights(hl, c)

  for _, h in pairs(hl) do
    if type(h) == 'table' and type(h.style) == 'table' then
      for k, v in pairs(h.style) do
        h[k] = v
      end
      h.style = nil
    end
  end

  if vim.g.colors_name then
    vim.cmd 'hi clear'
  end

  vim.o.termguicolors = true
  vim.g.colors_name = 'bonsai'

  for group, def in pairs(hl) do
    def = type(def) == 'string' and { link = def } or def
    vim.api.nvim_set_hl(0, group, def)
  end

  if opts.terminal_colors then
    -- stylua: ignore start
    vim.g.terminal_color_0  = c.black
    vim.g.terminal_color_1  = c.red
    vim.g.terminal_color_2  = c.green
    vim.g.terminal_color_3  = c.yellow
    vim.g.terminal_color_4  = c.blue
    vim.g.terminal_color_5  = c.purple1
    vim.g.terminal_color_6  = c.cyan
    vim.g.terminal_color_7  = c.fg_dark
    vim.g.terminal_color_8  = c.terminal_black
    vim.g.terminal_color_9  = c.magenta
    vim.g.terminal_color_10 = c.green2
    vim.g.terminal_color_11 = blend(c.yellow, 0.8, '#ffffff')
    vim.g.terminal_color_12 = c.blue2
    vim.g.terminal_color_13 = c.purple2
    vim.g.terminal_color_14 = c.cyan1
    vim.g.terminal_color_15 = c.fg
    -- stylua: ignore end
  end
end

return M
