function Get-UrlStatusCode([string] $Url)
{
    try
    {
        (Invoke-WebRequest -Uri $Url -UseBasicParsing -DisableKeepAlive).StatusCode
    }
    catch [Net.WebException]
    {
        [int]$_.Exception.Response.StatusCode
    }
}


$wc = New-Object net.webclient; 
$url = "http://wpadma01/summer.txt"
#  Get-URLStatusCode from https://stackoverflow.com/questions/20259251/powershell-script-to-check-the-status-of-a-url
$statusCode = Get-UrlStatusCode 'httpstat.us/500'
if ($statusCode -eq 200) {
    $wc.Proxy = [System.Net.GlobalProxySelection]::GetEmptyWebProxy(); "{0:N2} Mbit/sec" -f ((100/(Measure-Command {$wc.Downloadfile('http://wpadma01/Summer.txt',"c:\upgf\speedtest.test")}).TotalSeconds)*8)
} else {
    "$url not reachable: $StatusCode"
}

