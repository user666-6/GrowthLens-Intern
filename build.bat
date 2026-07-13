@echo off
set JAVA_HOME=C:\Program Files\Java\jdk-17
set PATH=%JAVA_HOME%\bin;%PATH%
cd /d "%~dp0"
echo Java Home: %JAVA_HOME%
echo Java Version:
java -version
echo Maven Version:
mvn -v
echo Starting build...
mvn clean package -DskipTests
echo Build completed.