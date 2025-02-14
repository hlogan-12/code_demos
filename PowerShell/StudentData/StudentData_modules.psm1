# search for and return the name of the student from the paper
# assumes student name is the first non-empty line in the file
function Get-StudentName ( [string] $BioData ) {

    # Get first line of the bio, assume it's the kid's name
    $Name = ($BioData -split "[\n.]") | Select-Object -First 1
    return $Name
}

# search for and return the name of the teacher from the paper
# if no name detected/returned, return an empty string
function Get-TeacherName ( [string] $BioData ) {

    # Define the regex pattern for the teacher's name (title, then period/whitespace, then name (names if hypenated)
    $teacherFilter = "(?:(mrs|mr|ms|miss|mister)\.?\ ?\w+(?:([-]?\w+)))"
    
    # Split bio into lines, 
    $teacher = (($BioData -split "[\n\r]").trim() | Select-String -Pattern $teacherFilter).Matches.Value
    
    # return string, replacing 'mister' with 'Mr.'
    return $teacher -replace "mister", "Mr."
}

# Pull the student's favorite color from the bio file
# looks for values that match the 'colors' array
function Get-FavoriteColor ( [string] $BioData ) {
    $biodata = Get-Content .\bios\alex_hunt.txt -Raw
    $colors         = @("red", "magenta", "blue", "navy blue", "orange", "yellow", "green", "blue", "purple", "pink", "brown", "black", "white", "gray", "grey")
    $fav_color_line = ($bioData -split "[\n.]") | Where-Object { $_ -match "my favorite color is" -or $_ -match "is my favorite color" }
    $fav_color      = ($fav_color_line.trim() | Select-String -Pattern $($colors -join "|")).Matches.Value
    if( -not $fav_color ) {
        $colorFilter = "(?<=favorite color is )[\w\-]*|[\w\-]*(?= is my favorite color)"
        ($BioData | Select-String -Pattern $colorFilter).Matches.Value
    }
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
