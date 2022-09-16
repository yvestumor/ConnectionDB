package com.example.dbc;

import java.util.Arrays;
import java.util.List;

import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

import com.example.dbc.Interceptor.LoginCheckInterceptor;

@Configuration
public class ServerConfigure implements WebMvcConfigurer{
	private static final List<String> URL_PATTERNS = Arrays.asList("/mainPage"); // interceptor 적용할 url 지정
	
	@Override
	public void addInterceptors(InterceptorRegistry registry) {
		registry.addInterceptor(new LoginCheckInterceptor()).addPathPatterns(URL_PATTERNS);
	}
}
