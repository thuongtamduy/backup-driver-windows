@echo off
:: Tên script: restore_drivers_admin.bat

:: Kiểm tra quyền Administrator
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo Yêu cầu quyền Administrator...
    powershell -Command "Start-Process '%~0' -Verb RunAs"
    exit /b
)

:: Đặt thư mục backup (cùng cấp với file .bat này)
set BackupFolder=%~dp0DriverBackup

:: Kiểm tra thư mục backup có tồn tại không
if not exist "%BackupFolder%" (
    echo ==========================================
    echo LỖI: Không tìm thấy thư mục DriverBackup!
    echo Vui lòng đảm bảo thư mục "%BackupFolder%" tồn tại.
    echo ==========================================
    pause
    exit /b 1
)

:: Kiểm tra thư mục backup có chứa driver không
dir /b "%BackupFolder%\*.inf" >nul 2>&1
if %errorlevel% neq 0 (
    echo ==========================================
    echo LỖI: Không tìm thấy file driver (.inf) trong thư mục DriverBackup!
    echo ==========================================
    pause
    exit /b 1
)

echo ==========================================
echo Restore Drivers từ thư mục DriverBackup
echo ==========================================
echo Thư mục nguồn: "%BackupFolder%"
echo.

:: Hỏi xác nhận trước khi restore
set /p Confirm=Bạn có chắc muốn restore tất cả driver? (Y/N): 
if /i "%Confirm%" neq "Y" (
    echo Đã hủy thao tác restore.
    pause
    exit /b 0
)

echo.
echo Đang restore driver, vui lòng đợi...
echo ==========================================

:: Duyệt qua từng thư mục con trong DriverBackup và cài từng driver bằng pnputil
set SuccessCount=0
set FailCount=0

for /d %%D in ("%BackupFolder%\*") do (
    for %%F in ("%%D\*.inf") do (
        echo Đang cài: %%~nxF
        pnputil /add-driver "%%F" /install >nul 2>&1
        if !errorlevel! equ 0 (
            echo   [OK] %%~nxF
            set /a SuccessCount+=1
        ) else (
            echo   [FAIL] %%~nxF
            set /a FailCount+=1
        )
    )
)

echo.
echo ==========================================
echo KẾT QUẢ RESTORE:
echo   Thành công : %SuccessCount% driver
echo   Thất bại   : %FailCount% driver
echo ==========================================

:: Hỏi có muốn khởi động lại không
echo.
set /p Reboot=Bạn có muốn khởi động lại máy ngay bây giờ để áp dụng driver? (Y/N): 
if /i "%Reboot%"=="Y" (
    echo Máy sẽ khởi động lại sau 10 giây...
    shutdown /r /t 10 /c "Khởi động lại để áp dụng driver đã restore"
) else (
    echo Vui lòng khởi động lại máy thủ công để áp dụng đầy đủ driver.
)

pause
