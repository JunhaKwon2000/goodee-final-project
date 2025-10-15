package com.goodee.finals.common.config;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.web.servlet.ServletListenerRegistrationBean;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.HttpMethod;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.core.session.SessionRegistry;
import org.springframework.security.core.session.SessionRegistryImpl;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.session.HttpSessionEventPublisher;

import com.goodee.finals.common.security.CustomAuthenticationFailureHandler;
import com.goodee.finals.common.security.CustomAuthenticationSuccessHandler;
import com.goodee.finals.common.security.CustomLogoutSuccessHandler;
import com.goodee.finals.common.security.CustomSessionInformationExpiredStrategy;

@Configuration
@EnableWebSecurity
public class SecurityConfig {
	@Autowired
	private CustomAuthenticationSuccessHandler customAuthenticationSuccessHandler;
	@Autowired
	private CustomAuthenticationFailureHandler customAuthenticationFailureHandler;
	@Autowired
	private CustomLogoutSuccessHandler customLogoutSuccessHandler;
	@Autowired
	private CustomSessionInformationExpiredStrategy customSessionInformationExpiredStrategy;
	
	SessionRegistry sessionRegistry() {
		return new SessionRegistryImpl();
	}
	
	@Bean
	ServletListenerRegistrationBean<HttpSessionEventPublisher> httpSessionEventPublisher() {
		return new ServletListenerRegistrationBean<>(new HttpSessionEventPublisher());
	}
	
	@Bean
	SecurityFilterChain securityFilterChain(HttpSecurity security) throws Exception {
		security
		
		// CORS
		.cors((option) -> option.disable())
		
		// CSRF
		.csrf((option) -> option.disable())
		
		// Authorization
		.authorizeHttpRequests((option) -> { option
			// static resources
			.requestMatchers("/css/**", "/js/**", "/images/**", "/WEB-INF/**", "/staff/login").permitAll()
			.anyRequest().permitAll();
			;
		})
		
		// Login
		.formLogin((option) -> { option
			.loginPage("/staff/login")
			.usernameParameter("staffCode")
			.passwordParameter("staffPw")
			.successHandler(customAuthenticationSuccessHandler)
			.failureHandler(customAuthenticationFailureHandler)
			.permitAll()
			;
		})
		
		// Logout
		.logout((option) -> { option
			.logoutUrl("/staff/logout")
			.invalidateHttpSession(true)
			.deleteCookies("JSESSIONID")
			.logoutSuccessHandler(customLogoutSuccessHandler)
			;
		})
		
		// Session
		.sessionManagement((option) -> { option
			.sessionFixation().changeSessionId()
			.maximumSessions(1)
			.maxSessionsPreventsLogin(false)
			.expiredSessionStrategy(customSessionInformationExpiredStrategy)
			.sessionRegistry(sessionRegistry())
			;
		})
		
		;
		
		return security.build();
	}
}
