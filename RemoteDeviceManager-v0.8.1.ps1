Set-ExecutionPolicy Bypass -Scope Process

Add-Type -AssemblyName System.Windows.Forms
[System.Windows.Forms.Application]::EnableVisualStyles()

$Form                            = New-Object system.Windows.Forms.Form
#$Form.ClientSize                 = '625,275'
$Form.width                      = '655'
$Form.Height                     = '315'
$Form.text                       = "Remote Device Manager"
$Form.TopMost                    = $false

$compNameTxtbox                  = New-Object system.Windows.Forms.TextBox
$compNameTxtbox.multiline        = $false
$compNameTxtbox.width            = 307
$compNameTxtbox.height           = 20
$compNameTxtbox.location         = New-Object System.Drawing.Point(163,29)
$compNameTxtbox.Font             = 'Microsoft Sans Serif,10'

$Label1                          = New-Object system.Windows.Forms.Label
$Label1.text                     = "Computer Name"
$Label1.AutoSize                 = $true
$Label1.width                    = 25
$Label1.height                   = 10
$Label1.location                 = New-Object System.Drawing.Point(29,29)
$Label1.Font                     = 'Microsoft Sans Serif,10'

$result                          = New-Object system.Windows.Forms.TextBox
$result.multiline                = $true
$result.width                    = 303
$result.height                   = 75
$result.location                 = New-Object System.Drawing.Point(166,67)
$result.Font                     = 'Microsoft Sans Serif,10'

$resultName                      = New-Object system.Windows.Forms.TextBox
$resultName.multiline            = $true
$resultName.width                = 303
$resultName.height               = 75
$resultName.location             = New-Object System.Drawing.Point(166,147)
$resultName.Font                 = 'Microsoft Sans Serif,10'

$pingButton                      = New-Object system.Windows.Forms.Button
$pingButton.text                 = "Ping"
$pingButton.width                = 102
$pingButton.height               = 30
$pingButton.location             = New-Object System.Drawing.Point(27,67)
$pingButton.Font                 = 'Microsoft Sans Serif,10'

$closeButton                     = New-Object system.Windows.Forms.Button
$closeButton.text                = "Close"
$closeButton.width               = 102
$closeButton.height              = 30
$closeButton.location            = New-Object System.Drawing.Point(368,230)
$closeButton.Font                = 'Microsoft Sans Serif,10'

$digButton                   = New-Object system.Windows.Forms.Button
$digButton.text              = "Dig"
$digButton.width             = 102
$digButton.height            = 30
$digButton.location          = New-Object System.Drawing.Point(29,114)
$digButton.Font              = 'Microsoft Sans Serif,10'

$rebootButton                   = New-Object system.Windows.Forms.Button
$rebootButton.text              = "Reboot"
$rebootButton.width             = 102
$rebootButton.height            = 30
$rebootButton.location          = New-Object System.Drawing.Point(29,160)
$rebootButton.Font              = 'Microsoft Sans Serif,10'

$chocoLocalButton                   = New-Object system.Windows.Forms.Button
$chocoLocalButton.text              = "Install Choco to your computer"
$chocoLocalButton.width             = 120
$chocoLocalButton.height            = 50
$chocoLocalButton.location          = New-Object System.Drawing.Point(495,12)
$chocoLocalButton.Font              = 'Microsoft Sans Serif,10'

$psInstallButton                   = New-Object system.Windows.Forms.Button
$psInstallButton.text              = "Install PSTools to your computer"
$psInstallButton.width             = 120
$psInstallButton.height            = 50
$psInstallButton.location          = New-Object System.Drawing.Point(495,70)
$psInstallButton.Font              = 'Microsoft Sans Serif,10'

$chocoCopyButton                   = New-Object system.Windows.Forms.Button
$chocoCopyButton.text              = "Copy Choco to remote computer"
$chocoCopyButton.width             = 120
$chocoCopyButton.height            = 50
$chocoCopyButton.location          = New-Object System.Drawing.Point(495,120)
$chocoCopyButton.Font              = 'Microsoft Sans Serif,10'

$chocoInstallButton                   = New-Object system.Windows.Forms.Button
$chocoInstallButton.text              = "Install Choco to remote computer"
$chocoInstallButton.width             = 120
$chocoInstallButton.height            = 50
$chocoInstallButton.location          = New-Object System.Drawing.Point(495,170)
$chocoInstallButton.Font              = 'Microsoft Sans Serif,10'

