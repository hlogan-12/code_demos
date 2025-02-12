#############################################################################
##                                                                         ##
## Script Name: tictactoe.ps1 -- Play some of dat TIC TAC TOE.             ##
## Version:		1.2.1                                                      ##
## Author:		Jerry Lee Ford, Chris Topel                                ##
## Date:			2009 - 4/15/2014                                       ##
##                                                                         ##
## Descrpition: This PowerShell script challenges the player to beat the   ##
##				computer in a game of Tic Tac Toe.                         ##
##                                                                         ##
#############################################################################

### Not sure if I can copy/paste like this...sorry

Set-Alias ds Write-Host
Set-Alias rh Read-Host

######################
##  Initialization  ##
######################

#Define variables used in this script
$startGame = "False" #Controls when the game terminates
$playGame = "True"   #Controls the play of an individual round of play 
$player = "X"        #Specifies the current player's turn
$winner = ""         #Specifies the winner
$moves = 0           #Counts the number of moves made
$move = ""           #Stores the current player's move
$tie = "False"       #Specifies when a tie occurs
$noPlayed = 0
$noWon = 0
$noLost = 0
$noTied = 0
$p1name = ""
$p2name = ""

$A1 = "1"
$A2 = "1"
$A3 = "1"
$B1 = "1"
$B2 = " "
$B3 = " "
$C1 = " "
$C2 = " "
$C3 = " "

################################
##    Functions & Filters     ##
################################

function Clear-Board {
	$script:A1 = " "
	$script:A2 = " "
	$script:A3 = " "
	$script:B1 = " "
	$script:B2 = " "
	$script:B3 = " "
	$script:C1 = " "
	$script:C2 = " "
	$script:C3 = " "
}

function Get-Permission {
	while ($startGame -eq "False") {
		clear
		ds "`n`n`n`n"
		ds "                                           |       |"
		ds "      Welcome to the                   X   |   O   |"
		ds "                                           |       |"
		ds "                                     ------|-------|------"
		ds "   T I C - T A C - T O E                   |       |"
		ds "                                           |   X   |"
		ds "                                           |       |"
		ds "         G A M E !                   ------|-------|------"
		ds "                                           |       |"
		ds "                                           |   O   |   X"
		ds "                                           |       |"
		ds "`n`n`n`n`n`n`nPress ANY KEY then ENTER to DISPLAY HELP"
		$response = rh "Would you like to play? (Y/N)"

		if ($response -eq "Y"){
			clear
			$startGame = "True"
		}
		elseif ($response -eq "N") {
			$startGame = "False"
			clear
			exit
		}
		else {
			$startGame = "False"
			clear
			ds "`n`n`n`n`tTic-tac-toe is a game for two players, X and O," 
			ds "`twho take turns marking the spaces in a 3x3 grid. The player who "
			ds "`tsucceeds in placing three respective marks in a horizontal, "
			ds "`tvertical, or diagonal row wins the game."
			ds "`n`tTo choose a square, you type in its corresponding grid location."
			ds "`tFor example, to choose the middle square one would enter B2"
			ds "`tas their input.`n" 
			
			$response = rh "`tWould you like to play NOW? (Y/N)"
				if ($response -eq "Y"){
					$startGame = "True"
				}
				elseif ($response -eq "N") {
					$startGame = "False"
					clear
					exit
				}
		}
	}
}

function Display-Board {	
	clear
	ds "`n`n                        T I C  -  T A C  - T O E`n`n`n"
	ds "                             1       2       3`n"
	ds "                                 |       |"
	ds "                        A    $A1   |   $A2   |   $A3"
	ds "                                 |       |"
	ds "                           ------|-------|------"
	ds "                                 |       |"
	ds "                        B    $B1   |   $B2   |   $B3"
	ds "                                 |       |"
	ds "                           ------|-------|------"
	ds "                                 |       |"
	ds "                        C    $C1   |   $C2   |   $C3"
	ds "                                 |       |"

	$move = rh "`n`n`n`n Player $player's turn"
	$move
}

function Validate-Move {
	if ($move.length -eq 2) {
		if ($move -match "[A-C][1-3]") {
			$result = "Valid"
		}
		else {
			$result = "Invalid"
		}
	}
	else {
		$result = "Invalid"
	}
	if (($move -eq "A1") -and ($A1 -ne " ")) {$result = "Invalid"}
	if (($move -eq "A2") -and ($A2 -ne " ")) {$result = "Invalid"}
	if (($move -eq "A3") -and ($A3 -ne " ")) {$result = "Invalid"}
	if (($move -eq "B1") -and ($B1 -ne " ")) {$result = "Invalid"}
	if (($move -eq "B2") -and ($B2 -ne " ")) {$result = "Invalid"}
	if (($move -eq "B3") -and ($B3 -ne " ")) {$result = "Invalid"}
	if (($move -eq "C1") -and ($C1 -ne " ")) {$result = "Invalid"}
	if (($move -eq "C2") -and ($C2 -ne " ")) {$result = "Invalid"}
	if (($move -eq "C3") -and ($C3 -ne " ")) {$result = "Invalid"}

	$result
}

