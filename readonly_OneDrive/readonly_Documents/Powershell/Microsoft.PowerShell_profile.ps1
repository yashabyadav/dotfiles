
#f45873b3-b655-43a6-b217-97c00aa0db58 PowerToys CommandNotFound module

#Import-Module -Name Microsoft.WinGet.CommandNotFound
#f45873b3-b655-43a6-b217-97c00aa0db58
#function prompt {
#$p = Split-Path -leaf -path (Get-Location)
#“@$p ~> “
#}

function prompt {
    $currentDir = Split-Path -Leaf (Get-Location)
    return "$currentDir> "
}

function fznv {
	$file = Get-ChildItem -Path . -Recurse -File | Select-Object -ExpandProperty FullName | fzf
	if ($file) { nvim $file }
}

#oh-my-posh.exe init pwsh --config "C:\Users\yasha\Documents\Windows Customization\oh-my-posh-configs\chips.omp.json"| Invoke-Expression
#oh-my-posh.exe init pwsh --config "C:\Users\yasha\Documents\Windows Customization\oh-my-posh-configs\dia4m0nd.omp.json"| Invoke-Expression
oh-my-posh.exe init pwsh --config "C:\Users\yasha\Documents\Windows Customization\oh-my-posh-configs\emodipt-extend.omp.json"| Invoke-Expression
