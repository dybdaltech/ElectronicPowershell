param (
    [Parameter(Mandatory = $false)]
    [string] $command = '1',
    [string] $JsonUser
)
$parms = @{
    ErrorAction = "stop"
}

if( ! [string]::IsNullOrEmpty($JsonUser)) {
    $hash = $JsonUser | ConvertFrom-Json
    $hash.pass = $hash.pass | ConvertTo-SecureString
    $parms.Credential = [PSCredential]::new($hash.user, $hash.pass)
}

try {
    switch ($command) {
        "1"
        {
            Start-process powershell @parms -ArgumentList "/c dsa.msc"
        }
        "2"
        {
            Start-Process powershell @parms  -ArgumentList "/c gpmc.msc"
        }
    }
} catch [System.Management.Automation.RuntimeException] {
    $myErr = @{
        Message = $_.Exception.Message
        Type = $_FullyQualifiedErrorID
    }
    $out = @{ Error = $myErr}
}

ConvertTo-Json $out -Compress