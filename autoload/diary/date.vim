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

function! s:is_leap(year)
  return ((a:year % 4) == 0 && (a:year % 100) != 0) || (a:year % 400) == 0
endfunction

function! s:days_in_month(year, month)
  let feb_days = s:is_leap(a:year) ? 29 : 28
  let days = [ 0, 31, feb_days, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31 ]
  return days[a:month]
endfunction

function! diary#date#valid(date)
  if has_key(a:date, 'y')
    let y = a:date.y
    if has_key(a:date, 'm')
      let m = a:date.m
      if m < 1 || m > 12
        return 0
      endif
      if has_key(a:date, 'd')
        let d = a:date.d
        if d < 1 || d > s:days_in_month(y, m)
          return 0
        endif
      endif
    endif
    return 1
  else
    return 0
  endif
endfunction

function! diary#date#complete(date)
  if !has_key(a:date, 'y')
    let a:date.y = str2nr(strftime('%Y'))
  endif
  if !has_key(a:date, 'm')
    let a:date.m = str2nr(strftime('%m'))
  endif
  if !has_key(a:date, 'd')
    let a:date.d = str2nr(strftime('%d'))
  endif
  return a:date
endfunction

function! diary#date#current()
  return diary#date#complete({})
endfunction

function! s:prev_year(date)
  let a:date.y -= 1
  return a:date
endfunction

function! s:next_year(date)
  let a:date.y += 1
  return a:date
endfunction

function! s:prev_month(date)
  let prev = a:date
  let prev.m -= 1
  if prev.m < 1
    let prev = s:prev_year(prev)
    let prev.m = 12
  endif
  return prev
endfunction

function! s:next_month(date)
  let next = a:date
  let next.m += 1
  if next.m > 12
    let next = s:next_year(next)
    let next.m = 1
  endif
  return next
endfunction

function! s:prev_day(date)
  let prev = a:date
  let prev.d -= 1
  if prev.d < 1
    let prev = s:prev_month(prev)
    let prev.d = s:days_in_month(prev.y, prev.m)
  endif
  return prev
endfunction

function! s:next_day(date)
  let next = a:date
  let next.d += 1
  if next.d > s:days_in_month(next.y, next.m)
    let next = s:next_month(next)
    let next.d = 1
  endif
  return next
endfunction

function! diary#date#prev(date)
  if has_key(a:date, 'y')
    if has_key(a:date, 'm')
      if has_key(a:date, 'd')
        return s:prev_day(a:date)
      else
        return s:prev_month(a:date)
      endif
    else
      return s:prev_year(a:date)
    endif
  else
    return {}
  endif
endfunction

function! diary#date#next(date)
  if has_key(a:date, 'y')
    if has_key(a:date, 'm')
      if has_key(a:date, 'd')
        return s:next_day(a:date)
      else
        return s:next_month(a:date)
      endif
    else
      return s:next_year(a:date)
    endif
  else
    return {}
  endif
endfunction
