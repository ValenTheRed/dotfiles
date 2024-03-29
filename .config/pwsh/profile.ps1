# {{{ Modules
$importModules = @("posh-git", "PSFzf")
foreach ($mod in $importModules) {
    if (Get-Module -ListAvailable -Name $mod) {
        Import-Module $mod
    } else {
        Write-Host "cannot find $mod"
    }
}

# if have posh-git
if (Get-Module -ListAvailable -Name "posh-git") {
    $GitPromptSettings.BranchColor.ForegroundColor = 'Salmon'
    $GitPromptSettings.BeforeStatus.ForegroundColor = 'Gray'
    $GitPromptSettings.AfterStatus.ForegroundColor =  'Gray'
}
# }}}

# {{{ Completion
$completionScripts = @("~/_fd.ps1", "~/_rg.ps1")#, "~/_dotnet.ps1")
foreach ($script in $completionScripts) {
    if (Test-Path $script) {
        & $script
    } else {
        Write-Host "cannot find completion script $script"
    }
}
# }}}

# {{{ PSReadline
Set-PSReadlineOption -Editmode vi -BellStyle None
Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+t' -PSReadlineChordReverseHistory 'Ctrl+r'
# (prompt)> neo<Up/Down> #complete for commands starting with `neo` in history
Set-PSReadLineKeyHandler -Chord Ctrl-k,UpArrow -Function HistorySearchBackward
Set-PSReadLineKeyHandler -Chord Ctrl-j,DownArrow -Function HistorySearchForward
Set-PSReadLineKeyHandler -Chord Ctrl-w -Function BackwardDeleteWord
# }}}

# {{{ Aliases
Set-alias -Name gh -Value Get-Help
Set-alias -Name fvim -Value 'C:/Software/FVim/FVim.exe'

function dot {
    $dotfilesDir = "F:/Github/dotfiles/"
    git --git-dir="$dotfilesDir" --work-tree="$env:HOME" @args
}

function vi { nvim @args }

function es { eza --icons --group-directories-first @args }
function ea { eza --icons -a --group-directories-first @args }
function el { eza --icons -la --group-directories-first @args }

# }}}

# {{{ Functions
function vact {
    # vact activates python virtual environment in a directory

    # Set-alias -Name vact -Value ./venvs/Scripts/Activate.ps1
    $paths = @("venvs", ".venvs", "venv", ".venv", "virenv", "virenvs")
    $path = ""
    foreach ($p in $paths) {
        if (Test-Path $p) {
            $path = $p
            break
        }
    }
    if ($path -eq "") {
        Write-Host "cannot find any of ($paths)"
        return
    }
    & "./$path/Scripts/Activate.ps1"
}

function vshell {
    # vshell activates the Visual Studio developer shell for powershell which
    # brings all the Visual Studio tools into %PATH%
    # Ref: https://intellitect.com/enter-vsdevshell-powershell/

    # to remove alias Vsdev
    # Set-alias -Name Vsdev -Value 'C:\Program Files (x86)\Microsoft Visual Studio\2019\Community\Common7\Tools\Launch-VsDevShell.ps1'
    $visualStudioInstallRoot = "C:\Program Files (x86)\Microsoft Visual Studio"
    $devShell = & "$visualStudioInstallRoot\Installer\vswhere.exe" -latest -find **\Microsoft.VisualStudio.DevShell.dll
    $installPath = & "$visualStudioInstallRoot\Installer\vswhere.exe" -property installationpath
    if (Get-Module -ListAvailable -Name $devShell) {
        Import-Module $devShell
    } else {
        Write-Host "Cannot find module for commandlet Enter-VsDevShell"
        return
    }
    Enter-VsDevShell -VsInstallPath "$installPath" -DevCmdArguments '-arch=x64' -SkipAutomaticLocation
}

function opex {
    if ($args.Length -eq 0) {
        explorer .
    } else {
        explorer @args
    }
}
# }}}

# {{{ Prompt
function Prompt {
    $origLastExitCode = $LASTEXITCODE

    # If number of characters in $PWD (excluding separator) exceeds some $MAX,
    # $PWD is shortened
    $dirSep = [IO.Path]::DirectorySeparatorChar
    $pathComponents = $PWD.Path.Split($dirSep)
    $i = -1
    for ($len = $pathComponents[$i].Length; $i -gt -$pathComponents.Length; ) {
        $len += $pathComponents[$i - 1].Length
        # 36 is the my max number of characters
        if ($len -le 36) {
            $i--
        } else {
            break
        }
    }
    $displayPath = if ($i -eq -$pathComponents.Length) {
        $PWD.Path
    } else {
        '…{0}{1}' -f $dirSep, ($pathComponents[$i..-1] -join $dirSep)
    }

    $d = (Get-Date).Hour
    if (($d -ge 0 -and $d -le 6) -or ($d -ge 19 -and $d -le 24)) {
        $date = Get-Date -format 'hh:mm ⏾'
    } else {
        $date = Get-Date -format '羽hh:mm'
    }
    $prompt = Write-Prompt $date -ForegroundColor Black -BackgroundColor Thistle
    $prompt += " "

    $prompt += Write-Prompt $displayPath -ForegroundColor LightSkyBlue #CornflowerBlue #0xadefd1 # MINT
    if (Write-VcsStatus -ne "") {
        $prompt += Write-VcsStatus
        $prompt += "`n"
    }
    if ($PsDebugContext) {
        $prompt += $GitPromptSettings.DefaultPromptDebug
    }
    if ($origLastExitCode) {
        $prompt += Write-Prompt "!$origLastExitCode" -ForegroundColor Azure
    }
    $prompt += Write-Prompt "$('❱' * ($nestedPromptLevel + 1)) " -ForegroundColor Chartreuse

    $LASTEXITCODE = $origLastExitCode
    if ($prompt) { $prompt } else { "❱ " }
}

# }}}

# vim: set fdm=marker fdl=0:
