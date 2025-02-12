<#

    .SYNOPSIS
    

#>

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