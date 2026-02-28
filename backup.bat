@echo off
:: Tên script: backup_drivers_admin.bat

:: Kiểm tra quyền Administrator
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo Yêu cầu quyền Administrator...
    powershell -Command "Start-Process '%~0' -Verb RunAs"
    exit /b
)

:: Đặt thư mục backup
set BackupFolder=%~dp0DriverBackup

:: Tạo thư mục backup nếu chưa tồn tại
if not exist "%BackupFolder%" (
    mkdir "%BackupFolder%"
)

:: Backup drivers bằng DISM
echo ==========================================
echo Backup Drivers bằng DISM
echo ==========================================
echo Đang sao lưu driver, vui lòng đợi...
dism /online /export-driver /destination:"%BackupFolder%"

if %errorlevel% equ 0 (
    echo Sao lưu driver thành công!
    echo Driver đã được lưu tại: "%BackupFolder%"
) else (
    echo Có lỗi xảy ra trong quá trình sao lưu!
)

pause
