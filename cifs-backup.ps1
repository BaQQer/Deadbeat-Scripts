#Requires -RunAsAdministrator

param(
    [string]$backupList = $(throw "ERROR - backup list file is required.."),
    [string]$logfile,
    [switch]$logToConsole = $false,
    [string]$destination = $(throw "ERROR - destination directory is required..")
)

function logger() {
    if ($logfile){
        add-content -Value $args[0] -Path $logfile
    }
    if ($logToConsole){
        write-host $args[0]
    }
}

if (!$logToConsole){
    $verboseOptions = @("/nfl","/ndl","/ns","/nc","/np","/njh","/njh","/njs")
}else{
    $verboseOptions = @("")
}

if (-not (test-path -path $backupList -PathType Leaf)) {
    logger "ERROR - $backupList does not exist. Exiting.."
    exit
}
if (-not (test-path -path $destination -PathType Container)) {
    logger "ERROR - Directory $destination does not exist. Exiting.."
    exit
}

get-content "$backupList" | ForEach-Object {
    $pathInfo = [System.Uri]$_
    if ($pathInfo.isUnc){
        $subDir = $(($pathInfo.Host))
    }else {
        $subDir = "unknown_host"
    }
    logger "Started copy of $_ to $destination/$subDir"
    robocopy "$_" "$destination/$subDir" /e /copy:DAT /dcopy:DAT /r:0 /w:0 /zb /xd "*#recycle*" @verboseOptions
    if ($LASTEXITCODE -gt 6){
        logger "Copy of $_ finished with exit code $LASTEXITCODE. Run script with -logToConsole to debug."
    }else{
        logger "Copy of $_ finished succesfully."
    }
}
exit
