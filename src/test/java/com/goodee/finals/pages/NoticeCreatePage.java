package com.goodee.finals.pages;

import java.time.Duration;

import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.ui.ExpectedConditions;
import org.openqa.selenium.support.ui.WebDriverWait;

public class NoticeCreatePage {
	
	private WebDriver driver;
	
	
	public NoticeCreatePage(WebDriver driver) {
		this.driver = driver;
	}
	
	public NoticeListPage create(String title, String content) {
		driver.findElement(By.name("noticeTitle")).sendKeys(title);
		driver.findElement(By.name("noticeContent")).sendKeys(content);
		driver.findElement(By.id("btn-write")).click();
		
		WebDriverWait wait = new WebDriverWait(driver, Duration.ofSeconds(5));
		WebElement confirmBtn = wait.until(ExpectedConditions.elementToBeClickable(By.cssSelector(".swal2-confirm")));
		confirmBtn.click();
		
		wait.until(ExpectedConditions.titleIs("공지사항"));
		
		return new NoticeListPage(driver);
	}
	
}
