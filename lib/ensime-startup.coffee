# Download and startup of ensime server
fs = require 'fs'
path = require 'path'
_ = require 'lodash'

Promise = require 'bluebird'
ensimeClient = require ('ensime-client')

{packageDir, withSbt, mkClasspathFileName} = require('./utils')
{parseDotEnsime} = ensimeClient.dotEnsimeUtils
{startServerFromDotEnsimeCP, startServerFromAssemblyJar, clientStarterFromServerStarter} = ensimeClient

# Start ensime server. If classpath file is out of date, make an update first
# (project: DotEnsime): Promise<ChildProcess>
startEnsimeServer = (parsedDotEnsime) ->
  if not fs.existsSync(parsedDotEnsime.cacheDir)
    fs.mkdirSync(parsedDotEnsime.cacheDir)
  
  ensimeServerFlags = atom.config.get('Ensime.ensimeServerFlags')
  
  atom.notifications.addInfo("Starting Ensime server…")
  
  assemblyJar = atom.config.get('Ensime.assemblyJar')
  if(assemblyJar && fs.existsSync(assemblyJar))
    Promise.resolve(startServerFromAssemblyJar(assemblyJar, parsedDotEnsime, ensimeServerVersion, ensimeServerFlags))
  else
    startServerFromDotEnsimeCP(parsedDotEnsime, ensimeServerFlags)
  

module.exports =
  startClient: clientStarterFromServerStarter(startEnsimeServer)
