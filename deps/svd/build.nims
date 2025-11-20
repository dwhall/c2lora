proc doExec(cmd: string) =
  let prefix = when defined(windows): "cmd /C " else: ""
  exec(prefix & cmd)

let dirSep = when defined(windows): "\\" else: "/"
let targetDir = thisDir() & dirSep & "nrf52840"
let targetArtifact = targetDir & dirSep & "device.nim"

if not dirExists(targetDir) or not fileExists(targetArtifact):
  echo "Building " & targetDir
  let svdFile = thisDir() & dirSep & "nrf52840.svd"
  doExec("minisvd2nim " & svdFile & " --path=" & thisDir())

