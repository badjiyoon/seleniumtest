# RobotFramework에서 제공해주는 Chrome / IE / FireFox가 아닌 W-Browser를 사용하기 위해서는
# window에서 report 파일을 이동 시 다음과 같은 batch Program을 통한 report를 output 할 수 있음
# robot --outputdir %dir% wbrowsertest.robot
*** Settings ***
Metadata                    VERSION     0.1
Library	                    Selenium2Library
Library	                    W-BrowserCore.py
Library                     Collections
Library                     OperatingSystem
Library                     String
Library                     BrowserMobProxyLibrary
Resource                    W-BrowserResource.robot

*** Variables ***
${1PAGEID}                  고객상담
${INDEX}                    0

*** Keywords ***
# RobotFramework에서 report를 원하는 경로로 이동하기 위해서는 MAC / Linux 계열의 환경에서는 .sh
# 파일로 조작이 필요함. Windows 계열에서는 .bat파일을 통한 report파일에 대한 조작이 필요함.

# Swing PC화면에 임시로그인을 하기위한 Process
Login Process
    [Documentation]              Login Process (mdi01_subWindow0_iframe)
    Set Selenium Speed           1 seconds
    set selenium implicit wait   10 seconds
    Select Frame                 id=mdi01_subWindow0_iframe
    Execute JavaScript           dst_input.setCellData(0, "login_id", "BLUE");
# Swing 테스트를 위한 JS 오버라이딩 Keyword
    Execute JavaScript           ${CURDIR}/LoginFnOverride.js
    Execute Javascript           scwin.btn_search_onclick();

# Swing 검색화면을 통한 통합접촉이력조회 화면이동 Process
Move Frame Process
    [Documentation]              Move1 Frame Process (top_frame 1PAGE Move)
    Unselect Frame
    set selenium implicit wait   5 seconds
    Click Element                id=btn_findPop
    Execute Javascript           wfm_findLayer_edt_keyword.setValue("고객상담");
    Click Element                id=wfm_findLayer_btn_findBtn
    Execute Javascript           wfm_findLayer_grd_serachResult_cell_1_0.click();
    set selenium implicit wait   10 seconds
    Execute JavaScript           ${CURDIR}/LoginFnOverride.js
	${log}=   Execute JavaScript   return scvar.getPerformanceData();
	Click Element                id=mdi01ZINBSCNS00110_winclose
	set selenium implicit wait   10 seconds
	
Close Br
    log to console      Browsermob Proxy HAR file saved as ${HARDOWNURL}${/}file.har
    Clear Cache
    Close BROWSER

*** Test Cases ***
[TEST-002] 002_ZINBSCNS00110(고객상담) SKT Swing TestCase Runnable
    Init W-Browser
    Make Har
    Login Process
		
    :FOR  ${INDEX}  IN RANGE  100
	\  Move Frame Process
    \  Exit For Loop If    ${INDEX} == 100
    #\  ${fail}=  ${fail} + 1
    #${success}=  Set Variable  5 - ${fail}
    #Log Many   Success:  ${success}
    #Log Many   fail:  ${fail}
    Save Har
    #Close Br