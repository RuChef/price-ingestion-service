@REM ----------------------------------------------------------------------------
@REM Maven Start Up Batch script
@REM
@REM Required ENV vars:
@REM JAVA_HOME - location of a JDK home dir
@REM
@REM Optional ENV vars
@REM M2_HOME - location of maven2's installed home dir
@REM MAVEN_BATCH_ECHO - set to 'on' to enable the echo of the batch commands
@REM MAVEN_BATCH_PAUSE - set to 'on' to wait for a keystroke before ending
@REM MAVEN_OPTS - parameters passed to the Java VM when running Maven
@REM     e.g. to debug Maven itself, use
@REM set MAVEN_OPTS=-Xdebug -Xrunjdwp:transport=dt_socket,server=y,suspend=y,address=8000
@REM MAVEN_SKIP_RC - flag to disable loading of mavenrc files
@REM ----------------------------------------------------------------------------

@REM Begin all REM lines with '@' in case MAVEN_BATCH_ECHO is 'on'
@echo off
@REM set title of command window
title %0
@REM enable echoing by setting MAECHO to 'on'
if "%MAVEN_BATCH_ECHO%" == "on"  echo %MAVEN_BATCH_ECHO%

@REM set %HOME% to equivalent of $HOME
if "%HOME%" == "" (set "HOME=%HOMEDRIVE%%HOMEPATH%")

@REM Execute a user defined script before this one
if not "%MAVEN_SKIP_RC%" == "" goto skipRcPre
@REM check for pre script, once with legacy .bat ending and once with .cmd ending
if exist "%USERPROFILE%\mavenrc_pre.bat" call "%USERPROFILE%\mavenrc_pre.bat"
if exist "%USERPROFILE%\mavenrc_pre.cmd" call "%USERPROFILE%\mavenrc_pre.cmd"
:skipRcPre

@REM check/evaluate if we have a JRE or JDK available
set JAVA_EXE=java.exe
if defined JAVA_HOME set JAVA_EXE=%JAVA_HOME%\bin\java.exe

if not "%JAVA_EXE%" == "" (
  set "JAVACMD=%JAVA_EXE%"
)
if not "%JAVACMD%" == "" goto execute

echo.
echo ERROR: JAVA_HOME is not defined correctly.
echo We cannot execute %0 because we cannot find java executable.
echo Please set the JAVA_HOME variable in your environment to match the
echo location of your Java installation.
echo.
goto fail

:execute
@REM Setup the command line

set WRAPPER_JAR=maven-wrapper.jar
set WRAPPER_LAUNCHER=org.apache.maven.wrapper.MavenWrapperMain

set WRAPPER_CONF_URL=%WRAPPER_BASE_URL%/%WRAPPER_JAR%
for /F "tokens=1 delims==" %%A in ('"wmic OS Get localdatetime /value"') do set "dt=%%A"
set "YYYY=%dt:~0,4%" & set "MM=%dt:~4,2%" & set "DD=%dt:~6,2%"
set "HH=%dt:~8,2%" & set "Min=%dt:~10,2%" & set "Sec=%dt:~12,2%"

set WRAPPER_PROPERTIES=-Dmaven.multiModuleProjectDirectory=%MAVEN_PROJECTBASEDIR%
if ""%MAVEN_BATCH_PAUSE%"=="on" set WRAPPER_PROPERTIES=%WRAPPER_PROPERTIES% -Dorg.slf4j.simpleLogger.showDateTime=true -Dorg.slf4j.simpleLogger.dateTimeFormat=yyyy-MM-dd' 'HH:mm:ss',SSS

@REM If available, add the cache to the effective user directory as advised in https://docs.spring.io/spring-boot/docs/current/reference/html/build-tool-plugins.html#build-tool-plugins-maven-wrapper
if "true" == "%MVNW_USE_CENTRAL_REPO_CACHE%" (
for /f "tokens=*" %%i in ('dir /b %USERPROFILE%\.m2\wrapper\dists\apache-maven-*-bin.zip') do set MVNW_REPO_CACHE_FILE=%%i
if not "%MVNW_REPO_CACHE_FILE%" == "" (
set MVNW_REPO_CACHE_URL=file:/%USERPROFILE%\.m2\wrapper\dists\apache-maven-%MVNW_REPO_CACHE_FILE%
set MVNW_REPO_CACHE_DIR=%USERPROFILE%\.m2\wrapper\dists\apache-maven-%MVNW_REPO_CACHE_FILE%
)
)

"%JAVACMD%" %MAVEN_OPTS %WRAPPER_PROPERTIES% %WRAPPER_CONF_URL% %* %WRAPPER_LAUNCHER% %MAVEN_CONFIG%

:end
@REM End local scope for the variables with windows NT shell
if "%ERRORLEVEL%"=="0" goto mainEnd

:fail
rem Set variable MAVEN_TERMINATE_CMD to the name of a command to send data to process
set MAVEN_TERMINATE_CMD=more
for /F "tokens=1" %%i in ("%MAVEN_TERMINATE_CMD%") do (
for /F "delims=" %%j in (`%%i /?`) do (
if "%%j"=="%MAVEN_TERMINATE_CMD%" goto executeTerminate
)
)
for /F "delims=" %%j in (`%%i /?`) do (
if "%%j"=="%MAVEN_TERMINATE_CMD%" goto executeTerminate
)
goto executeTerminate

:executeTerminate
"%JAVACMD%" %MAVEN_OPTS %WRAPPER_PROPERTIES% %WRAPPER_CONF_URL% %* %WRAPPER_LAUNCHER% %MAVEN_CONFIG% %MAVEN_TERMINATE_CMD%

:mainEnd
if "%MAVEN_TERMINATE_CMD%" == "more" goto skipRcPost
@REM check for post script, once with legacy .bat ending and once with .cmd ending
if exist "%USERPROFILE%\mavenrc_post.bat" call "%USERPROFILE%\mavenrc_post.bat"
if exist "%USERPROFILE%\mavenrc_post.cmd" call "%USERPROFILE%\mavenrc_post.cmd"
:skipRcPost

@REM pause the script if MAVEN_BATCH_PAUSE is set to 'on'
if "%MAVEN_BATCH_PAUSE%" == "on" pause

if "%MAVEN_TERMINATE_CMD%" == "more" exit %ERRORLEVEL%

exit /b %ERRORLEVEL%