# login to Azure
#Connect-AzAccount -TenantId $TenantId

# Define the list of group names
$GroupNames = @(
    "Marketing",
    "Sales",
    "Finance",
    "Human Resources",
    "IT",
    "Legal",
    "Operations",
    "Customer Support",
    "Research and Development",
    "Product Management",
    "Quality Assurance",
    "Business Development"
)

# Create a new Microsoft Entra ID security group for each name in the list
foreach ($GroupName in $GroupNames) {
    New-AzADGroup `
        -DisplayName "$GroupName" `
        -MailNickname ($GroupName.Replace(" ","")) `
        -SecurityEnabled `
        -Description "This is a security group for the $GroupName business unit." `
}
