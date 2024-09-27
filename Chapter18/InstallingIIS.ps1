# Install IIS
Install-WindowsFeature -name Web-Server -IncludeManagementTools
# Remove default htm file
remove-item C:\inetpub\wwwroot\iisstart.htm
#Add custom htm file
Add-Content -Path "C:\inetpub\wwwroot\iisstart.htm" -Value $("Hello World from " + $env:computername)
