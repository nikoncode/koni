@echo off
echo Clear temporary folder before deploy
cd templates
del compile\*.php
del cache\*.php
pause