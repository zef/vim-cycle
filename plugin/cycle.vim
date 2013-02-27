" cycle.vim - Toggle between related words

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" language specific overrides:
call cycle#AddCycleGroup('ruby', ['class', 'module'])
call cycle#AddCycleGroup(['ruby', 'eruby', 'perl'], ['else', 'elsif'])
call cycle#AddCycleGroup('python', ['else', 'elif'])

if !exists("g:cycle_no_mappings") || !g:cycle_no_mappings
  nmap  <silent> <C-A> :<C-U>call cycle#CycleNext()<CR>
  nmap  <silent> <C-X> :<C-U>call cycle#CyclePrevious()<CR>
endif

