[![Build status](https://ci.appveyor.com/api/projects/status/joxudd6qrahtr802?svg=true)](https://ci.appveyor.com/project/RamblingCookieMonster/buildhelpers)

BuildHelpers
==============

This is a quick and dirty PowerShell module with a variety of helper functions for PowerShell CI/CD scenarios.

Many of our build scripts explicitly reference build-system-specific features.  We might rely on `$ENV:APPVEYOR_REPO_BRANCH` to know which branch we're in, for example.

This certainly works, but we can enable more portable build scripts by bundling up helper functions, normalizing build variables, and avoiding build-system-specific features.

More to come.  Pull requests and other contributions would be welcome!

## Instructions

```powershell
# One time setup
    # Download the repository
    # Unblock the zip
    # Extract the BuildHelpers folder to a module path (e.g. $env:USERPROFILE\Documents\WindowsPowerShell\Modules\)

    #Simple alternative, if you have PowerShell 5, or the PowerShellGet module:
        Install-Module BuildHelpers

# Import the module.
    Import-Module BuildHelpers    #Alternatively, Import-Module \\Path\To\BuildHelpers

# Get commands in the module
    Get-Command -Module BuildHelpers

# Get help
    Get-Help Get-BuildVariables -Full
    Get-Help about_BuildHelpers
```

## Examples

### Get Normalized Build Variables

```powershell
Get-BuildVariables

# We assume you're in the project root. If not, specify a path:
Get-BuildVariables -Path C:\MyProjectRoot
```

### Get Project Name

We occasionally need to reference the project or module name:

```powershell
Get-ProjectName
```

This checks the following expected file system organizations, in order:

* ProjectX (Repo root)
  * ProjectX (Project here)

*Produces*: ProjectX

* ProjectX (Repo root)
  * DifferentName (Project here. tsk tsk)
    * DifferentName.psd1

*Produces*: DifferentName

* ProjectX (Repo root)
  * ProjectX.psd1 (Please don't use this organization...)

*Produces*: ProjectX

### Create Normalized Environment Variables

This runs a few commands from BuildHelpers module, and populates ENV:BH... variables

```powershell
# Read the current environment, populate env vars
Set-BuildEnvironment

# Read back the env vars
Get-Item ENV:BH*
```

Here's an example, having run Set-BuildEnvironment in an AppVeyor project:

[![AppVeyor Example](/Media/AppVeyor.png)](https://ci.appveyor.com/project/RamblingCookieMonster/buildhelpers/build/1.0.4)

## Notes

Thanks to Joel Bennett for the ConvertTo-Metadata function that we use in Set-ModuleFunctions!