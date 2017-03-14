scriptencoding utf-8

" Each theme is contained in its own file and declares variables scoped to the
" file.  These variables represent the possible "modes" that airline can
" detect.  The mode is the return value of mode(), which gets converted to a
" readable string.  The following is a list currently supported modes: normal,
" insert, replace, visual, and inactive.
"
" Each mode can also have overrides.  These are small changes to the mode that
" don't require a completely different look.  "modified" and "paste" are two
" such supported overrides.  These are simply suffixed to the major mode,
" separated by an underscore.  For example, "normal_modified" would be normal
" mode where the current buffer is modified.
"
" The theming algorithm is a 2-pass system where the mode will draw over all
" parts of the statusline, and then the override is applied after.  This means
" it is possible to specify a subset of the theme in overrides, as it will
" simply overwrite the previous colors.  If you want simultaneous overrides,
" then they will need to change different parts of the statusline so they do
" not conflict with each other.
"
" First, let's define an empty dictionary and assign it to the "palette"
" variable. The # is a separator that maps with the directory structure. If
" you get this wrong, Vim will complain loudly.
ru colors/bronkow/material/colors.vim
"
" Helper to set colors set
" @returns {array} in attr-list format: [ guifg, guibg, ctermfg, ctermbg, opts ]. See "help attr-list"
function! C(fg_color, bg_color, ...)
  let tones = { 'dr': 'darker', 'd': 'dark', 'l': 'light', 'lr': 'lighter', 'm': 'medium' }
  let fg_split = split(a:fg_color)
  let bg_split = split(a:bg_color)
  let fg_name = fg_split[0]
  let bg_name = bg_split[0]
  let fg_tone = tones[fg_split[1]]
  let bg_tone = tones[bg_split[1]]
  let fg = g:colors[fg_name][fg_tone]
  let bg = g:colors[bg_name][bg_tone]

  let opts = a:0 > 0 ? a:1 : 'NONE'

  return [ fg.gui, bg.gui, fg.cterm, bg.cterm, opts ]
endfunction

let g:airline#themes#bronkow_material_dark#palette = {}

" First let's define some arrays. The s: is just a VimL thing for scoping the
" variables to the current script. Without this, these variables would be
" declared globally. Now let's declare some colors for normal mode and add it
" to the dictionary.  The array is in the format:
" [ guifg, guibg, ctermfg, ctermbg, opts ]. See "help attr-list" for valid
" values for the "opt" value.
let s:normal1 = C('Shade dr', 'Shade lr')
let s:normal2 = C('Shade lr', 'Shade l')
let s:normal3 = C('Shade lr', 'Shade d')
let s:normal_color_map = airline#themes#generate_color_map(s:normal1, s:normal2, s:normal3)
let s:modified = { 'airline_c': C('LightBlue l', 'Shade d') }
let s:error =    C('Grey lr', 'Red d')
let s:warning =  C('Grey lr', 'Orange dr')

" Here we define overrides for when the buffer is modified.  This will be
" applied after g:airline#themes#bronkow_material_dark#palette.normal, hence why only certain keys are
" declared.
let s:palette = {
  \'normal':           copy(s:normal_color_map),
  \'normal_modified':  copy(s:modified),
  \
  \'insert':           copy(s:normal_color_map),
  \'insert_modified':  copy(s:modified),
  \'insert_paste':     { 'airline_c': C('Cyan d', 'Shade lr') },
  \
  \'replace':          copy(s:normal_color_map),
  \'replace_modified': copy(s:modified),
  \
  \'visual':           copy(s:normal_color_map),
  \'visual_modified':  copy(s:modified)
\}
let s:palette.insert.airline_a = C('Shade d', 'Cyan d')
let s:palette.replace.airline_a = C('Shade d', 'Red d')
let s:palette.visual.airline_a = C('Shade d', 'Orange l')

let s:palette.normal.airline_warning = s:warning
let s:palette.insert.airline_warning = s:warning
let s:palette.visual.airline_warning = s:warning
let s:palette.replace.airline_warning = s:warning

let s:palette.normal.airline_error = s:error
let s:palette.insert.airline_error = s:error
let s:palette.visual.airline_error = s:error
let s:palette.replace.airline_error = s:error

let s:inactive1 = C('Shade dr', 'Shade dr')
let s:inactive2 = C('Shade d', 'Shade d')
let s:inactive3 = C('Grey d', 'Shade dr')
let s:inactive_modified = C('Red d', 'Shade dr')
let s:palette.inactive = airline#themes#generate_color_map(s:inactive1, s:inactive2, s:inactive3)
let s:palette.inactive_modified = s:normal_modified

" Accents are used to give parts within a section a slightly different look or
" color. Here we are defining a "red" accent, which is used by the 'readonly'
" part by default. Only the foreground colors are specified, so the background
" colors are automatically extracted from the underlying section colors. What
" this means is that regardless of which section the part is defined in, it
" will be red instead of the section's foreground color. You can also have
" multiple parts with accents within a section.
let s:palette.accents = { 'red': C('Red d', 'Shade dr') }

" Here we define the color map for ctrlp.  We check for the g:loaded_ctrlp
" variable so that related functionality is loaded iff the user is using
" ctrlp. Note that this is optional, and if you do not define ctrlp colors
" they will be chosen automatically from the existing palette.
if !get(g:, 'loaded_ctrlp', 0)
  finish
endif

let s:palette.ctrlp = airline#extensions#ctrlp#generate_color_map(
  \ C('Cyan dr',   'Shade dr'),
  \ C('Orange lr', 'Cyan dr'),
  \ C('Cyan dr',   'Orange l', 'bold')
  \)
"
" global export
let g:airline#themes#bronkow_material_dark#palette = s:palette
"
" order of section
let g:airline_section_a = airline#section#create(['branch'])
let g:airline_section_b = airline#section#create([''])
