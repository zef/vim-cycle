" cycle.vim - Toggle between related words

" if exists("g:loaded_cycle")
"   finish
" endif
" let g:loaded_cycle = 1

let s:options = {}

let s:options['global'] = [
  \ ['==', '!='],
  \ ['_', '-'],
  \ [' + ', ' - '],
  \ ['-=', '+='],
  \ ['&&', '||'],
  \ ['and', 'or'],
  \ ['if', 'unless'],
  \ ['true', 'false'],
  \ ['YES', 'NO'],
  \ ['yes', 'no'],
  \ ['on', 'off'],
  \ ['running', 'stopped'],
  \ ['first', 'last'],
  \ ['else', 'else if'],
\]

" css/sass/javascript/html
let s:options['global'] = s:options['global'] + [
  \ ['div', 'p', 'span'],
  \ ['max', 'min'],
  \ ['ul', 'ol'],
  \ ['class', 'id'],
  \ ['px', '%', 'em'],
  \ ['left', 'right'],
  \ ['top', 'bottom'],
  \ ['margin', 'padding'],
  \ ['height', 'width'],
  \ ['absolute', 'relative'],
  \ ['h1', 'h2', 'h3'],
  \ ['png', 'jpg', 'gif'],
  \ ['linear', 'radial'],
  \ ['horizontal', 'vertical'],
  \ ['show', 'hide'],
  \ ['mouseover', 'mouseout'],
  \ ['mouseenter', 'mouseleave'],
  \ ['add', 'remove'],
  \ ['up', 'down'],
  \ ['before', 'after'],
  \ ['text', 'html'],
  \ ['slow', 'fast'],
  \ ['small', 'large'],
  \ ['even', 'odd'],
  \ ['inside', 'outside'],
  \ ['push', 'pull'],
\]

" ruby/eruby
let s:options['global'] = s:options['global'] + [
  \ ['include', 'require'],
  \ ['Time', 'Date'],
  \ ['present', 'blank'],
  \ ['while', 'until'],
  \ ['only', 'except'],
  \ ['create', 'update'],
  \ ['new', 'edit'],
  \ ['get', 'post', 'put', 'patch']
\]

" Takes one or two arguments:
"
" group
" - or -
" filetype(s), group
function! AddCycleGroup(filetypes_or_group, ...)
  if a:0
    let group = a:1

    " type(['list']) == 3
    " type('string') == 1
    if type(a:filetypes_or_group) == 1
      let filetypes = [a:filetypes_or_group]
    else
      let filetypes = a:filetypes_or_group
    end
  else
    let group     = a:filetypes_or_group
    let filetypes = ['global']
  endif

  for type in filetypes
    if !has_key(s:options, type)
      let s:options[type] = []
    endif

    call add(s:options[type], group)
  endfor
endfunction

function! s:Cycle(direction)
  let filetype = &ft
  let match = []

  if has_key(s:options, filetype)
    let match = s:matchInList(s:options[filetype])
  endif

  if empty(match)
    let match = s:matchInList(s:options['global'])
  endif

  if empty(match)
    " if exists("g:loaded_speeddating")
    "   echo 'speed dating!'
    " else
    "   echo 'no speed dating'
    " endif

    if a:direction == 1
      exe "norm! " . v:count1 . "\<C-A>"
    else
      exe "norm! " . v:count1 . "\<C-X>"
    endif
  else
    let [group, start, end, string] = match

    let index = index(group, string) + a:direction
		let max_index = (len(group) - 1)

		if index > max_index
			let index = 0
		endif

    call s:replaceinline(start,end,group[index])
  endif

endfunction

" returns the following list if a match is found:
" [group, start, end, string]
"
" returns [] if no match is found
function! s:matchInList(list)
  " reverse the list so the most recently defined matches are used
  for group in reverse(copy(a:list))
    " We must iterate each group with the longest values first.
    " This covers a case like ['else', 'else if'] where the
    " first will match successfuly even if the second could
    " be matched. Checking for the longest values first
    " ensures that the most specific match will be returned
    for item in sort(copy(group), "s:sorterByLength")
      let match = s:findinline(item)
      if match[0] >= 0
        return [group] + match
      endif
    endfor
  endfor

  return []
endfunction

function! s:sorterByLength(item, other)
  return len(a:other) - len(a:item)
endfunction

" pulled the following out of speeddating.vim
" modified slightly
function! s:findatoffset(string,pattern,offset)
    let line = a:string
    let curpos = 0
    let offset = a:offset
    while strpart(line,offset,1) == " "
        let offset += 1
    endwhile
    let [start,end,string] = s:match(line,a:pattern,curpos,0)
    while start >= 0
        if offset >= start && offset < end
            break
        endif
        let curpos = start + 1
        let [start,end,string] = s:match(line,a:pattern,curpos,0)
    endwhile
    return [start,end,string]
endfunction

function! s:findinline(pattern)
    return s:findatoffset(getline('.'),a:pattern,col('.')-1)
endfunction

function! s:replaceinline(start,end,new)
    let line = getline('.')
    let before_text = strpart(line,0,a:start)
    let after_text = strpart(line,a:end)
    " If this generates a warning it will be attached to an ugly backtrace.
    " No warning at all is preferable to that.
    silent call setline('.',before_text.a:new.after_text)
    call setpos("'[",[0,line('.'),strlen(before_text)+1,0])
    call setpos("']",[0,line('.'),a:start+strlen(a:new),0])
endfunction

function! s:match(...)
    let start   = call("match",a:000)
    let end     = call("matchend",a:000)
    let matches = call("matchlist",a:000)
    if empty(matches)
      let string = ''
    else
      let string = matches[0]
    endif
    return [start, end, string]
endfunction
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" language specific overrides:
call AddCycleGroup('ruby', ['class', 'module'])
call AddCycleGroup(['ruby', 'eruby', 'perl'], ['else', 'elsif'])
call AddCycleGroup('python', ['else', 'elif'])

" Swift
call AddCycleGroup('swift', ['let', 'var'])
call AddCycleGroup('swift', ['open', 'public', 'internal', 'fileprivate', 'private'])
call AddCycleGroup('swift', ['class', 'struct', 'enum', 'protocol', 'extension'])
call AddCycleGroup('swift', ['set', 'get'])

nnoremap <silent> <Plug>CycleNext     :<C-U>call <SID>Cycle(1)<CR>
nnoremap <silent> <Plug>CyclePrevious :<C-U>call <SID>Cycle(-1)<CR>

if !exists("g:cycle_no_mappings") || !g:cycle_no_mappings
  nmap  <C-A>     <Plug>CycleNext
  nmap  <C-X>     <Plug>CyclePrevious
endif

