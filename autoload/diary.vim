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
if !exists('g:diary_create')
  let g:diary_create = 'day'
endif

function! s:on_buf_read_pre()
  if stridx(expand('%:p'), g:diary_dir) == 0
    setlocal filetype=diary
  endif
endfunction

function! s:on_new_file()
  if stridx(expand('%:p'), g:diary_dir) == 0
    if exists('g:diary_template')
      execute '0read' g:diary_template
    endif
    setlocal filetype=diary
  endif
endfunction

function! s:on_buf_write_pre()
  if &ft == 'diary'
    let dir = expand('%:p:h')
    if !isdirectory(dir)
      call mkdir(dir, 'p')
    endif
  endif
endfunction

function! s:set_autocmd()
  augroup diary
    autocmd!
    autocmd BufReadPre * call s:on_buf_read_pre()
    autocmd BufNewFile * call s:on_new_file()
    autocmd BufWritePre * call s:on_buf_write_pre()
  augroup END
  let s:autocmd = 1
endfunction

function! s:echo_error(message)
  echohl ErrorMsg
  echom a:message
  echohl None
endfunction

function! s:open_diary(date)
  if g:diary_create == 'day'
    let n = 2
  elseif g:diary_create == 'month'
    let n = 1
  else
    call s:echo_error('[diary] unknown creation mode: ' . g:diary_create)
    return
  endif
  execute 'edit' join([g:diary_dir] + a:date[:n], '/')
endfunction

function! diary#open(...)
  if !exists('s:autocmd')
    call s:set_autocmd()
  end
  if a:0 == 1
    let date = split(a:1, '[-/]')
    if (g:diary_create == 'day' && len(date) != 3) || (g:diary_create == 'month' && len(date) != 2)
      call s:echo_error('[diary] invalid date: ' . a:1)
      return
    endif
  else
    let date = split(strftime('%Y-%m-%d', localtime()), '-')
  endif
  call s:open_diary(date)
endfunction