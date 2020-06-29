# $PSDefaultParameterValues['*:Encoding'] = 'utf8'

$Script:CommandLocation = (Get-Command $args[0]).Definition
Write-Output $Script:CommandLocation
