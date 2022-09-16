 package com.example.dbc.service;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Service;

import com.example.dbc.CF;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class MainService {
	public List<Map<String,String>> connectionDataBase(String query,HttpSession session){
		List<Map<String,String>> list = new ArrayList<>();
		Map<String,String> map = null;
		Connection conn = null;
		PreparedStatement stmt = null;
		ResultSet rs = null;
		String error = null;

		log.debug(CF.RD+"MainService.ConnectionDataBase query : " +query+CF.RESET);
		//Session 값 변수에 저장함 
		int dbKind = -1;
		
		if(session.getAttribute("dbKind") != null) {
			dbKind = (Integer)session.getAttribute("dbKind");
		}
		
		String url = null;
		if (session.getAttribute("url") != null) {
			url = (String)session.getAttribute("url");
		}
		
		String id = null;
		if(session.getAttribute("id") != null) {
			id = (String)session.getAttribute("id");
		}
		
		String pw = null;
		if(session.getAttribute("pw") != null) {
			pw = (String)session.getAttribute("pw");
		}
		
		try {
			String databaseName = null; // 디버깅에 사용할 DB 이름 담을 변수
			
			String driver = null; //드라이버 담을 변수
			
			if(dbKind == 1) { // oracle
				driver = "oracle.jdbc.driver.OracleDriver";
				databaseName = "oracle";
			} else if(dbKind == 2) { // mySql
				driver = "com.mysql.jdbc.Driver";
				databaseName = "mySQL";
			} else if(dbKind == 3) { //MSsql
				driver = "com.microsoft.sqlserver.jdbc.SQLServerDriver";
				databaseName = "msSQL";
				url +=";encrypt=true;trustServerCertificate=true";
			} else if(dbKind == 4) { //mariaDB
				driver = "org.mariadb.jdbc.Driver";
				databaseName = "mariaDB";
			} else if(dbKind == 5) { // postgreSQL
				driver = "org.postgresql.Driver";
				databaseName = "postgreSQL";
			}
			
			log.debug(CF.RD+"MainService ConnectionDataBase DB : "+databaseName+CF.RESET);
			
			// DB COnnection 부분
			Class.forName(driver); // 드라이버 로딩
			
			conn = DriverManager.getConnection(url,id,pw); //db 연결
			
			if(query.contains(";")) { 
				query = query.replace(";", "");
			}
			
			stmt = conn.prepareStatement(query); // 쿼리
			
			rs = stmt.executeQuery(); //resultSet 의 객체값을 반환함 
			
			log.debug(CF.RD+"MainService ConnectionDataBase rs : "+rs+CF.RESET);
			
			ResultSetMetaData rsmd = rs.getMetaData(); // 쿼리 컬럼 값 가져옴 
			
			int countColumns = rsmd.getColumnCount(); // 컬럼 개수
			
			while(rs.next()) {
				map = new LinkedHashMap<String,String>();
				for(int i=1; i<countColumns+1; i++) { 
					String column = (rsmd.getColumnName(i)); 
					map.put(column, rs.getString(column));
				}
				list.add(map);
			}
			if(list.size() == 0) { // list size 가 0 이면
				map = new LinkedHashMap<String,String>();
				for(int i=1; i<countColumns+1; i++) {
					map.put(rsmd.getColumnName(i), "");
				}
				list.add(map);
			}
		} catch(Exception e) { //예외처리
			log.debug(CF.RD+e.getMessage()+CF.RESET); //디버깅
			map = new LinkedHashMap<String,String>();
			error = e.getMessage(); // error변수에 저장 
			
			map.put("error", error); // map에저장 
			
			list.add(map); // list추가 
		} finally {
			try {
				if(rs != null) {
				rs.close();
				}
				stmt.close();
				conn.close();
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}
		log.debug(CF.RD+"MainService resultList :" + list + CF.RESET); //debug
		
		return list;
	}
}
