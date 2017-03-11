# diary.vim

diary.vim is a Vim plugin to keep a diary.

It opens a file based on the date. That's all.

## Installation

Use a plugin manager, or copy files as follows:

    mkdir -p ~/.vim/{autoload,plugin}
    cp autoload/diary.vim ~/.vim/autoload/
    cp plugin/diary.vim ~/.vim/plugin/

## Basic configuration

First, specify the directory for diary files in your vimrc:

    " This is the default.
    let g:diary_dir = expand('~/diary')

You can specify the template for newly created files (optional):

    let g:diary_template = expand('~/diary/template')

## Usage

Open the file for today:

    :Diary

Open the file for March 5, 2017:

    :Diary 2017/3/5

If some part of the date is omitted, the current date is used.
The following command opens the file for the fifth day in the current month.

    :Diary 5

The following command opens the file for March 5 in the current year.

    :Diary 3/5

If the parent directory does not exist, it is automatically created when you
save the file.

## Path format

By default, diary.vim creates a file per day (e.g. ~/diary/2017/03/05).
This behavior can be changed by specifying the path format.

    " Create a file per day
    " This is the default.
    let g:diary_path_format = 'daily'

    " Create a file per month (e.g. ~/diary/2017/03)
    let g:diary_path_format = 'monthly'

Note that the date passed to `:Diary` command is interpreted differently
depending on the path format. For example, in March 2017, `:Diary 5` opens

 * `~/diary/2017/03/05` if the formatter is `daily`.
 * `~/diary/2017/05` if the formatter is `monthly`.

## filetype

diary.vim sets `filetype` of diary files to `diary`.

## TODOs

 * Move to the next/previous day/month with `:n` and `:N`
 * Support for DD/MM/YYYY and MM/DD/YYYY notation
 * More flexible file path (flat directory structure, file extension)
 * Searching (`grep -r word-to-search ~/diary` would be enough)

## License

diary.vim is distributed under the MIT License.
