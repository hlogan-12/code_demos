<#
.SYNOPSIS
    This script is used to extract student data from a bio file.


#>
param (
    [parameter(Mandatory)]
    [string]
    $BioFilePath
)

$BioData = Get-Content -Path $BioFilePath -Raw



# search for and return the name of the student from the paper
# assumes student name is the first non-empty line in the file
Get-StudentName ( [string] $BioData ) {
    $Name = ($BioData -split "`n") | Where-Object { $_ -ne "" -and $_ -ne $null } | Select-Object -First 1
    if( $name -match "name" ) { $Name = ($Name -replace "name:", "").trim() }
    return $Name
}

# search for and return the name of the teacher from the paper
# if no name detected/returned, return an empty string
Get-TeacherName ( [string] $BioData ) {
    $teacher = ($BioData -split "`n")[0..2] | Select-String -Pattern "mr|mrs|ms|miss|mister" -Raw | Select-Object -First 1
    if( $teacher -eq $null ) { $teacher = "" } else { $teacher = $teacher.trim() }
    return $teacher
}


# Pull the student's favorite color from the bio file
# looks for values that match the 'colors' array
Get-FavoriteColor ( [string] $BioData ) {
    $colors = @("red", "magenta", "navy blue", "orange", "yellow", "green", "blue", "purple", "pink", "brown", "black", "white", "gray", "grey")
    $fav_color_line = $bioData.split('.') | Where-Object { $_ -match "my favorite color is" -or $_ -match "is my favorite color" }
    $fav_color      = (($fav_color_line.trim().Split(" ") | Where-Object { $_ -in $colors }) -join " ").trim()
    return $fav_color
}





#### 

param(
    [Parameter(Mandatory)]
    [string]
    $FilePath
)

# Verify path is legit
try { 
    test-path $FilePath
    $file    = Get-ChildItem $FilePath
    $bioData = Get-Content $FilePath -Raw
}
catch {
    write-error "File `"$($FilePath)`" does not exist."
}


if( $file.GetType().Name -ne "FileInfo" -and $file.Extension -match "txt" ) { 
    write-error "Provided 'FilePath' must be a '.txt' file.  `"$($FilePath)`" is a directory"
    break
}



# $fileName = "Hunter Logan.txt"
# $biodata = "Hunter Logan
# Mr. Smithington


# My birthday is September 6."





function Get-Birthday( [string]$BioData ) {
    # Define the regex pattern for the date (MMM d or MMMM d)
    $bday_filter = "((?:jan(?:uary)?)|(?:feb(?:ruary)?)|(?:mar(?:ch)?)|(?:apr(?:il)?)|(?:may?)|(?:jun(?:e)?)|(?:jul(?:y)?)|(?:aug(?:ust)?)|(?:sep(?:tember)?)|(?:oct(?:ober)?)|(?:nov(?:ember)?)|(?:dec(?:ember)?)).\d{1,2}"

    # Get the line that most likely states the student's bday
    $bday_line = ($BioData -split "[\n\r.]").trim() |
                    Where-Object { $_ -match "my birthday is" -or $_ -match "I was born" } |
                    Select-String -Pattern $bday_filter -Raw

    # filter the line to get the date, then format it
    try {
        $date = Get-Date $($bday_line | Select-String -Pattern $bday_filter).Matches[0].value -Format "MMMM dd"
    }
    catch {
        # If the date is not valid, return a message
        Write-Host "Invalid date format found in the provided file:  $($fileName)." #### UPDATE TO TAKE FILE AS INPUT...
        $date = ""
    }

    return $date
}