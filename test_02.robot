*** Settings ***
Library    SeleniumLibrary
Library    Collections


*** Variables ***
${URL}    https://practice.expandtesting.com/login  
${BROWSER}    chrome
${USERNAME1}    practice   
${PASSWORD1}    SuperSecretPassword!
${USERNAME2}    betFR         
${PASSWORD2}    SuperSecretPassword 
${SLEEP}    5s


*** Test Cases ***
TC1 - Login with Valid Credentials
    Open Custom Browser    ${URL}    ${BROWSER} 
    Saisir Identifiants Et Connecter   ${USERNAME1}    ${PASSWORD1}
    Wait Until Element Is Visible    xpath=//*[@id="flash"]    timeout=5s
    Page Should Contain    You logged into a secure area!
    #Deconnexion
    Fermer Navigateur    ${SLEEP}

TC2 - Login with Invalid Credentials 
    Open Custom Browser    ${URL}    ${BROWSER}
    Saisir Identifiants Et Connecter    ${USERNAME2}    ${PASSWORD2}
    Wait Until Element Is Visible    xpath=//*[@id="flash"]    timeout=5s
    Page Should Contain    Your username is invalid!
    Fermer Navigateur    ${SLEEP}
     
TC3 - Invalid Username with Correct Password
    Open Custom Browser    ${URL}    ${BROWSER}
    Saisir Identifiants Et Connecter    ${USERNAME2}    ${PASSWORD1}
    Wait Until Element Is Visible    xpath=//*[@id="flash"]    timeout=5s
    Page Should Contain    Your username is invalid!
    Fermer Navigateur    ${SLEEP}

TC4 - Correct Username with Incorrect Password 
    Open Custom Browser    ${URL}    ${BROWSER}
    Saisir Identifiants Et Connecter    ${USERNAME1}    ${PASSWORD2}
    Wait Until Element Is Visible    xpath=//*[@id="flash"]    timeout=5s
    Page Should Contain    Your password is invalid!
    Fermer Navigateur    ${SLEEP}


*** Keywords ***
Open Custom Browser
    [Arguments]    ${URL}    ${BROWSER}
    
    ${options}=    Evaluate    sys.modules['selenium.webdriver'].ChromeOptions()    sys, selenium.webdriver
    ${prefs}=    Create Dictionary
    ...    profile.default_content_setting_values.cookies=2
    ...    profile.default_content_settings.popups=0

    Call Method    ${options}    add_argument    --disable-popup-blocking
    Call Method    ${options}    add_argument    --incognito
    Call Method    ${options}    add_experimental_option    prefs    ${prefs}

    ${driver}=    Create WebDriver    Chrome    options=${options}
    Set Global Variable    ${driver}
    Go To    ${URL}


Saisir Identifiants Et Connecter
    [Arguments]    ${username}    ${password}
    
    Wait Until Element Is Visible    xpath=//*[@id="username"]    timeout=5s
    Input Text    xpath=//*[@id="username"]    ${username}
    
    Wait Until Element Is Visible    xpath=//*[@id="password"]    timeout=5s
    Input Password    xpath=//*[@id="password"]    ${password}
    
    # Attendre que le bouton Login soit bien visible et cliquable
    ${button}=    Get WebElement    xpath=//*[@id="login"]/button
    Execute JavaScript    arguments[0].scrollIntoView(true);    ARGUMENTS    ${button}
    Sleep    1s  # Laisser le scroll se stabiliser
    Wait Until Element Is Visible    ${button}    timeout=5s
    Wait Until Element Is Enabled    ${button}    timeout=5s

    # Clic avec JavaScript si le clic normal est bloqué
    TRY
        Click Element    ${button}
    EXCEPT    ElementClickInterceptedException
        Log    Clic normal bloqué, utilisation du clic JavaScript
        Execute JavaScript    arguments[0].click();    ARGUMENTS    ${button}
    END

Deconnexion
    Wait Until Element Is Visible    xpath=//a[@href='/logout']    timeout=5s
    Click Element    xpath=//a[@href='/logout']

Fermer Navigateur
    [Arguments]    ${SLEEP}
    Sleep    ${SLEEP}
    Close Browser

