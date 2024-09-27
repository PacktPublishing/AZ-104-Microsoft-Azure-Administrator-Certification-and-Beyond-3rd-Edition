# Enter the Tenant ID for your Azure AD
$TenantId = ""

# Populate your Domain Suffix
$DomainSuffix = ""

# List of user names to create
$UserNames = @(
    "John Smith",
    "Jane Doe",
    "Robert Johnson",
    "Emma Brown",
    "Michael Davis",
    "Olivia Wilson",
    "William Jones",
    "Emily Clark",
    "Joseph Taylor",
    "Sophia Lewis",
    "David Anderson"
)

# login to Azure
Connect-AzAccount -TenantId $TenantId

# Loop through the list of user names and create a user for each
foreach ($UserName in $UserNames) {
    # Generate a random password for each user
    $Password = New-Guid

    # Split the user name into first and last names
    $NameParts = $UserName.Split(" ")
    $FirstName = $NameParts[0]
    $LastName = $NameParts[1]

    # Set the display name and user principal name for the new user
    $DisplayName = $UserName
    $UserPrincipalName = $FirstName.ToLower() + "." + $LastName.ToLower() + "@" + $DomainSuffix

    # Set up the default password for the users - this will be changed on first login
    $Password = "Password@AZ104"
    $Password = ConvertTo-SecureString -AsPlainText -Force $Password

    # Create the new user in Microsoft Entra ID
    $NewUserParams = @{
        DisplayName = "$DisplayName"
        UserPrincipalName = "$UserPrincipalName"
        AccountEnabled = $true
        ForceChangePasswordNextLogin = $true
        MailNickname = $FirstName.ToLower() + "." + $LastName.ToLower()
    }

    $NewUser = New-AzADUser @NewUserParams -Password $Password
}
