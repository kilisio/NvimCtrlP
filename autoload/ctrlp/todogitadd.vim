" =============================================================================
" File: autoload/ctrlp/todogitadd.vim
" Description: Search for available sessions
" =============================================================================

" To load this extension into ctrlp, add this to your vimrc
"
"   let g:ctrlp_extensions = ['todogitadd']

" Load guard
if get(g:, 'loaded_ctrl_todogitadd', 0)
    finish
endif
let g:loaded_ctrl_todogitadd = 1

" Add settings to g:ctrlp_ext_vars
" - init      : The name of the input function
" - accept    : The name of the action function
" - enter     : called before starting ctrlp
" - exit      : called after closing ctrlp
" - opts      : called when initialising
" - lname     : The long name for the statusline
" - sname     : The short name for the statusline
" - type      : The type of matching (line, path, tabs, tabe)
" - sort      : determine sorting (enabled by default)
" - specinput : Allow special input (disabled by default)
call add(g:ctrlp_ext_vars, {
\   'init'      : 'ctrlp#todogitadd#init()',
\   'accept'    : 'ctrlp#todogitadd#accept',
\   'enter'     : 'ctrlp#todogitadd#enter()',
\   'exit'      : 'ctrlp#todogitadd#exit()',
\   'opts'      : 'ctrlp#todogitadd#opts()',
\   'lname'     : 'Select your todo list',
\   'sname'     : 'todogitadd',
\   'type'      : 'path',
\   'sort'      : 0,
\   'specinput' : 0,
\})

" Show the active sessions
" Yup, this is  the plugin 🙄
" Return: vimlist -  The list of active sessions.
"
function! ctrlp#todogitadd#init()
  let curr_dir_path = expand('%:p:h')
  let confirm_git_dir = system('git -C "' . curr_dir_path . '" rev-parse')
  let gitRootDir = substitute(system('git rev-parse --show-toplevel'), '\n$', '', '')

  if empty(confirm_git_dir)
    let flist = glob(fnameescape(gitRootDir . '/src/apps').'/*/', 1, 1)
    let flist = map(flist, "fnamemodify(v:val, ':h:t')")
    return flist
  endif
endfunction

" The action function
" Arguments:
" a:mode    The mode that has been chosen by pressing <cr> <c-v> <c-t> or <c-x>
"           the values are: 'e','v','t' and 'h' respectively.
" a:str     the selected string
"
function! ctrlp#todogitadd#accept(mode, str)
    call ctrlp#exit()
    let gitRootDir = substitute(system('git rev-parse --show-toplevel'), '\n$', '', '')
    let g:scratch_persistence_file = gitRootDir . '/src/apps/' . a:str . '/todo.txt'
    execute "Scratch"
    execute "sort"

    " call luaeval("require('todotxt-nvim').setup({ todo_file = '" . gitRootDir . "/src/apps/" . a:str . "/todo.txt' })")
    " execute "ToDoTxtCapture"
endfunction

" Do something before entering ctrlp?
function! ctrlp#todogitadd#enter()
endfunction

" Do something after exiting ctrlp?
function! ctrlp#todogitadd#exit()
endfunction

" Check options specific to this extension
function! ctrlp#todogitadd#opts()
endfunction

" Determine an ID for this extension and create a getter
let s:id = g:ctrlp_builtins + len(g:ctrlp_ext_vars)
function! ctrlp#todogitadd#id()
    return s:id
endfunction
