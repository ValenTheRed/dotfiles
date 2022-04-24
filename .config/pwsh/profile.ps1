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
$completionScripts = @("~/_fd.ps1", "~/_rg.ps1", "~/_dotnet.ps1")
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

function dotgit {
    $dotfilesDir = "D:/Github/dotfiles/"
    git --git-dir="$dotfilesDir" --work-tree="$env:HOME" @args
}

function gs { git status }
function glo { git log --oneline }
function ggr { git log --graph --all --decorate --color --oneline }
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
    param($Path)

    if ($Path) {
        explorer "$Path"
    } else {
        explorer .
    }
}
# }}}

# {{{ Prompt
function Prompt {
    $origLastExitCode = $LASTEXITCODE
    $dirSep = [IO.Path]::DirectorySeparatorChar
    $pathComponents = $PWD.Path.Split($dirSep)
    $displayPath = if ($pathComponents.Count -lt 3) {
      $PWD.Path
    } else {
      '…{0}{1}' -f $dirSep, ($pathComponents[-2,-1] -join $dirSep)
    }

    $prompt = ""

    $prompt += Write-Prompt "$displayPath" -ForegroundColor LightSkyBlue #CornflowerBlue #0xadefd1 # MINT
    $prompt += Write-VcsStatus
    if ($PsDebugContext) {
        $prompt += $GitPromptSettings.DefaultPromptDebug
    }
    if ($origLastExitCode) {
        $prompt += Write-Prompt "!$($origLastExitCode)" -ForegroundColor Azure
    }
    $prompt += Write-Prompt "$('❱' * ($nestedPromptLevel + 1)) " -ForegroundColor Chartreuse

    $LASTEXITCODE = $origLastExitCode
    if ($prompt) { "$prompt" } else { "❱ " }
}

# }}}

# vim: set fdm=marker:
