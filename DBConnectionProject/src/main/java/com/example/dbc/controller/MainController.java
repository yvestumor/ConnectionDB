package com.example.dbc.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;

import com.example.dbc.CF;
import com.example.dbc.service.MainService;
import com.example.dbc.vo.LoginForm;

import lombok.extern.slf4j.Slf4j;
@Slf4j
@Controller
public class MainController {
	
	@Autowired MainService mainService;
	
	@GetMapping("/login")
	public String login(HttpSession session) {
		log.debug(CF.RD+"MainController.login.get() session ID :"+session.getAttribute("id"));
		return "login";	
	}
	
	@PostMapping("/login")
	public String login(LoginForm loginForm
						,HttpSession session) {
		//디버깅 
		int dbKind = loginForm.getDbKind();
		String name = null;
		String url = loginForm.getUrl();
		String id = loginForm.getId();
		String pw = loginForm.getPw();
		
		if(loginForm.getDbKind() == 1) { // orcale
		} else if (loginForm.getDbKind() == 2) { // MySql
			name = "mySql";
		} else if (loginForm.getDbKind() == 3) { // MSSQL
			name = "MSSQL";
		} else if (loginForm.getDbKind() == 4) { //MariaDB
			name = "mariaDB";
		} else if (loginForm.getDbKind() == 5 ) {// postgreSQL
			name = "postgreSQL";
		}
		log.debug(CF.RD+"MainController.login.post() DB 정보 : "+name+CF.RESET);
		log.debug(CF.RD+"MainController.login.post().login url정보 :" +url+CF.RESET);
		log.debug(CF.RD+"MainController.login.post().login ID정보 :" +id+CF.RESET);
		log.debug(CF.RD+"MainController.login.post().login PW정보 :" +pw+CF.RESET);

		// 입력한정보룰 session 에저장함
		session.setAttribute("dbKind",dbKind);
		session.setAttribute("id",id);
		session.setAttribute("pw",pw);
		session.setAttribute("url",url);
		
		return "redirect:/mainPage";
	}
	@GetMapping("/logout")
	public String logout(HttpServletRequest request) {
		//세션 끊기
		request.getSession().invalidate();
		return "redirect:/login";
	}
		
	@GetMapping("/mainPage")
	public String mainPage(HttpSession session) {
		
		log.debug(CF.RD+"mainPage.get() : "+ session.getAttribute("id")+CF.RESET);
		String sessionId = (String)session.getAttribute("id");
		log.debug(CF.RD+"mainPage.get() sessionId : " + sessionId + CF.RESET);
		if(sessionId.equals(null)) {
			return "redirect:/login";
		}
		return "mainPage";
	} 
}
