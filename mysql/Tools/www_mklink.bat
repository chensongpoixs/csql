@echo off

setlocal
setlocal enabledelayedexpansion

cd /d %~dp0

REM win ������

mklink /d C:\wamp\www\ctest_case    D:\Work\Github\cproject\csql_nosql\mysql\ctest_case




pause