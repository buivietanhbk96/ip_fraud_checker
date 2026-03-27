@echo off
setlocal
chcp 65001 >nul

cd /d "%~dp0"

echo ============================================================
echo   SETUP TOOL - IP FRAUD CHECKER
echo ============================================================
echo.

echo [1/5] Kiem tra Python...
where python >nul 2>&1
if errorlevel 1 (
    echo [LOI] Khong tim thay lenh python trong PATH.
    echo Vui long cai Python 3.10+ va chon them vao PATH.
    echo Tai Python tai: https://www.python.org/downloads/
    echo.
    pause
    exit /b 1
)

python --version
if errorlevel 1 (
    echo [LOI] Python da ton tai nhung khong chay duoc.
    echo.
    pause
    exit /b 1
)

echo.
echo [2/5] Tao moi truong ao .venv...
if exist ".venv\Scripts\python.exe" (
    echo Da ton tai moi truong ao .venv - bo qua buoc tao moi.
) else (
    python -m venv .venv
    if errorlevel 1 (
        echo [LOI] Khong tao duoc moi truong ao .venv.
        echo.
        pause
        exit /b 1
    )
)

echo.
echo [3/5] Nang cap pip...
call ".venv\Scripts\python.exe" -m pip install --upgrade pip
if errorlevel 1 (
    echo [LOI] Khong the nang cap pip.
    echo.
    pause
    exit /b 1
)

echo.
echo [4/5] Cai package tu requirements.txt...
if not exist "requirements.txt" (
    echo [LOI] Khong tim thay file requirements.txt.
    echo.
    pause
    exit /b 1
)

call ".venv\Scripts\python.exe" -m pip install -r requirements.txt
if errorlevel 1 (
    echo [LOI] Cai package that bai.
    echo.
    pause
    exit /b 1
)

echo.
echo [5/5] Hoan tat cai dat.
echo.
echo ============================================================
echo   CAI DAT THANH CONG
echo ============================================================
echo.
echo Cach kich hoat moi truong ao:
echo   PowerShell : .\.venv\Scripts\Activate.ps1
echo   CMD        : .venv\Scripts\activate.bat
echo.
echo Cach chay tool:
echo   python ip_fraud_checker.py
echo.
echo Vi du dung API key:
echo   python ip_fraud_checker.py --api-key YOUR_API_KEY
echo.
echo Xem huong dan day du tai file README.md
echo.
pause
endlocal