$psWindowConnectionButton                   = New-Object system.Windows.Forms.Button
$psWindowConnectionButton.text              = "Remote PowerShell session"
$psWindowConnectionButton.width             = 120
$psWindowConnectionButton.height            = 50
$psWindowConnectionButton.location          = New-Object System.Drawing.Point(495,220)
$psWindowConnectionButton.Font              = 'Microsoft Sans Serif,10'

$Form.controls.AddRange(@($compNameTxtbox,$Label1,$result,$pingButton,$closeButton,$digButton,$rebootButton,$resultName,$chocoLocalButton,$psInstallButton,$chocoCopyButton,$chocoInstallButton,$psWindowConnectionButton))

$pingButton.Add_Click({ ping })
$digButton.Add_Click({ dig })
$rebootButton.Add_Click({ reboot })
$closeButton.Add_Click({ closeForm })
$chocoLocalButton.Add_Click({ chocoLocal })
$psInstallButton.Add_Click({ psInstall })
$chocoCopyButton.Add_Click({ chocoCopy })
$chocoInstallButton.Add_Click({ chocoInstall })
$psWindowConnectionButton.Add_Click({ psWindowConnection })


#Ping
function ping()
{ 
    $result.text += "`r`n" + "Pinging " + $compNameTxtbox.text
    if(test-connection $compNameTxtbox.text){
        $result.text += "`r`nConnection successfull"
    }
    else
    {
         $result.text += "`r`nConnection Failed"
    }
}

#dig
function dig(){ 
    $result.text += "`r`n" + "Digging " + $compNameTxtbox.text
    $resultName.text += "`r`n" + "Digging " + $compNameTxtbox.text
    $result.text = [System.Net.Dns]::GetHostAddresses($compNameTxtbox.text)
    $resultName.text = (Resolve-DnsName $compNameTxtbox.text).NameHost.split(".",2)
}

#Reboot
function reboot(){
     $result.text += "`r`n" +  "Rebooting " + $compNameTxtbox.text
     Restart-Computer -ComputerName $compNameTxtbox.text -Force
     $result.text += "`r`n" + $compNameTxtbox.text + " rebooted"
}

#ChocoLocal
function chocoLocal(){
    $compNameTxtbox = $compNameTxtbox.text
    wget https://chocolatey.org/install.ps1 -OutFile install.ps1
    .\install.ps1
    #.\DoNothing.ps1
    $result.text += "`r`n" + $compNameTxtbox.text + "Choco installed to your machine"
    Write-Host "Choco installed to your machine"
}

#PSToolsInstall
function psInstall(){
    $compNameTxtbox = $compNameTxtbox.text
    .\DoNothing.ps1
    choco install pstools -y
    $result.text += "`r`n" + $compNameTxtbox.text + "PSTools has been installed to your machine"
    Write-Host "PSTools has been installed to your machine"
}

#ChocoCopy
function chocoCopy(){
    $compNameTxtbox = $compNameTxtbox.text
    #wget https://chocolatey.org/install.ps1 -OutFile install.ps1
    net use \\$compNameTxtbox\temp #Or whatever directory - Need to work this out
    Invoke-WebRequest -URI https://chocolatey.org/install.ps1 -OutFile C:\Temp\install.ps1
    robocopy "C:\Temp\" "\\$compNameTxtbox\Temp\" install.ps1
    $result.text += "`r`n" + $compNameTxtbox.text + "Choco copied"
    Write-Host "Doing Copy"
}

#ChocoInstall
function chocoInstall(){
    $compNameTxtbox = $compNameTxtbox.text
    psexec \\$compNameTxtbox computer | powershell C:\Temp\install.ps1
    #psexec \\$compNameTxtbox\c$\Temp\New\ powershell install.ps1
    Write-Host "Doing Install"
}

#OpenPSWindowConnection
function psWindowConnection(){
    $compNameTxtbox = $compNameTxtbox.text
    Invoke-Expression 'cmd /c start psexec \\$compNameTxtbox powershell'
    #psexec \\$compNameTxtbox cmd
}

function closeForm(){$Form.close()}
    


[void]$Form.ShowDialog() 
