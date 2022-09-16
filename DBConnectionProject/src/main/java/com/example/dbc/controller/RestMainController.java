package com.example.dbc.controller;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RestController;

import com.example.dbc.CF;
import com.example.dbc.service.MainService;

import lombok.extern.slf4j.Slf4j;
@Slf4j

@RestController
public class RestMainController {
		@Autowired MainService mainSerivce;
	
	@PostMapping("/excuteQuery")
	public List<Map<String,String>> excutequery(HttpSession session
												,String query) {
		 
		List<Map<String,String>> list = mainSerivce.connectionDataBase(query, session);
		log.debug(CF.RD+"RestMainController.list : " + list + CF.RESET);
		
		return list;
	}
}
