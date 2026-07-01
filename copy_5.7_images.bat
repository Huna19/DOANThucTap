@echo off
set SRC=%~dp0
set DEST=%~dp0static\images\5-Workshop\5.7-Auth-API-Gateway

if not exist "%DEST%" mkdir "%DEST%"

echo Copying 5.7.1 Cognito images...
copy /Y "%SRC%5.7\5.7.1\Screenshot 2026-07-01 042251.png" "%DEST%\cognito_create_btn.png"
copy /Y "%SRC%5.7\5.7.1\Screenshot 2026-07-01 050253.png" "%DEST%\cognito_app_config.png"
copy /Y "%SRC%5.7\5.7.1\Screenshot 2026-07-01 050306.png" "%DEST%\cognito_options.png"

echo Copying 5.7.2 API Gateway images...
copy /Y "%SRC%5.7\5.7.2\Screenshot 2026-07-01 052757.png" "%DEST%\api_create_btn.png"
copy /Y "%SRC%5.7\5.7.2\Screenshot 2026-07-01 053204.png" "%DEST%\api_integration.png"
copy /Y "%SRC%5.7\5.7.2\Screenshot 2026-07-01 053932.png" "%DEST%\jwt_authorizer.png"
copy /Y "%SRC%5.7\5.7.2\Screenshot 2026-07-01 054109.png" "%DEST%\api_routes.png"
copy /Y "%SRC%5.7\5.7.2\Screenshot 2026-07-01 055018.png" "%DEST%\api_cors.png"

echo Copying extra Cognito screenshot...
copy /Y "%SRC%Screenshot 2026-07-01 084122.png" "%DEST%\cognito_create_directory.png"

echo Done! 9 images copied.
pause
