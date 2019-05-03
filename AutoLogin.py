import time
from selenium import webdriver
from selenium.webdriver.common.keys import Keys


def login(url,username,password):
    driver= webdriver.Chrome()
    driver.get(url)
	
    #Enter the username in the text box
    usernameText=driver.find_element_by_name("username")
    usernameText.send_keys(username)

    #Enter the password in the text box
    passwordText=driver.find_element_by_name("password")
    passwordText.send_keys(password)

    #Sign in
    buttons=driver.find_elements_by_xpath("//*[contains(text(), 'Sign In')]")
    for aButton in buttons:
        aButton.click()
	
    time.sleep(10)

def test_logins():
    fh = open('urls.txt')
    for line in fh:
        print ("Attempting login to: ",line)
        login(line, "${var.username}","${var.password}"
    fh.close()


if __name__ == "__main__":
    test_logins()