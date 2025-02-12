<#
.SYNOPSIS
    This script is used to extract student data from a bio file.

Name,Teacher,Grade,Birthday,Favorite_Food,Favorite_Color,Favorite_Hobby
#>

param (
    [parameter(Mandatory)]
    [string]
    $FilePath
)


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



# search for and return the name of the student from the paper
# assumes student name is the first non-empty line in the file
function Get-StudentName ( [string] $BioData ) {
    $Name = ($BioData -split "`n") | Where-Object { $_ -ne "" -and $_ -ne $null } | Select-Object -First 1
    if( $name -match "name" ) { $Name = ($Name -replace "name:", "").trim() }
    return $Name
}

# search for and return the name of the teacher from the paper
# if no name detected/returned, return an empty string
function Get-TeacherName ( [string] $BioData ) {

    # Define the regex pattern for the teacher's name (title, then period/whitespace, then name (names if hypenated)
    $teacherFilter = "(?:(mrs|mr|ms|miss|mister)\.?\ ?\w+(?:([-]?\w+)))"
    
    # Split bio into lines, 
    $teacher = (($BioData -split "[\n\r.]").trim() |
                Where-Object {
                    $_ -match "teacher*is" -or 
                    $_ -match "class"
                } | Select-String -Pattern $teacherFilter).Matches.Value
    
    # replace 'mister' with 'Mr.'
    return $teacher -replace "mister", "Mr."
}


# Pull the student's favorite color from the bio file
# looks for values that match the 'colors' array
function Get-FavoriteColor ( [string] $BioData ) {
    $colors = @("red", "magenta", "navy blue", "orange", "yellow", "green", "blue", "purple", "pink", "brown", "black", "white", "gray", "grey")
    $fav_color_line = $bioData.split('.') | Where-Object { $_ -match "my favorite color is" -or $_ -match "is my favorite color" }
    $fav_color      = (($fav_color_line.trim().Split(" ") | Where-Object { $_ -in $colors }) -join " ").trim()
    return $fav_color
}


# Find the section of the bio that contains the student's birthday
# then extract and format the date
function Get-Birthday( [string]$BioData ) {
    # Define the regex pattern for the date (MMM d or MMMM d)
    $bday_filter = "((?:jan(?:uary)?)|(?:feb(?:ruary)?)|(?:mar(?:ch)?)|(?:apr(?:il)?)|(?:may?)|(?:jun(?:e)?)|(?:jul(?:y)?)|(?:aug(?:ust)?)|(?:sep(?:tember)?)|(?:oct(?:ober)?)|(?:nov(?:ember)?)|(?:dec(?:ember)?)).\d{1,2}"

    # Get the line that most likely states the student's bday
    $bday_line = (($BioData -split "[\n\r.]").trim() |
                    Where-Object { $_ -match "birthday" -or $_ -match "born" } |
                    Select-String -Pattern $bday_filter).Matches.Value

    # filter the line to get the date, then format it
    try {
        if( $bday_line.count -gt 1) {
            $date = $bday_line -join " or "
        } elseif ( $bday_line.count -eq 0 ) {
            $date = ""
        } else {
            $date = Get-Date $($bday_line | Select-String -Pattern $bday_filter).Matches[0].value -Format "MMMM dd"
        }
    }
    catch {
        # If the date is not valid, return a message
        Write-Host "Invalid date format found in the provided file:  $($fileName)." #### UPDATE TO TAKE FILE AS INPUT...
        $date = ""
    }

    return $date
}
