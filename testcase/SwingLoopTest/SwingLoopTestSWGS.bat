set date2=%date%
set time2=%time%
set time2=%time2:~0,2%%time2:~3,2%%time2:~6,2%
set now=%date2%%time2%
set dir="C:\AutoMationTestFramework\SimpleRobotFrameWorkServer\public\result\%now%"
mkdir %dir%
robot --variable URL:"http://172.31.196.21:8070/websquare/websquare.html?w2xPath=/SWING/lib/xml/ZLIBSMAN90010.xml&coClCd=B&svrLocation=SWGS" --outputdir %dir% 003_ZOSSSCOMS3010.robot