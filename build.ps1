param([switch]$Test)
$ErrorActionPreference = 'Stop'
$compiler = Join-Path $env:WINDIR 'Microsoft.NET/Framework64/v4.0.30319/csc.exe'
$framework = Join-Path ${env:ProgramFiles(x86)} 'Reference Assemblies/Microsoft/Framework/.NETFramework/v4.7.2'
$facades = Join-Path $framework 'Facades'
$runtime = Join-Path $env:WINDIR 'Microsoft.NET/Framework64/v4.0.30319'
$references = @(
    "$framework/UIAutomationClient.dll", "$framework/UIAutomationTypes.dll",
    "$framework/WindowsBase.dll", 'System.Windows.Forms.dll', 'System.Drawing.dll',
    'System.Runtime.Serialization.dll', "$facades/System.Runtime.dll",
    "$facades/System.Runtime.InteropServices.WindowsRuntime.dll",
    "$runtime/System.Runtime.WindowsRuntime.dll"
)
foreach ($metadata in @('Foundation','Media','Graphics','Storage','Globalization')) {
    $references += Join-Path $env:WINDIR "System32/WinMetadata/Windows.$metadata.winmd"
}
foreach ($path in @($compiler) + ($references | Where-Object { [IO.Path]::IsPathRooted($_) })) {
    if (!(Test-Path -LiteralPath $path)) {
        throw "Missing build prerequisite: $path. Install the .NET Framework 4.7.2 Developer Pack on 64-bit Windows. See README.md."
    }
}
$destination = Join-Path $PSScriptRoot 'bin'
New-Item -ItemType Directory -Force $destination | Out-Null
$executable = Join-Path $destination 'QuickQuestion.exe'
$source = Join-Path $PSScriptRoot 'QuickQuestionAuto.cs'
$arguments = @('/nologo','/target:winexe',"/out:$executable") + ($references | ForEach-Object { '/reference:' + $_ }) + @($source)
& $compiler @arguments
if ($LASTEXITCODE -ne 0) { throw 'Compilation failed.' }
Write-Output "Built $executable"
if ($Test) {
    $process = Start-Process -FilePath $executable -ArgumentList '--self-test' -WindowStyle Hidden -PassThru -Wait
    $report = Join-Path $destination 'self-test.txt'
    if (Test-Path $report) { Get-Content $report }
    if ($process.ExitCode -ne 0) { throw 'Self-test failed.' }
}

