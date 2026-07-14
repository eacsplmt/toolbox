@echo off
title 清理 Hyper-V / DeviceGuard / VBS / HvCl
echo ========================================
echo 開始清理虛擬化殘留...
echo ========================================
echo.

echo [1/8] 關閉 hypervisorlaunchtype
bcdedit /set hypervisorlaunchtype off
echo.

echo [2/8] 關閉 DeviceGuard 組策略
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DeviceGuard" /v EnableVirtualizationBasedSecurity /t REG_DWORD /d 0 /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DeviceGuard" /v LsaCfgFlags /t REG_DWORD /d 0 /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DeviceGuard" /v HyperVEnforcedCodeIntegrity /t REG_DWORD /d 0 /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DeviceGuard" /v ConfigureSystemGuardLaunch /t REG_DWORD /d 0 /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DeviceGuard" /v AllowVirtualizationBasedSecurity /t REG_DWORD /d 0 /f
echo.

echo [3/8] 關閉 DeviceGuard 本機
reg add "HKLM\SYSTEM\CurrentControlSet\Control\DeviceGuard" /v EnableVirtualizationBasedSecurity /t REG_DWORD /d 0 /f
reg add "HKLM\SYSTEM\CurrentControlSet\Control\DeviceGuard" /v RequireMicrosoftSignedBootChain /t REG_DWORD /d 0 /f
reg add "HKLM\SYSTEM\CurrentControlSet\Control\DeviceGuard" /v Locked /t REG_DWORD /d 0 /f
reg add "HKLM\SYSTEM\CurrentControlSet\Control\DeviceGuard" /v HyperVVirtualizationBasedSecurityOptout /t REG_DWORD /d 1 /f
reg add "HKLM\SYSTEM\CurrentControlSet\Control\DeviceGuard" /v WasEnabledBy /t REG_DWORD /d 0 /f
reg add "HKLM\SYSTEM\CurrentControlSet\Control\DeviceGuard" /v CachedDrtmAuthIndex /t REG_DWORD /d 0 /f
echo.

echo [4/8] 關閉 LSA (Credential Guard)
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Lsa" /v LsaCfgFlags /t REG_DWORD /d 0 /f
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Lsa" /v SCENoApplyLegacyAuditPolicy /t REG_DWORD /d 0 /f
echo.

echo [5/8] 刪除 Scenarios 殘留
reg delete "HKLM\SYSTEM\CurrentControlSet\Control\DeviceGuard\Scenarios" /f 2>nul
echo.

echo [6/8] 刪除 Capabilities 殘留
reg delete "HKLM\SYSTEM\CurrentControlSet\Control\DeviceGuard\Capabilities" /f 2>nul
echo.

echo [7/8] 關閉 Hyper-V 功能
dism /online /disable-feature /featurename:VirtualMachinePlatform /remove /norestart
dism /online /disable-feature /featurename:HypervisorPlatform /remove /norestart
dism /online /disable-feature /featurename:Microsoft-Hyper-V-All /remove /norestart
dism /online /disable-feature /featurename:Microsoft-Hyper-V /remove /norestart
dism /online /disable-feature /featurename:Microsoft-Hyper-V-Tools-All /remove /norestart
dism /online /disable-feature /featurename:Microsoft-Hyper-V-Management-PowerShell /remove /norestart
dism /online /disable-feature /featurename:Microsoft-Hyper-V-Hypervisor /remove /norestart
dism /online /disable-feature /featurename:Microsoft-Hyper-V-Services /remove /norestart
dism /online /disable-feature /featurename:Microsoft-Hyper-V-Management-Clients /remove /norestart
echo.

echo [8/8] 刪除 Hyper-V 服務與驅動殘留
sc delete hvservice 2>nul
sc delete hyperkbd 2>nul
sc delete HyperVideo 2>nul
sc delete bttflt 2>nul
sc delete gencounter 2>nul
sc delete storflt 2>nul
sc delete vmgid 2>nul
sc delete vpci 2>nul
reg delete "HKLM\SYSTEM\CurrentControlSet\Services\hvservice" /f 2>nul
reg delete "HKLM\SYSTEM\CurrentControlSet\Services\hyperkbd" /f 2>nul
reg delete "HKLM\SYSTEM\CurrentControlSet\Services\HyperVideo" /f 2>nul
reg delete "HKLM\SYSTEM\CurrentControlSet\Services\bttflt" /f 2>nul
reg delete "HKLM\SYSTEM\CurrentControlSet\Services\gencounter" /f 2>nul
reg delete "HKLM\SYSTEM\CurrentControlSet\Services\storflt" /f 2>nul
reg delete "HKLM\SYSTEM\CurrentControlSet\Services\vmgid" /f 2>nul
reg delete "HKLM\SYSTEM\CurrentControlSet\Services\vpci" /f 2>nul
reg delete "HKLM\SYSTEM\ControlSet001\Services\hvservice" /f 2>nul
reg delete "HKLM\SYSTEM\ControlSet001\Services\hyperkbd" /f 2>nul
reg delete "HKLM\SYSTEM\ControlSet001\Services\HyperVideo" /f 2>nul
reg delete "HKLM\SYSTEM\ControlSet001\Services\bttflt" /f 2>nul
reg delete "HKLM\SYSTEM\ControlSet001\Services\gencounter" /f 2>nul
reg delete "HKLM\SYSTEM\ControlSet001\Services\storflt" /f 2>nul
reg delete "HKLM\SYSTEM\ControlSet001\Services\vmgid" /f 2>nul
reg delete "HKLM\SYSTEM\ControlSet001\Services\vpci" /f 2>nul
echo.

echo ========================================
echo 清理完成！
echo 請手動重開機讓變更生效。
echo 重開機後執行驗證命令確認。
echo ========================================
pause