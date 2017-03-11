" diary.vim - A vim plugin to keep a diary
"
" Copyright 2017 FUJII Ryota <rf@readonly.xyz>
"
" Permission is hereby granted, free of charge, to any person obtaining a copy
" of this software and associated documentation files (the "Software"), to
" deal in the Software without restriction, including without limitation the
" rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
" sell copies of the Software, and to permit persons to whom the Software is
" furnished to do so, subject to the following conditions:
"
" The above copyright notice and this permission notice shall be included in
" all copies or substantial portions of the Software.
"
" THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
" IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
" FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
" AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
" LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
" FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
" IN THE SOFTWARE.

" default settings
if !exists('g:diary_dir')
  let g:diary_dir = expand('~/diary')
endif
if !exists('g:diary_path_format')
  let g:diary_path_format = 'daily'
endif

function! s:error(message)
  echohl ErrorMsg
  echom '[diary] ' . a:message
  echohl None
endfunction

function! s:is_diary_file()
  return (&ft == 'diary') || (stridx(expand('%:p'), g:diary_dir) == 0)
endfunction

function! s:on_new_file()
  if s:is_diary_file()
    if exists('g:diary_template')
      execute '0read' g:diary_template
    endif
  endif
endfunction

function! s:on_buf_write_pre()
  if s:is_diary_file()
    let dir = expand('%:p:h')
    if !isdirectory(dir)
      call mkdir(dir, 'p')
    endif
  endif
endfunction

function! s:set_autocmd()
  augroup diary
    autocmd!
    autocmd BufNewFile * call s:on_new_file()
    autocmd BufWritePre * call s:on_buf_write_pre()
  augroup END
  let s:autocmd = 1
endfunction

function! s:open_diary(date)
  if &modified == 1
    call s:error('There are unsaved changes')
    return
  endif
  let formatter = diary#path#formatter(g:diary_path_format)
  bd
  execute 'edit' g:diary_dir . '/' . formatter.to_path(a:date)
endfunction

function! diary#open(...)
  if !exists('s:autocmd')
    call s:set_autocmd()
  end
  if a:0 == 1
    let formatter = diary#path#formatter(g:diary_path_format)
    let date = formatter.parse(a:1)
    if !diary#date#valid(date)
      call s:error('invalid date: ' . a:1)
      return
    endif
  else
    let date = diary#date#current()
  endif
  call s:open_diary(date)
endfunction

function! s:date_of_current_file()
  if s:is_diary_file()
    let formatter = diary#path#formatter(g:diary_path_format)
    return formatter.to_date(substitute(expand('%:p'), g:diary_dir . '/', '', ''))
  else
    return {}
  endif
endfunction

function! diary#prev()
  call s:open_diary(diary#date#prev(s:date_of_current_file()))
endfunction

function! diary#next()
  call s:open_diary(diary#date#next(s:date_of_current_file()))
endfunction
