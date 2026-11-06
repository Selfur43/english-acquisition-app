@echo off
TITLE AI English Reflex Coach - V7 Proje Güncelleyici & Test Çalıştırıcı
COLOR 0A
echo ===================================================
echo   V7 YEREL WINDOWS PROJE GÜNCELLEME VE TEST SİSTEMİ
echo ===================================================
echo Proje Dizini: %CD%
echo.

echo [1/4] Bağımlılıklar Kontrol Ediliyor (flutter pub get)...
call flutter pub get
if %errorlevel% neq 0 (
    echo [HATA] Pub get başarısız oldu!
    pause
    exit /b %errorlevel%
)

echo.
echo [2/4] Statik Kod Analizi Yapılıyor (flutter analyze)...
call flutter analyze
if %errorlevel% neq 0 (
    echo [UYARI] Koda ait analiz uyarıları veya hataları bulundu!
)

echo.
echo [3/4] İzolasyon ve Birim Testleri Çalıştırılıyor (flutter test)...
call flutter test
if %errorlevel% neq 0 (
    echo [HATA] Testler başarısız oldu! V7 Kuralları gereği değişiklik geri alınmalı.
    pause
    exit /b %errorlevel%
)

echo.
echo [4/4] Windows Debug Build Deneniyor...
call flutter build windows --debug

echo.
echo ===================================================
echo SUCCESS: Proje güncellemeleri ve V7 test kapıları geçti!
echo ===================================================
pause