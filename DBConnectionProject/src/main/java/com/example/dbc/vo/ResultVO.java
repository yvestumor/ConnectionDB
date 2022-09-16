package com.example.dbc.vo;

import java.util.List;
import java.util.Map;

import lombok.Data;

@Data
public class ResultVO {
	boolean isError;
	private Map<String, String> title;
	private List<Map<String, String>> data;
	
}