function Check-Results {
	$winner = ""

	if (($A1 -eq $player) -and ($A2 -eq $player) -and ($A3 -eq $player)) { 
		$winner = $player
	}
	if (($B1 -eq $player) -and ($B2 -eq $player) -and ($B3 -eq $player)) {
		$winner = $player
	}
	if (($C1 -eq $player) -and ($C2 -eq $player) -and ($C3 -eq $player)) {
		$winner = $player
	}
	if (($A1 -eq $player) -and ($B1 -eq $player) -and ($C1 -eq $player)) {
		$winner = $player
	}
	if (($A2 -eq $player) -and ($B2 -eq $player) -and ($C2 -eq $player)) {
		$winner = $player
	}
	if (($A3 -eq $player) -and ($B3 -eq $player) -and ($C3 -eq $player)) {
		$winner = $player
	}
	if (($A1 -eq $player) -and ($B2 -eq $player) -and ($C3 -eq $player)) {
		$winner = $player
	}
	if (($C1 -eq $player) -and ($B2 -eq $player) -and ($A3 -eq $player)) {
		$winner = $player
	}
	if (($C3 -eq $player) -and ($B2 -eq $player) -and ($A1 -eq $player)) {
		$winner = $player
	}
	$winner
}

function Display-Results {
	clear
	ds "`n`n                        T I C  -  T A C  - T O E`n`n`n"
	ds "                             1       2       3`n"
	ds "                                 |       |"
	ds "                        A    $A1   |   $A2   |   $A3"
	ds "                                 |       |"
	ds "                           ------|-------|------"
	ds "                                 |       |"
	ds "                        B    $B1   |   $B2   |   $B3"
	ds "                                 |       |"
	ds "                           ------|-------|------"
	ds "                                 |       |"
	ds "                        C    $C1   |   $C2   |   $C3"
	ds "                                 |       |"

	if ($tie -eq "True") {
		clear
		ds "`n`n"
		ds "The game has ended in a tie!"
		ds "`n`n"
		ds "`n`n`n Game Stats`n" -foregroundcolor green
		ds "-------------------`n"	
		ds "`n Number of games played: $noPlayed"
		ds "`n Player X wins: $noWon"
		ds "`n Player O wins: $noLost"
		ds "`n Number of games tied: $noTied`n"
		ds "-------------------`n"
		ds "Press Enter to continue."
		rh
		$noPlayed += 1
		$noTied += 1
	}
	else {
		clear
		ds "`n`n"
		ds "$player has won!"
		ds "`n`n"
		ds "`n`n`n Game Stats`n" -foregroundcolor green
		ds "-------------------`n"	
		ds "`n Number of games played: $noPlayed"
		ds "`n Player X Wins: $noWon"
		ds "`n Player O Wins: $noLost"
		ds "`n Number of games tied: $noTied`n"
		ds "-------------------`n"
		rh "`n`n`n`n Press Enter to continue"
	}
}

Clear-Board
Get-Permission

while ($Terminate -ne "True") {
	while ($playGame -eq "True") {
		$move = Display-Board
		$validMove = Validate-Move
		
		if ($validMove -eq "Valid") {
		$moves++
		
		if ($move -eq "A1") {$A1 = $player}
		if ($move -eq "A2") {$A2 = $player}
		if ($move -eq "A3") {$A3 = $player}
		if ($move -eq "B1") {$B1 = $player}
		if ($move -eq "B2") {$B2 = $player}
		if ($move -eq "B3") {$B3 = $player}
		if ($move -eq "C1") {$C1 = $player}
		if ($move -eq "C2") {$C2 = $player}
		if ($move -eq "C3") {$C3 = $player}
		}
		else {
			clear
			rh "`n`n`n`n`n`n`n`n`n`nInvalid Move. Press Enter to try again"
			continue
		}
		
$winner = Check-Results

		if ($winner -eq "X") {
			$noPlayed += 1
			$noWon += 1
			Display-Results
			$playGame = "False"
			continue
		}
		if ($winner -eq "O") {
			$noPlayed += 1
			$noLost += 1
			Display-Results
			$playGame = "False"
			continue
		}
		if ($moves -eq 9) {
			ds `a 
			$tie = "True"
			Display-Results
			$playGame = "False"
			continue
		}
		if ($playGame -eq "True") {
			if ($player -eq "X") {
				$player = "O" 
			}
			else {
				$player = "X"
			}
		}
	}
	
$response = "False"

	while ($response -ne "True") {
		clear
		$response = rh "`n`n Play again? (Y/N)"

		if ($response -eq "Y") {
			$response = "True"
			$terminate = "False"
			$playGame = "True"
			Clear-Board
			$player = "X"
			$moves = 0
			$tie = "False"
		}
		elseif ($response -eq "N") {
			clear
			ds " `n`n Please return and play again soon."
			rh
			$response = "True"
			$terminate = "True"
		}
		else {
			clear
			ds "`n`n Invalid input. Please press Enter to try again."
			rh
		}
	}
}