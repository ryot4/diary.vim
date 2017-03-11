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

let s:formatter = {}

function! s:formatter.parse(s)
  let l = map(split(a:s, '[/\- ]'), 'str2nr(v:val)')
  if len(l) >= 2
    return  { 'y': l[0], 'm': l[1] }
  elseif len(l) == 1
    return { 'y': strftime('%Y'), 'm': l[0] }
  else
    return {}
  endif
endfunction

function! s:formatter.to_path(date)
  return printf('%d/%02d', a:date.y, a:date.m)
endfunction

function! s:formatter.to_date(path)
  let l = map(split(a:path, '/'), 'str2nr(v:val)')
  return { 'y': l[0], 'm': l[1] }
endfunction

function! diary#path#formatter#monthly#get()
  return s:formatter
endfunction
