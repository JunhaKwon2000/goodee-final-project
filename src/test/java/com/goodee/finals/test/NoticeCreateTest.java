package com.goodee.finals.test;

import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.chrome.ChromeDriver;
import org.springframework.boot.test.context.SpringBootTest;

import com.goodee.finals.config.DriverFactory;
import com.goodee.finals.pages.NoticeCreatePage;
import com.goodee.finals.pages.NoticeListPage;

@SpringBootTest
public class NoticeCreateTest {

	private WebDriver driver;
	
	@BeforeEach
	public void startTest() {
		driver = DriverFactory.getWebDriver();
	}
	
	@Test
	void createNotice() {
		String title = "test";
		String content = "test";
		
		NoticeListPage noticeListPage = new NoticeListPage(driver);
		noticeListPage.goToNoticeCreatePage();
		
		NoticeCreatePage noticeCreatePage = new NoticeCreatePage(driver);
		noticeCreatePage.create(title, content);
		
		Assertions.assertTrue(noticeListPage.containsTitle(title));
	}
	
}
