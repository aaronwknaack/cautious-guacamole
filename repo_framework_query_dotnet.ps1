# Set variables for your Azure DevOps organization, project, and personal access token (PAT)
$organization = "yourorganization"
$project = "yourproject"
$pat = "yourpersonalaccesstoken"

# Set the REST API URL to get a list of repositories in the specified project
$repoUrl = "https://dev.azure.com/$organization/$project/_apis/git/repositories?api-version=6.0"

# Get a list of repositories in the specified project using the Azure DevOps REST API
$repos = Invoke-RestMethod -Uri $repoUrl -Headers @{Authorization = "Bearer $pat"} -Method Get

# Loop through each repository and get the list of .NET and dotnet framework versions used
foreach ($repo in $repos.value) {
    # Set the REST API URL to get a list of files in the root directory of the repository
    $filesUrl = "https://dev.azure.com/$organization/$project/_apis/git/repositories/$($repo.id)/items?path=/&api-version=6.0"

    # Get a list of files in the root directory of the repository using the Azure DevOps REST API
    $files = Invoke-RestMethod -Uri $filesUrl -Headers @{Authorization = "Bearer $pat"} -Method Get

    # Loop through each file and look for .NET and dotnet framework versions in the file contents
    foreach ($file in $files.value) {
        $contentsUrl = "https://dev.azure.com/$organization/$project/_apis/git/repositories/$($repo.id)/items?path=$($file.path)&versionDescriptor.versionType=branch&versionDescriptor.version=main&api-version=6.0"
        $contents = Invoke-RestMethod -Uri $contentsUrl -Headers @{Authorization = "Bearer $pat"} -Method Get
        foreach ($line in $contents.content | Out-String -Stream) {
            if ($line -match "TargetFramework(.NET|=)") {
                Write-Output "$($repo.name): $($line.Trim())"
            }
        }
    }
}