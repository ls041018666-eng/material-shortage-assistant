$ErrorActionPreference = 'Stop'
$dir = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location -LiteralPath $dir
$ip = Get-NetIPAddress -AddressFamily IPv4 -ErrorAction SilentlyContinue | Where-Object { $_.IPAddress -notlike '127.*' -and $_.IPAddress -notlike '169.254*' -and $_.InterfaceAlias -notmatch 'Loopback|VMware|VirtualBox|vEthernet' } | Select-Object -First 1 -ExpandProperty IPAddress
Write-Host ''
Write-Host '物料报缺助手已启动' -ForegroundColor Green
Write-Host '电脑访问：http://localhost:8080' -ForegroundColor Cyan
if ($ip) { Write-Host ('手机与电脑连接同一 Wi-Fi 后访问：http://' + $ip + ':8080') -ForegroundColor Yellow }
Write-Host '如弹出防火墙提示，请允许“专用网络”访问。按 Ctrl+C 可停止。' -ForegroundColor Gray
Write-Host ''
Start-Process 'http://localhost:8080'
if (Get-Command py -ErrorAction SilentlyContinue) { & py -m http.server 8080 --bind 0.0.0.0 }
elseif (Get-Command python -ErrorAction SilentlyContinue) { & python -m http.server 8080 --bind 0.0.0.0 }
else { Write-Host '未找到 Python。可直接双击 index.html 在电脑使用；手机长期使用请按使用说明部署到 HTTPS 网站。' -ForegroundColor Red; Read-Host '按回车退出' }