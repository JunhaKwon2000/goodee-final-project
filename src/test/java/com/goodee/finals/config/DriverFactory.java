package com.goodee.finals.config;

import org.openqa.selenium.WebDriver;
import org.openqa.selenium.chrome.ChromeDriver;

public class DriverFactory {
	
	private static WebDriver driver;
	
	public static WebDriver getWebDriver() {
		if (driver == null) {
			System.setProperty("webdriver.chrome.driver", "C:\\dev\\chromedriver-win64\\chromedriver.exe");
			driver = new ChromeDriver();
			driver.manage().window().maximize();
		}
		return driver;
	}
	
	public static void exitWebDriver() {
		if (driver != null) {
			driver.close();
			driver = null;
		}
	}
}
