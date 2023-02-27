# Set variables
$PAT = "YOUR_PERSONAL_ACCESS_TOKEN"
$OrganizationName = "YOUR_ORGANIZATION_NAME"
$ProjectName = "YOUR_PROJECT_NAME"

# Set API endpoints
$ReposEndpoint = "https://dev.azure.com/$OrganizationName/_apis/git/repositories?api-version=6.0"
$FilesEndpointTemplate = "https://dev.azure.com/$OrganizationName/$ProjectName/_apis/git/repositories/{0}/items?recursionLevel=Full&includeContentMetadata=true&api-version=6.0"

# Set header for API calls
$Header = @{Authorization = "Bearer $PAT"}

# Initialize framework dictionary
$Frameworks = @{}

# Get list of repositories
$ReposResponse = Invoke-RestMethod -Uri $ReposEndpoint -Method Get -Headers $Header
$Repos = $ReposResponse.value

# Iterate through each repository
foreach ($Repo in $Repos) {
    $RepoId = $Repo.id

    # Get list of files in repository
    $FilesEndpoint = [string]::Format($FilesEndpointTemplate, $RepoId)
    $FilesResponse = Invoke-RestMethod -Uri $FilesEndpoint -Method Get -Headers $Header
    $Files = $FilesResponse.value

    # Iterate through each file
    foreach ($File in $Files) {
        $FilePath = $File.path

        # Check if file is a code file
        if ($FilePath -match "\.(cs|vb|java)$") {

            # Extract framework information from file content
            $FileContentEndpoint = $File.url
            $FileContentResponse = Invoke-RestMethod -Uri $FileContentEndpoint -Method Get -Headers $Header
            $FileContent = $FileContentResponse.content

            if ($FileContent -match "using System;") {
                $Framework = ".NET"
            }
            elseif ($FileContent -match "import java\.") {
                $Framework = "Java"
            }
            elseif ($FileContent -match "import kotlin\.") {
                $Framework = "Kotlin"
            }
            else {
                $Framework = "Unknown"
            }

            # Add framework to dictionary
            if ($Frameworks.ContainsKey($Framework)) {
                $Frameworks[$Framework] += 1
            }
            else {
                $Frameworks.Add($Framework, 1)
            }
        }
    }
}

# Generate report
Write-Host "Frameworks used in $OrganizationName/$ProjectName"
foreach ($Framework in $Frameworks.GetEnumerator() | Sort-Object -Property Value -Descending) {
    $Name = $Framework.Name
    $Count = $Framework.Value
    Write-Host "$Name: $Count"
}