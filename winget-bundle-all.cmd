curl --remote-name https://raw.githubusercontent.com/kurtbahartr/windows-configs/master/winget-bundle.cmd
start /wait cmd /C winget-bundle.cmd
del winget-bundle.cmd
curl --remote-name https://raw.githubusercontent.com/kurtbahartr/windows-configs/master/winget-bundle-optional.cmd
start /wait cmd /C winget-bundle.cmd
del winget-bundle.cmd