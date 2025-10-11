# PowerShell script to configure and build the project
Write-Host "Configuring CMake with Qt6..." -ForegroundColor Green

# Navigate to build directory and run CMake configuration
Set-Location -Path "build"
cmake -DQt6_DIR=D:/Qt/6.10.0/msvc2022_64/lib/cmake/Qt6 -DQT_ADDITIONAL_PACKAGES_PREFIX_PATH=D:/Qt/6.10.0/msvc2022_64 ..

if ($LASTEXITCODE -ne 0) {
    Write-Host "CMake configuration failed!" -ForegroundColor Red
    Set-Location -Path ".."
    Read-Host "Press Enter to continue"
    exit 1
}

Write-Host "Building project..." -ForegroundColor Green
cmake --build .

if ($LASTEXITCODE -ne 0) {
    Write-Host "Build failed!" -ForegroundColor Red
    Set-Location -Path ".."
    Read-Host "Press Enter to continue"
    exit 1
}

Write-Host "Build completed successfully!" -ForegroundColor Green
Set-Location -Path ".."
Read-Host "Press Enter to continue"
