" cycle.vim - Toggle between related words

" if exists("g:loaded_cycle")
"   finish
" endif
" let g:loaded_cycle = 1


" TODO: 
"
" See endwise.vim for an example of this.
" 1. Might want to use autocmd FileType to define options based on filetype
"
" 2. The ability to handle pairs: quotes, brackets, html tags, etc.
" Might be able to use % for some of these things
"
" 3. operate on non-lowercase text and retain case
" 
" 4. Put cursor back at beginning of word if it started there
"
" 5. allow work on substrings - 8px to 8%
"

" just for development
" let s:options = []

let s:options = [
  \ ['==', '!='],
  \ ['&&', '||'],
  \ ['and', 'or'],
  \ ['if', 'unless'],
  \ ['true', 'false'],
  \ ['YES', 'NO'],
\]

" CSS/Sass/JavaScript/HTML
let s:options = s:options + [
  \ ['px', '%', 'em'],
  \ ['left', 'right'],
  \ ['top', 'bottom'],
  \ ['margin', 'padding'],
  \ ['height', 'width'],
  \ ['div', 'p', 'span'],
  \ ['h1', 'h2', 'h3'],
  \ ['png', 'jpg', 'gif'],
\]


function! AddCycleGroup(group)
  call add(s:options, a:group)
endfunction


function! s:Cycle(word, direction)
  let groups = filter(copy(s:options), "index(v:val, a:word) >= 0")

  " echo(string(groups)) 

  if empty(groups)
    if a:direction == 1
      exe "norm! \<C-A>"
    else
      exe "norm! \<C-X>"
    endif
  else
    " Currently doesn't account for situations where
    " there is more than one group
    let group = groups[0]
    let index = index(group, a:word) + a:direction
   
		let max_index = (len(group) - 1)

		if index > max_index
			let index = 0
		endif

		exe "normal ciw".group[index]
  endif

endfunction

call AddCycleGroup(['one', 'two', 'three'])

" Ruby
call AddCycleGroup(['else', 'elsif'])

" three
" padding
" &&
" ==
" left
"

" if !hasmapto('<Plug>CycleCycle')
"   map <unique> <Leader>c <Plug>CycleCycle
" endif

nnoremap <silent> <Plug>CycleNext   :<C-U>call <SID>Cycle(expand("<cword>"), 1)<CR>
nnoremap <silent> <Plug>CyclePrevious :<C-U>call <SID>Cycle(expand("<cword>"), -1)<CR>
" vnoremap <silent> <Plug>CycleUp   :<C-U>call <SID>incrementvisual(v:count1)<CR>
" vnoremap <silent> <Plug>CycleDown :<C-U>call <SID>incrementvisual(-v:count1)<CR>

if !exists("g:cycle_no_mappings") || !g:cyle_no_mappings
    nmap  <C-A>     <Plug>CycleNext
    nmap  <C-X>     <Plug>CyclePrevious
    " xmap  <C-A>     <Plug>CycleUp
    " xmap  <C-X>     <Plug>CycleDown
endif


" https://github.com/aklt/vim-substitute
" http://stackoverflow.com/questions/48642/how-do-i-specify-the-word-under-the-cursor-on-vims-commandline
" 
"
"
