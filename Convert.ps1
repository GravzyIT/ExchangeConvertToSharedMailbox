# Author: Kieran Graves || https://twitter.com/GravzyIT
function UserDetails #This is the function that collects the User data from the user.
{
$global:uname = Read-Host 'What is the email address of the user?' #Self Explanatory.
write-host "You want to convert $uname to a Shared Mailbox." # Reads back the email.
}

function ConFirmDetails #Function to confirm the users details.
{
$caption = "Confirmation needed."; #Displays a caption to the user.
$message = "Are the above details correct?"; # Displayed to the user.
$yes = new-Object System.Management.Automation.Host.ChoiceDescription "&Yes","Yes";
$no = new-Object System.Management.Automation.Host.ChoiceDescription "&No","No";
$choices = [System.Management.Automation.Host.ChoiceDescription[]]($Yes,$No); # Previous lines set up the Yes and No options, this line registers them.
$global:answer1 = $host.ui.PromptForChoice($caption,$message,$choices,0) # The answer the user gave, it's global so other functions can check it.
}

function checkanswer1 # Function to check the answer from above and then take action.
{
If($answer1 -eq 1) #If statement, Yes = 0 and No = 1, 1 would mean the user made a spelling error or something close to that.
 {
   UserDetails # Asks for user details again.
   ConFirmDetails #Asks to confirm.
   checkanswer1 # Check if the details are correct again, if not, loop back.
 }
}

function ConvertToShared 
{
$UserCredential = Get-Credential # Get admin details for Exchange.
$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://ps.outlook.com/powershell/ -Credential $UserCredential -Authentication Basic -AllowRedirection # Store a session using credentials.
Import-PSSession $Session # Imports the session and connects.
Get-Mailbox $uname | Set-Mailbox –ProhibitSendReceiveQuota 5GB –ProhibitSendQuota 4.75GB –IssueWarningQuota 4.5GB –type shared # Sets the mailbox to shared.
Write-Host "$uname converted to a Shared Mailbox." # Confirms to user.
Remove-PSSession $Session
pause
}

function Main # Main function which runs all other functions, code is ran in order from top to bottom.
{
UserDetails
ConFirmDetails
checkanswer1
ConvertToShared
}

Main # Start the main function and technically the script.
