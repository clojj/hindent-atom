{CompositeDisposable} = require 'atom'
{indentFile} = require './binutils/indent'

module.exports = Hindent =
  subscriptions: null

  activate: (state) ->

    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable

    # Register command
    @subscriptions.add atom.commands.add 'atom-text-editor[data-grammar~="haskell"]',
      'hindent:indent-file': ({target}) -> indentFile target.getModel()

    atom.keymaps.add 'hindent',
      'atom-text-editor[data-grammar~="haskell"]':
        'ctrl-shift-i': 'hindent:indent-file'
        
  deactivate: ->
    @subscriptions.dispose()
