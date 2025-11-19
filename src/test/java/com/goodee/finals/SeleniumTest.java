package com.goodee.finals;

import static org.junit.jupiter.api.Assertions.*;

import java.time.Duration;

import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.chrome.ChromeDriver;
import org.openqa.selenium.support.ui.ExpectedConditions;
import org.openqa.selenium.support.ui.WebDriverWait;
import org.springframework.boot.test.context.SpringBootTest;

@SpringBootTest
class SeleniumTest {

	private WebDriver driver;
	
	@BeforeEach
	public void init() {
		System.setProperty("webdriver.chrome.driver", "C:\\dev\\chromedriver-win64\\chromedriver.exe");
		driver = new ChromeDriver();
		driver.manage().window().maximize();
	}
	
	@AfterEach
	public void end() {
		driver.close();
	}
	
	public void login(String staffCode, String staffPw) {
		driver.get("http://localhost/staff/login");
		driver.findElement(By.name("staffCode")).sendKeys(staffCode);
		driver.findElement(By.name("staffPw")).sendKeys(staffPw);
		driver.findElement(By.cssSelector("button[type='submit']")).click();
		
		WebDriverWait wait = new WebDriverWait(driver, Duration.ofSeconds(5));
		WebElement confirmBtn = wait.until(ExpectedConditions.elementToBeClickable(By.cssSelector(".swal2-confirm")));
		confirmBtn.click();
	}
	
	@Test
	public void testCase1() {
		login("20250004", "1111");
		assertEquals(driver.getTitle(), "대시보드");

		WebDriverWait wait = new WebDriverWait(driver, Duration.ofSeconds(5));
		WebElement noticeAnchor = wait.until(ExpectedConditions.elementToBeClickable(By.cssSelector("a[href='/notice']")));
		noticeAnchor.click();

		wait.until(ExpectedConditions.titleIs("공지사항"));
		assertEquals(driver.getTitle(), "공지사항");
	}

}
