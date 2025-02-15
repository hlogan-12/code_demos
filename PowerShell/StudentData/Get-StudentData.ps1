<#
    .SYNOPSIS
        This script is used to extract student data from a bio file.


#>
[CmdletBinding()]
param (
    [parameter(Mandatory)]
    [string]
    $FilePath
)

Import-Module .\StudentData_modules.psm1 -Force

# Verify path is legit
try { 
    $results = test-path $FilePath
    $file    = Get-ChildItem $FilePath
    $bioData = Get-Content $FilePath -Raw
}
catch {
    write-error "File `"$($FilePath)`" does not exist."
}

# if f
if( $file.GetType().Name -ne "FileInfo" ) {
    write-error "Provided 'FilePath' must be a '.txt' file.  `"$($FilePath)`" is a directory"
    break
}
elseif( $file.Extension -notmatch "txt" ) { 
    write-error "Provided 'FilePath' must be a '.txt' file.  `"$($FilePath)`" is has extension '$($file.Extension)'"
    break
}

$outputs = [psobject]@{
    "Student"    = Get-StudentName -BioData $bioData
    "Teacher"    = Get-TeacherName -BioData $bioData
    "Birthday"   = Get-Birthday -BioData $bioData
    "Grade"      = Get-Grade -BioData $bioData
    "Color"      = Get-FavoriteColor -BioData $bioData
    "Sport"      = Get-FavoriteSport -BioData $bioData
}

$outputs
