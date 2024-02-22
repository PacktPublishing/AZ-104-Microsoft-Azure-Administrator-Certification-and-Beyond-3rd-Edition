# Create your User Credentials
$username = "storageuser1"
# Set up the default password for the users - this will be changed on first login
$Password = "updatewithyourpassword"
$Password = ConvertTo-SecureString -AsPlainText -Force $Password
$Credential = New-Object System.Management.Automation.PSCredential ($username, $Password)

# Connect your Share
$credential = Get-Credential;
$storageAccountName = "somefileshare16122023";
$fileshare = "shared";
$connectTestResult = Test-NetConnection -ComputerName "$($storageAccountName).file.core.windows.net" -Port 445
if ($connectTestResult.TcpTestSucceeded) {
    # Mount the drive
    New-PSDrive -Name Z -PSProvider FileSystem -Root "\\$storageAccountName.file.core.windows.net\$fileshare" -Persist -Credential $credential
} else {
    Write-Error -Message "Unable to reach the Azure storage account via port 445. Check to make sure your organization or ISP is not blocking port 445, or use Azure P2S VPN, Azure S2S VPN, or Express Route to tunnel SMB traffic over a different port."
}