utilIndentHaskell = require './util-indent-haskell'

module.exports = Indent =
  indentFile: (editor, format = 'haskell') ->
    [firstCursor, cursors...] = editor.getCursors().map (cursor) ->
      cursor.getBufferPosition()
    util = switch format
      when 'haskell' then utilIndentHaskell
      else throw new Error "Unknown format #{format}"
    try
      workDir = dirname(editor.getPath())
      if not statSync(workDir).isDirectory()
        workDir = '.'
    catch
      workDir = '.'
    util.indent editor.getText(), workDir,
      onComplete: (text) ->
        editor.setText(text)
        if editor.getLastCursor()?
          editor.getLastCursor().setBufferPosition firstCursor,
            autoscroll: false
          cursors.forEach (cursor) ->
            editor.addCursorAtBufferPosition cursor,
              autoscroll: false
