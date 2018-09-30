Set-Location -Path "$PSScriptRoot\.."

If(-Not (Test-Path -Path "LibStub")){
	New-Item -ItemType SymbolicLink -Name LibStub -Value ..\LibStub
} ElseIf(-Not (((Get-Item -Path "LibStub").Attributes.ToString()) -Match "ReparsePoint")){
	Remove-Item -Path "LibStub"
	New-Item -ItemType SymbolicLink -Name LibStub -Value ..\LibStub
}
