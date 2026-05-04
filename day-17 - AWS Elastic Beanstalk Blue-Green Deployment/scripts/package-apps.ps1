Write-Host "Cleaning old packages..."

Remove-Item "../app-v1/app-v1.zip" -ErrorAction SilentlyContinue
Remove-Item "../app-v2/app-v2.zip" -ErrorAction SilentlyContinue

Write-Host "Packaging app-v1..."
Compress-Archive `
  -Path "../app-v1/index.html","../app-v1/package.json","../app-v1/server.js" `
  -DestinationPath "../app-v1/app-v1.zip" `
  -Force

Write-Host "Packaging app-v2..."
Compress-Archive `
  -Path "../app-v2/index.html","../app-v2/package.json","../app-v2/server.js" `
  -DestinationPath "../app-v2/app-v2.zip" `
  -Force

Write-Host "Apps packaged successfully"