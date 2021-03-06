@ECHO OFF

SET intDir=""
SET extDir=%cd%

IF EXIST "C:\Program Files (x86)\Ubisoft\Heroes of Might and Magic III" SET intDir="C:\Program Files (x86)\Ubisoft\Heroes of Might and Magic III"
IF EXIST C:\Heroes\ SET intDir=C:\Heroes\
IF %intDir% NEQ "" GOTO :00
SET tmp_msg=Can't find game catalog...

:0
ECHO %tmp_msg%
SET /p intDir=Please to provide path to game catalog[with "\" sign on the end(e.g.: C:\Heroes\)]:
IF NOT EXIST %intDir%  SET tmp_msg=Can't find game catalog "%intDir%" && SET intDir="" && GOTO :0
IF NOT EXIST %intDir%Maps SET intDir=%intDir%\
IF NOT EXIST %intDir%Maps GOTO :0

:00
IF EXIST %extDir%Maps GOTO :000
MKDIR %extDir%Maps

:000
IF  EXIST %extDir%Saves GOTO :0000
MKDIR %extDir%Saves

:0000
IF  EXIST %extDir%logs GOTO :start
MKDIR %extDir%logs


:start
CLS
ECHO ==================================================================
ECHO *           Heroes 3 Maps and Saves Import/Export tool           *
ECHO *                                                                *
ECHO ==================================================================
SET separator=----------------------
SET logHeaders=Date        Hour                    Filr Name

ECHO Import/Exportport between:
ECHO 		%computername% (%intDir%) a 
ECHO 		SDCard/Pendrive (%extDir%)
ECHO %separator%%separator%%separator%
ECHO  1. Import Maps from SDCard/Pendrive to %computername%
ECHO  2. Import Saved games from SDCard/Pendrive to %computername%
ECHO  3. Export Maps from %computername% to SDCard/Pendrive
ECHO  4. Export Saved games from %computername% to SDCard/Pendrive
ECHO  5. Close this script                    
ECHO %separator%%separator%%separator%
SET /p a="Choose option[1-4]:"
ECHO %a% > .\tmp
FINDSTR 1 .\tmp && GOTO :%a%
FINDSTR 2 .\tmp && GOTO :%a%
FINDSTR 3 .\tmp && GOTO :%a%
FINDSTR 4 .\tmp && GOTO :%a%
FINDSTR 5 .\tmp && GOTO :%a%
ECHO %separator%%separator%%separator%
ECHO Wrong option, try again
PAUSE

GOTO :start

:1
SET srcPath=%extDir%Maps\
SET destPath=%intDir%Maps\
SET logFile=\logs\ImportedMaps.txt
SET gameFiles=.h3m
SET listHeader=List of Maps:
SET currentTask=Import from SDCard/Pendrive to %computername%:

ECHO %separator%%separator%%separator%
ECHO * Importing 
ECHO * from SDcard (%srcPath%) 
ECHO * to %computername% (%destPath%)
ECHO %separator%%separator%%separator%
GOTO :import_export

:2
SET srcPath=%extDir%Saves\
SET destPath=%intDir%games\
SET logFile=\logs\ImportedSaves.txt
SET gameFiles=.GM2
SET listHeader=List of Saved Games:
SET currentTask=Import from SDCard/Pendrive to %computername%:

ECHO %separator%%separator%%separator%
ECHO * Importing 
ECHO * from SDcard (%srcPath%)
ECHO * to %computername% (%destPath%)
ECHO %separator%%separator%%separator%
GOTO :import_export

:3
SET srcPath=%intDir%Maps\
SET destPath=%extDir%Maps\
SET logFile=\logs\ExportedMaps.txt
SET gameFiles=.h3m
SET listHeader=List of Maps:
SET currentTask=Eksporting from %computername% to SDCard/Pendrive: 

ECHO %separator%%separator%%separator%
ECHO * Eksporting
ECHo * from %computername% (%srcPath%)
ECHO * to SDcard (%destPath%)
ECHO %separator%%separator%%separator%
GOTO :import_export

:4
SET srcPath=%intDir%games\
SET destPath=%extDir%Saves\
SET logFile=\logs\ExportedSaves.txt
SET gameFiles=.GM2
SET listHeader=List of Saved Games:
SET currentTask=Eksporting from %computername% to SDCard/Pendrive: 

ECHO %separator%%separator%%separator%
ECHO * Eksporting 
ECHo * from %computername% (%srcPath%)
ECHO * to SDcard (%destPath%)
ECHO %separator%%separator%%separator%
GOTO :import_export

:5
GOTO :end

:import_export
ECHO %listHeader%
ECHO ...
ECHO %logHeaders%
DIR %srcPath% | FINDSTR %gameFiles%
ECHO ...
ECHO %separator%%separator%%separator%
PAUSE
ECHO %currentTask%
COPY "%srcPath%*" "%destPath%" /y
ECHO %errorlevel% > .\tmp && SET /p err_code= < .\tmp 
SET tmp_msg=Failure of copying!
IF %err_code% NEQ 0 GOTO :err

REM log
ECHO Import/Export done: %date% > %extDir%%logFile%
ECHO By User: %username% >> %extDir%%logFile%
ECHO %separator%%separator%%separator% >> %extDir%%logFile%
ECHO %logHeaders% >> %extDir%%logFile%
DIR %srcPath% | FINDSTR %gameFiles% >> %extDir%%logFile%
GOTO :end

:err
ECHO ------------------------------ERROR-------------------------------
ECHO !an error has occurred, check the result manually!
ECHO %tmp_msg% 
ECHO numer bledu: %err_code%

:end
ECHO ==================================================================
ECHO *                            * End *                             *
ECHO ==================================================================
IF EXIST .\tmp DEL .\tmp 

PAUSE