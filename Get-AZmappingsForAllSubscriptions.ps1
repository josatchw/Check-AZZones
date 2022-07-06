
# Create a table of mappings of AZs from one source subscription to many
# 
# Source                               Peer                                 SourceAz1 SourceAz2 SourceAz3
# ------                               ----                                 -------- - -------- - -------- -
# yyyyyyyyy-e6e2-4539-93ae-xxxxxxxx    zzzzz-7fde-4caf-8629-aaaaaaaa         2         1         3

Login-AzAccount
$azContext = Get-AzContext
# set Az context to another subscription if required. This uses whatever you default is.
$sourceSubscription = $azContext.Subscription.id

# list all subscriptions or provide an array
$subs = @('yyyyyyyyy-e6e2-4539-93ae-xxxxxxxx', 'zzzzz-7fde-4caf-8629-aaaaaaaa')
$subs = (Get-AzSubscription).SubscriptionId
$location = "australiaeast"



$Results = @()
foreach ($sub in $subs) {
    if ($sub -eq $sourceSubscription) {
        continue 
    }
    $result = .\Check-AzureAZmapping.ps1 -Targetsubscription $sub -location $location
    $sourceAz1 = "" 
    $sourceAz2 = "" 
    $sourceAz3 = ""
    # Switch ensures that the source AZ peer mapping returned is placed in the correct source variable
    foreach ($item in $result) {
        switch ($item.availabilityZone) {
            1 { $sourceAz1 = $item.peers[0].availabilityZone }
            2 { $sourceAz2 = $item.peers[0].availabilityZone }
            3 { $sourceAz3 = $item.peers[0].availabilityZone }
        }

    }
    $Results += [PSCustomObject] @{
        Source    = $sourceSubscription
        Peer      = $result[0].peers[0].subscriptionId
        SourceAz1 = $sourceAz1
        SourceAz2 = $sourceAz2
        SourceAz3 = $sourceAz3
    }
}
# Print table
$Results | Format-Table -auto

