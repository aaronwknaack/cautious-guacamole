
#repo_framework_query_dotnet.ps1

To use this script, you'll need to replace the placeholders yourorganization, yourproject, and yourpersonalaccesstoken with your own values. You can obtain a personal access token by following the steps in the Azure DevOps documentation.

The script loops through each repository in the specified project and looks for .NET and dotnet framework versions in the contents of each file in the root directory of the repository. If a .NET or dotnet framework version is found, it outputs the name of the repository and the version number.

Note that this script assumes that the .NET and dotnet framework versions are specified in the file contents using the TargetFramework attribute or the = symbol. If the versions are specified using a different format, you'll need to modify the regular expression used in the if statement accordingly.

#netframework.yml
Here's a brief explanation of the changes made:

In the VSBuild task, we're using MSBuild to build the solution instead of dotnet build, since dotnet build is only for .NET Core projects. We're specifying the target .NET Framework version to be 4.5 by passing the /p:TargetFrameworkVersion=v4.5 argument to MSBuild.
We've removed the maximumCpuCount parameter from the VSBuild task since it's not supported in MSBuild.
The VSTest task remains unchanged.
With these changes, the YAML file should now correctly build and test a project that uses .NET Framework 4.5.

#repo_framework_query.ps1
To run the script, save it as a .ps1 file and run it in a PowerShell console. You'll need to replace YOUR_PERSONAL_ACCESS_TOKEN, YOUR_ORGANIZATION_NAME, and YOUR_PROJECT_NAME with the appropriate values for your Azure DevOps organization and project. The script will output a report of the frameworks used in your repositories.