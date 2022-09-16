package com.example.dbc.vo;

import lombok.Data;

@Data
public class LoginForm {
	private int dbKind;
	private String url;
	private String id;
	private String pw;
}
