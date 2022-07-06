
# Create a table of mappings of AZs from one source subscription to many
# 
# Source                               Peer                                 SourceAz1 SourceAz2 SourceAz3
# ------                               ----                                 -------- - -------- - -------- -
# yyyyyyyyy-e6e2-4539-93ae-xxxxxxxx    zzzzz-7fde-4caf-8629-aaaaaaaa         2         1         3

Login-AzAccount
$azContext = Get-AzContext
# set Az context if required
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
    
    $Results += [PSCustomObject] @{
        Source    = $sourceSubscription
        Peer      = $result[0].peers[0].subscriptionId
        SourceAz1 = $result[0].peers[0].availabilityZone
        SourceAz2 = $result[1].peers[0].availabilityZone
        SourceAz3 = $result[2].peers[0].availabilityZone
    }
}
# Print table
$Results | Format-Table -auto

