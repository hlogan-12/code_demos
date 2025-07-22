<#

Key Ideas:
- Computers aren't smart... they need to be told EXACTLY what to do
- Computers are very FAST... they can do a lot of things in a short amount of time

- Roblox source code number of lines... how many?
    >> Over 1 million lines of code

- How can computers process so many lines so quickly?
    >> VERY fast... speed of light

#>


param(
    [Parameter()]
    [string]
    $output_path = ".\count_output.txt"
)


# Get input from user
$input = $(Read-Host "`nHey class!`n`nEnter a number for me to count to")


# while there's an error... get input again
$notInt   = $true
while ( $notInt ) {
    try {
        $input = [int]$input
    } catch {
        Write-Warning "I need an integer.  I can't count to `"$($input)`"`n"
        $input = $(Read-Host "Enter a number for me to count to")
    }

    # Check if input is an integer
    if( $input -is [int] ) { $notInt = $false }
}


# Create output file if not exist, clear content if it does exist
if( !( test-path $output_path -PathType Leaf ) ) {
    New-Item $output_path -ItemType File
} else {
    Clear-Content $output_path
}


# output array entries to file
1..$($input) -join, ", " > $output_path


# open the file
Invoke-Item $output_path
