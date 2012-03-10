" cycle.vim - Toggle between related words

" if exists("g:loaded_cycle")
"   finish
" endif
" let g:loaded_cycle = 1

let s:options = {}

let s:options['global'] = [
  \ ['==', '!='],
  \ ['+=', '-='],
  \ ['&&', '||'],
  \ ['and', 'or'],
  \ ['if', 'unless'],
  \ ['true', 'false'],
  \ ['YES', 'NO'],
  \ ['first', 'last'],
\]

" ruby/eruby
let s:options['global'] = s:options['global'] + [
  \ ['else', 'elsif'],
  \ ['include', 'require'],
  \ ['Time', 'Date'],
  \ ['present', 'blank'],
  \ ['while', 'until'],
\]

" css/sass/javascript/html
let s:options['global'] = s:options['global'] + [
  \ ['class', 'id'],
  \ ['px', '%', 'em'],
  \ ['left', 'right'],
  \ ['top', 'bottom'],
  \ ['margin', 'padding'],
  \ ['height', 'width'],
  \ ['absolute', 'relative'],
  \ ['div', 'p', 'span'],
  \ ['h1', 'h2', 'h3'],
  \ ['png', 'jpg', 'gif'],
  \ ['linear', 'radial'],
  \ ['show', 'hide'],
  \ ['mouseover', 'mouseout'],
  \ ['mouseenter', 'mouseleave'],
\]

" Takes one or two arguments:
"
" group
" - or -
" filetype(s), group
function! AddCycleGroup(filetypes_or_group, ...)
  if a:0
    let group    = a:1
    " type(['list']) == 3
    " type('string') == 1
    if type(a:filetypes_or_group) == 1
      let filetypes = [a:filetypes_or_group]
    else
      let filetypes = a:filetypes_or_group
    end
  else
    let group    = a:filetypes_or_group
    let filetypes = ['global']
  endif

  for type in filetypes
    if !has_key(s:options, type)
      let s:options[type] = []
    endif

    call add(s:options[type], group)
  endfor
endfunction

function! s:Cycle(word, direction)
  let matches = []
  let filetype = &ft

  if has_key(s:options, filetype)
    let matches = filter(copy(s:options[filetype]), "index(v:val, a:word) >= 0")
  endif

  if empty(matches)
    let matches = filter(copy(s:options['global']), "index(v:val, a:word) >= 0")
  endif

  if empty(matches)
    " if exists("g:loaded_speeddating")
    "   echo 'speed dating!'
    " else
    "   echo 'no speed dating'
    " endif

    if a:direction == 1
      exe "norm! \<C-A>"
    else
      exe "norm! \<C-X>"
    endif
  else
    " Currently doesn't account for existence of more than one group
    let group = matches[0]
    let index = index(group, a:word) + a:direction

		let max_index = (len(group) - 1)

		if index > max_index
			let index = 0
		endif

		exe "normal ciw".group[index]
  endif

endfunction

" language specific overrides:
call AddCycleGroup('ruby', ['class', 'module'])
call AddCycleGroup('python', ['else', 'elif'])

nnoremap <silent> <Plug>CycleNext     :<C-U>call <SID>Cycle(expand("<cword>"),  1)<CR>
nnoremap <silent> <Plug>CyclePrevious :<C-U>call <SID>Cycle(expand("<cword>"), -1)<CR>

if !exists("g:cycle_no_mappings") || !g:cycle_no_mappings
  nmap  <C-A>     <Plug>CycleNext
  nmap  <C-X>     <Plug>CyclePrevious
endif

