# Powershell Helper Scripts

Microsoft's Powershell is the default CLI on Windows 10 and Windows 11. After daily driving Windows and Linux for a long time, I feel powershell still has a lot of ground to cover when compared to the default shells on Linux like **bash** or **zsh**.

This repository has Powershell scripts which are **generated using AI Coding tools like Gemini and Claude** to help Windows users close the gap between bash and powershell.

## How install scripts on your Machine

1. Clone the Repo or Download the `scripts` folder on your machine

2. Open your PowerShell terminal and find your profile path by running:
```powershell
$PROFILE.CurrentUserAllHosts
```
3. If the profile file does not exist yet, create it using:
```powershell
New-Item -ItemType File -Path $PROFILE.CurrentUserAllHosts -Force
```

4. Open the profile file in your preferred text editor (Eg. Notepad)
```powershell
notepad $PROFILE.CurrentUserAllHosts
```

5. Append the following snippet to the file to automatically load all scripts in the repository on startup (make sure to replace the path with your actual local repository path):
```powershell
$ScriptsFolder = "C:\path\to\Powershell-Helper-Scripts\scripts"

if (Test-Path $ScriptsFolder) {
    Get-ChildItem -Path $ScriptsFolder -Filter *.ps1 | ForEach-Object {
        . $_.FullName
    }
}
```

6. Restart your PowerShell terminal or reload the profile manually to apply the changes:
```powershell
. $PROFILE.CurrentUserAllHosts
```

> [!NOTE]
> If scripts fail to load, you may need to adjust your execution policy to allow local scripts to run. You can do this by running PowerShell as an Administrator and executing: `Set-ExecutionPolicy RemoteSigned -Scope CurrentUser`
