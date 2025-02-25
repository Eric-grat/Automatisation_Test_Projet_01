*** Settings ***
Library    SeleniumLibrary
*** Variables ***
${url}     https://www.flipkart.com/ 
${browser}    chrome

*** Test Cases ***
Google    
    insideflipkart

*** Keywords ***
insideflipkart
    Open Browser    ${url}    ${browser}     
    Maximize Browser Window    
    Sleep    10
    Close Browser 