Lưu ý khi dùng:
File backup.bat đặt ở đâu thì thư mục DriverBackup sinh ra cùng cấp với backup.bat

File restore.bat phải đặt cùng cấp với thư mục DriverBackup

Cần bật delayed expansion (setlocal enabledelayedexpansion) nếu muốn dùng biến đếm bên trong vòng for — thêm dòng sau ngay sau @echo off:
```
setlocal enabledelayedexpansion
```

Sau khi restore nên khởi động lại máy để Windows nhận đầy đủ driver
