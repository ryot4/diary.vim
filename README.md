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

    " This is the default.
    let g:diary_dir = expand('~/diary')

Specify how diary files are created:

    " Create a file per day. (The resulting path is like ~/diary/2017/03/05)
    " This is the default.
    let g:diary_create = 'day'

    " Create a file per month. (The resulting path is like ~/diary/2017/03)
    let g:diary_create = 'month'

Specify the template of diary files (optional):

    let g:diary_template = expand('~/diary/template')

## Usage

Open the file for today:

    :Diary

Open the file for YYYY/MM/DD (when `g:diary_create` is `day`):

    :Diary 2017/03/05

Open the file for YYYY/MM (when `g:diary_create` is `month`):

    :Diary 2017/03

Hyphen or space can be used instead of slash (`:Diary 2017 03 05`).

If the parent directory does not exist, it is automatically created when you
save the file.

## filetype

diary.vim sets `filetype` of diary files to `diary`.

## TODOs

 * Move to the next/previous day/month with `:next` and `:previous`
 * Flexible date specification
     * The year and/or the month can be omitted
     * Leading zeros can be omitted ("3/5" instead of "03/05")
     * Support for DD/MM/YYYY and MM/DD/YYYY notation
 * Searching (`grep -r word ~/diary` would be enough)

## License

diary.vim is distributed under the MIT License.
