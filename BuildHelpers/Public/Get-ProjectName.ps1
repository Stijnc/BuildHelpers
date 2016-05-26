function Get-ProjectName {
    <#
    .SYNOPSIS
        Get the name for this project

    .FUNCTIONALITY
        CI/CD

    .DESCRIPTION
        Get the name for this project

        Evaluates based on the following scenarios:
            * Subfolder with the same name as the current folder
            * Subfolder with a <subfolder-name>.psd1 file in it
            * Current folder with a <currentfolder-name>.psd1 file in it

    .PARAMETER Path
        Path to project root. Defaults to the current working path

    .NOTES
        We assume the following:
            Your repo name is the name of the project
            You store a subfolder for your project in the repo

    .EXAMPLE
        Get-ModuleName

    #>
    [cmdletbinding()]
    param(
        $Path = $PWD.Path
    )

    $CurrentFolder = Split-Path $Path -Leaf
    $ExpectedPath = Join-Path -Path $Path -ChildPath $CurrentFolder
    if(Test-Path $ExpectedPath)
    {
        $CurrentFolder
    }
    else
    {
        # Look for properly organized modules
        $ProjectPaths = Get-ChildItem $Path -Directory |
            Where-Object {
                Test-Path $(Join-Path $_.FullName "$($_.name).psd1")
            } |
            Select -ExpandProperty Fullname

        if( @($ProjectPaths).Count -gt 1 )
        {
            Write-Warning "Found more than one project path via subfolders with psd1 files"
            Split-Path $ProjectPaths -Leaf
        }
        elseif( @($ProjectPaths).Count -eq 1 )
        {
            Split-Path $ProjectPaths -Leaf
        }
        #PSD1 in root of project - ick, but happens.
        elseif( Test-Path "$ExpectedPath.psd1" )
        {
            $CurrentFolder
        }
        else
        {
            Write-Warning "Could not find a project from $($Path)"
        }
    }
}