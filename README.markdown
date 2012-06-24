Cycle.vim
=========

A Vim plugin that allows you to toggle between pairs or lists of related words.
Use by placing your cursor on a word, like `left`, and press `control-a`.
The word will be replaced with `right`.
The default mappings are the same as those with which you can increment and
decrement a number under the cursor: `<C-A>` and `<C-X>`, respectively.

Check out [the code](https://github.com/zef/vim-cycle/blob/master/plugin/cycle.vim)
to see what cycle groups are included by default.

Customization
-------------

You can add your own word groups:

    call AddCycleGroup(['one', 'two', 'three'])

To deal with conflicts, Cycle.vim also supports adding groups that are specific
to a certain filetype:

    call AddCycleGroup('ruby', ['class', 'module'])
    call AddCycleGroup('python', ['else', 'elif'])

When multiple groups define the same word, groups belonging to specific
filetypes will be used instead of global groups. This is useful in the cases
above, since in HTML we would want `class` to cycle with `id` and Python uses
`elif` while some other languages use `else if` or `elsif`.

Providing a list of filetypes is also supported:

    call AddCycleGroup(['ruby', 'eruby', 'perl'], ['else', 'elsif'])

However, if there are no conflicting cases it is preferable to define all cycle
groups in the global namespace, using filetype-specific groups only in case of
conflict.

Matches are evaluated in reverse order, so whatever has been defined most
recently will take precedence over groups defined previously. Keep this in mind
when defining new cycle groups to make sure broad definitions are not matched
when they are not desired.


Todo
----

- The ability to handle pairs: quotes, brackets, html tags, etc.
- Operate on non-lowercase text and retain case
- Put cursor back at beginning of word if it started there

Bugs
----

- Does not work with speeddating.vim - currently won't work if speeddating is
  installed.

