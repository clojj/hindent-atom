{BufferedProcess} = require 'atom'
path = require 'path'

# run hindent backend
indent = (text, workingDirectory, {onComplete, onFailure}) ->

  # todo: path from plugin-config
  shpath = '/Users/jwin/Library/Haskell/bin/hindent'

  options = {}
  options.stdio = ['pipe', null, null]

  lines = []

  proc = new BufferedProcess
    command: shpath
    args: ['--style', 'fundamental']
    options: options
      #cwd: workingDirectory
    stdout: (line) ->
      console.log(line)
      lines.push(line)
    stderr: (data) ->
      errorText = data.toString()
      console.log errorText
      atom.notifications.addError 'Error', { detail: errorText, dismissable: true }

    exit: -> onComplete?(lines.join(''))

  proc.onWillThrowError ({error, handle}) ->
    atom.notifications.addError "hindent could not spawn #{shpath}",
      detail: "#{error}"
    console.error error
    onFailure?()
    handle()

  proc.process.stdin?.write(text)
  proc.process.stdin?.end()

module.exports = {
  indent
}
