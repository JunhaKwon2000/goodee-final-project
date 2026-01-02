package com.goodee.finals.pages;

import java.time.Duration;

import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.ui.ExpectedConditions;
import org.openqa.selenium.support.ui.WebDriverWait;

public class NoticeListPage {

	private WebDriver driver;
	
	
	public NoticeListPage(WebDriver driver) {
		this.driver = driver;
		driver.get("http://localhost/staff/login");
		driver.findElement(By.name("staffCode")).sendKeys("20250004");
		driver.findElement(By.name("staffPw")).sendKeys("1111");
		driver.findElement(By.cssSelector("button[type='submit']")).click();
		
		WebDriverWait wait = new WebDriverWait(driver, Duration.ofSeconds(5));
		WebElement confirmBtn = wait.until(ExpectedConditions.elementToBeClickable(By.cssSelector(".swal2-confirm")));
		confirmBtn.click();
		
		WebElement noticeAnchor = wait.until(ExpectedConditions.elementToBeClickable(By.cssSelector("a[href='/notice']")));
		noticeAnchor.click();

		wait.until(ExpectedConditions.titleIs("공지사항"));
	}
	
	public NoticeCreatePage goToNoticeCreatePage() {
		WebDriverWait wait = new WebDriverWait(driver, Duration.ofSeconds(5));
		driver.findElement(By.cssSelector("a[href='/notice/write']")).click();
		wait.until(ExpectedConditions.titleIs("공지사항"));
		return new NoticeCreatePage(driver);
	}
	
	public boolean containsTitle(String title) {
		return driver.findElements(By.xpath("//a[text()='" + title + "']")).size() > 0;
	}
	
}
