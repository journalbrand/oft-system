# PowerShell script to pull down verification matrix and run OFT analysis

# Load GitHub token from .env file
$envContent = Get-Content -Path "../.env"
foreach ($line in $envContent) {
    if ($line -match "(.+)=(.+)") {
        $key = $matches[1]
        $value = $matches[2]
        if ($key -eq "GH_TOKEN") {
            $env:GH_TOKEN = $value
            break
        }
    }
}

# Check if OpenFastTrace is installed
try {
    $oftVersion = oft version
    Write-Host "Using OpenFastTrace: $oftVersion" -ForegroundColor Green
} catch {
    Write-Host "OpenFastTrace not found. Installing..." -ForegroundColor Yellow
    pip install openfasttrace
}

# Authentication
gh auth login --with-token $env:GH_TOKEN

# Create directory for verification artifacts
$verificationDir = "local-verification"
if (-not (Test-Path $verificationDir)) {
    New-Item -ItemType Directory -Path $verificationDir | Out-Null
}

# Download the system verification matrix
Write-Host "Downloading system verification matrix..." -ForegroundColor Cyan
gh run download -R your-org/oft-system -n system-verification-matrix -D $verificationDir

# Display the verification matrix
$matrixFile = "$verificationDir\verification-matrix.md"
if (Test-Path $matrixFile) {
    Write-Host "`n===== Verification Matrix =====" -ForegroundColor Green
    Get-Content $matrixFile | Write-Host
    
    # Run local OpenFastTrace analysis if needed
    $runLocalAnalysis = Read-Host "Do you want to run local traceability analysis? (y/n)"
    if ($runLocalAnalysis -eq "y") {
        Write-Host "Running local OFT analysis..." -ForegroundColor Cyan
        oft import -i . -o local-trace.xml
        oft report -i local-trace.xml
    }
    
    Write-Host "`nVerification matrix pulled successfully!" -ForegroundColor Green
} else {
    Write-Host "Failed to download verification matrix." -ForegroundColor Red
} 