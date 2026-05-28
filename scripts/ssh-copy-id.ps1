<#
.SYNOPSIS
    Copies the local SSH public key to a remote machine's authorized_keys file.

.DESCRIPTION
    This script mimics the behavior of the Linux 'ssh-copy-id' utility. It reads a local
    public SSH key and appends it to the '~/.ssh/authorized_keys' file on the specified
    remote host, ensuring proper directory and file permissions are set on the remote end.

.PARAMETER User
    The username for the remote SSH connection.

.PARAMETER HostName
    The hostname or IP address of the remote server.

.PARAMETER Port
    The SSH port number to connect to on the remote host. Defaults to 22.

.PARAMETER IdentityFile
    The absolute or relative path to the local public key file. Defaults to "$env:USERPROFILE\.ssh\id_rsa.pub".

.EXAMPLE
    Copy-SshId -User "admin" -HostName "192.168.1.10"

.EXAMPLE
    Copy-SshId -User "root" -HostName "server.example.com" -Port 2222 -IdentityFile "C:\Keys\custom_key.pub"
#>
function Copy-SshId {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true, Position=0)]
        [ValidateNotNullOrEmpty()]
        [string]$User,

        [Parameter(Mandatory=$true, Position=1)]
        [ValidateNotNullOrEmpty()]
        [string]$HostName,

        [Parameter(Mandatory=$false)]
        [ValidateRange(1, 65535)]
        [int]$Port = 22,

        [Parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [string]$IdentityFile = "$env:USERPROFILE\.ssh\id_rsa.pub"
    )

    # Verify the local public key exists before attempting the remote connection
    if (-not (Test-Path -Path $IdentityFile)) {
        Write-Error "Identity file not found at: $IdentityFile"
        return
    }

    # Read the public key content and remove any trailing whitespace or newlines
    $pubKey = (Get-Content -Path $IdentityFile -Raw).Trim()

    # Construct the bash command to be executed on the remote Linux/Unix host
    $remoteCommand = "mkdir -p ~/.ssh && chmod 700 ~/.ssh && echo `"$pubKey`" >> ~/.ssh/authorized_keys && chmod 600 ~/.ssh/authorized_keys"

    Write-Verbose "Connecting to $User@$HostName on port $Port..."
    
    # Execute the remote command via the native ssh client
    ssh -p $Port "$User@$HostName" $remoteCommand

    # Evaluate the exit code of the ssh process
    if ($LASTEXITCODE -eq 0) {
        Write-Host "Success! The SSH key has been added to $User@$HostName." -ForegroundColor Green
    } else {
        Write-Error "Failed to copy the SSH key to the remote host. Please check your connection and credentials."
    }
}
