# diary.vim

diary.vim is a Vim plugin to keep a diary.
It opens a file based on the date. That's all.

## Installation

Use a plugin manager, or copy files as follows:

    mkdir -p ~/.vim/{autoload,plugin}
    cp autoload/diary.vim ~/.vim/autoload/
    cp plugin/diary.vim ~/.vim/plugin/

## Settings

Specify the directory for diary files:

    let g:diary_dir = expand('~/diary')

Specify how diary files are created:

    " Create a file per day. (The resulting path is like ~/diary/2017/01/23)
    " This is the default.
    let g:diary_create = 'day'
    " Create a file per month. (The resulting path is like ~/diary/2017/01)
    let g:diary_create = 'month'

Specify the template of diary files:

    let g:diary_template = expand('~/diary/template')

## Usage

Open the entry for today:

    :Diary

Open the entry for the specific date (`YYYY-MM-DD` and `YYYY/MM/DD` is
currently supported):

    :Diary 2017-03-05
    :Diary 2017/03/05

If the directory does not exist, it is automatically created when you save the
entry.

## filetype

diary.vim sets `filetype` of diary files to `diary`.

## TODOs

 * Move to the next/previous day/month with `:next` and `:previous`
 * Flexible date specification (the year and/or the month can be omitted)
 * Searching (`grep -r word ~/diary` would be enough)

## License

diary.vim is distributed under the MIT License.
