Function Test-ADAuthentication {
	param($username,$password)
	(new-object directoryservices.directoryentry "",$username,$password).psbase.name -ne $null
}

$domain = "contoso.com"
#You will need a CSV file with a header Username,Password
$data = import-csv 'c:\temppwlist.csv'
$i = 0

foreach ($row in $data) {
    $username = $row.Username
    $password = $row.Password
    if (Test-ADAuthentication "$domain\$username" "$password") {
        write-output $("$username,$password valid") >> c:\temp\valid.txt
    } else {
        write-output $("$username,credentials invalid") >> c:\temp\invalid.txt
    }

    # update counter and write progress
   $i++
   Write-Progress -activity "Scanning Accounts . . ." -status "Scanned: $i of $($data.Count)" -percentComplete (($i/$data.Count) * 100)
}