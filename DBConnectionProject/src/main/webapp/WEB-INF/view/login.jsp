<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<title>db 연결 로그인</title>
<style>
body {
  padding:1.5em;
  background: #f5f5f5
}

table {
  border: 1px #a39485 solid;
  font-size: .9em;
  box-shadow: 0 2px 5px rgba(0,0,0,.25);
  width: 100%;
  border-collapse: collapse;
  border-radius: 5px;
  overflow: hidden;
}

th {
  text-align: left;
}
  
thead {
  font-weight: bold;
  color: #fff;
  background: #73685d;
}
  
 td, th {
  padding: 1em .5em;
  vertical-align: middle;
}
  
 td {
  border-bottom: 1px solid rgba(0,0,0,.1);
  background: #fff;
}

a {
  color: #73685d;
}
  
 @media all and (max-width: 768px) {
    
  table, thead, tbody, th, td, tr {
    display: block;
  }
  
  th {
    text-align: right;
  }
  
  table {
    position: relative; 
    padding-bottom: 0;
    border: none;
    box-shadow: 0 0 10px rgba(0,0,0,.2);
  }
  
  thead {
    float: left;
    white-space: nowrap;
  }
  
  tbody {
    overflow-x: auto;
    overflow-y: hidden;
    position: relative;
    white-space: nowrap;
  }
  
  tr {
    display: inline-block;
    vertical-align: top;
  }
  
  th {
    border-bottom: 1px solid #a39485;
  }
  
  td {
    border-bottom: 1px solid #e5e5e5;
  }
  
  
  }
</style>
</head>
<body>
<h1>DB 연결 로그인</h1>
<form method="post" action="${pageContext.request.contextPath}/login" id="loginForm">
	<table border="1">
		<tr>
			<th>DB종류</th>
			<td>
				<select id="dbKind" name="dbKind">
					<option value="0">::선택::</option>
					<option value="1">Oracle</option>
					<option value="2">MySQL</option>
					<option value="3">MSSQL</option>
					<option value="4">MariaDB</option>
					<option value="5">PostgreSQL</option>
				</select>
			</td>
		</tr>
		<tr>
			<th>url입력</th>
			<td>
				<input type="text" name="url" id="url"  size=35>
			</td>
		</tr>
		<tr>
			<th>ID 입력</th>
			<td>
				<input type="text" name="id" id="id">	
			</td>
		</tr>
		<tr>
			<th>비밀번호 입력</th>
			<td>
				<input type="password" name="pw" id="pw">
			</td>
		</tr>
	</table>
</form>
<button id="submitBtn">
접속
</button>
</body>
<script>
 // 값 저장할 변수
 var dbKind = document.getElementById('dbKind');
 var url = document.getElementById('url');
 var id = document.getElementById('id');
 var pw = document.getElementById('pw');
 var submitBtn = document.getElementById('submitBtn');
 var loginForm = document.getElementById('loginForm');
 
 url.addEventListener('keyup',function(){
	 
	 if(url.value==""){
		 alert("url입력해주세요");
		 url.focus();
		 return false;
	 }
	 
 });
 
 id.addEventListener('keyup',function(){
	 
	 if(id.value==""){
		 alert("ID 입력해주세요");
		 id.focus();
		 return false;
	 }
	 
 });
 
 pw.addEventListener('keyup',function(){
	 
	 if(pw.value==""){
		 alert("PW 입력해주세요");
		 pw.focus();
		 return false;
	 }
	 
 });
 
 submitBtn.addEventListener('click',function(){
	 
	 if(dbKind.value == 0) {
		 alert('연결할 db 선택해주세요');
		 dbKind.focus();
		 return;
	 } else if(url.value==""){
		 alert("url입력해주세요");
		 url.focus();
		 return;
	 } else if(id.value==""){
		 alert("ID 입력해주세요");
		 id.focus();
		 return;
	 } else if(pw.value==""){
		 alert("PW 입력해주세요");
		 pw.focus();
		 return;
	 } else {
		 loginForm.submit();
	 }
	 
 });
 
</script>
</html>


