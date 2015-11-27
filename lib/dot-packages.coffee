{CompositeDisposable} = require 'atom'
Path = require 'path'
CSON = require 'season'

SAVE_VERSION = 0

module.exports = DotPackages =
  subscriptions: null
  saveFile = null
  saveFileVersion = null

  activate: (state) ->
    console.log('DotPackages activate')
    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable
    # Get the filepath for the safe file.
    @saveFile = Path.join(Path.dirname(atom.config.getUserConfigPath()), '.packages')

  deactivate: ->
    @writeSaveFile()
    @subscriptions.dispose()
    console.log('DotPackages deactivated')

  readSaveFile: ->
    return CSON.readFileSync(@saveFile)

  writeSaveFile: ->
    console.log('writeSaveFile')

  installPackages: ->
    savedPackages = @readSaveFile()
    existingPackages = getInstalledPackages(false, true)
    existingPackageNames = existingPackages.map (pkg) -> return pkg.name
    existingPackageNames = new Set(existingPackageNames)

    savedPackages.map (savedPackage) ->
      return if existingPackageNames.has(savedPackage.name)


  getInstalledPackages: (core, user) ->
    return [] unless core or user
    return atom.packages.getLoadedPackages().filter (pkg) ->
      return true if core and pkg.bundledPackage
      return true if user and (not pkg.bundledPackage)
      return false
