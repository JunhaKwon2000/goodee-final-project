package com.goodee.finals.common.config;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

import com.goodee.finals.common.interceptor.CheckStaffEnableInterceptor;
import com.goodee.finals.lost.LostCheckAuthInterceptor;
import com.goodee.finals.notice.NoticeCheckAuthInterceptor;
import com.goodee.finals.notice.NoticeCheckLoginInterceptor;
import com.goodee.finals.product.ProductCheckAuthInterceptor;

@Configuration
public class InterceptorConfig implements WebMvcConfigurer {
	
	@Autowired
	NoticeCheckLoginInterceptor noticeCheckLoginInterceptor;
	
	@Autowired
	NoticeCheckAuthInterceptor noticeCheckAuthInterceptor;
	@Autowired
	LostCheckAuthInterceptor lostCheckAuthInterceptor;
	@Autowired
	ProductCheckAuthInterceptor productCheckAuthInterceptor;
	@Autowired
	CheckStaffEnableInterceptor checkStaffEnableInterceptor;
	

	
	@Override
	public void addInterceptors(InterceptorRegistry registry) {
		registry.addInterceptor(noticeCheckLoginInterceptor)
				.addPathPatterns("/notice/write", "/notice/*/edit", "/notice/*/delete");
		registry.addInterceptor(noticeCheckAuthInterceptor)
				.addPathPatterns("/notice/*/edit", "/notice/*/delete");
		registry.addInterceptor(lostCheckAuthInterceptor)
				.addPathPatterns("/lost/write", "/lost/*/update", "/lost/*/delete");
		registry.addInterceptor(productCheckAuthInterceptor)
				.addPathPatterns("/product/write", "/product/*/update", "/product/*/delete", "/productManage/write");
		registry.addInterceptor(checkStaffEnableInterceptor).addPathPatterns("/**");
		registry.addInterceptor(checkStaffEnableInterceptor);
	}
	
}
