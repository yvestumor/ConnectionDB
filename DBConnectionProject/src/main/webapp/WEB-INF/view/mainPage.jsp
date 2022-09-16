<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<title>Insert title here</title>
</head>
<style>
 textarea {
    width: 500%;
    height: 6.25em;
    border: none;
    resize: none;
  }
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
<!-- 엑셀 파일 생성 라이브러리 SheetJS -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/xlsx/0.14.3/xlsx.full.min.js"></script>
<!-- 파일 다운로드 라이브러리 FileSaver savaAs -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/FileSaver.js/1.3.8/FileSaver.min.js"></script>
<body>
<%
	if((Integer)session.getAttribute("dbKind") == 1) {
		System.out.println("oracle");
%>
		<h1>oracle DB 접속</h1>
<% 		
	} else if ((Integer)session.getAttribute("dbKind") == 2) {
		System.out.println("Mysql");
%>
		<h1>MySQL 접속</h1>
<% 
	} else if ((Integer)session.getAttribute("dbKind") == 3) {
		System.out.println("MsSql");
%>
		<h1>MSSQL 접속</h1>
<% 
	} else if ((Integer)session.getAttribute("dbKind") == 4) {
		System.out.println("Mariadb");
%>
		<h1>MariaDB 접속</h1>
<% 		
	} else if ((Integer)session.getAttribute("dbKind") == 5) {
		System.out.println("postgreSql");
%>
		<h1>postgreSQL 접속</h1>
<% 
	}
%>
<button onclick ="location.href='${pageContext.request.contextPath}/logout'">
로그아웃
</button>
<table>
	<thead>
		<tr>
			<th>쿼리 입력</th>
		</tr>
	</thead>
	<tbody>
		<tr>
			<td>
				<textarea id="query" name="query" placeholder="쿼리를 입력해주세요"></textarea>
			</td>
		</tr>
	</tbody>
</table>
<button id="queryBtn">
excute
</button>
<br>
<table id="resultTable" border="1">
</table>
<br>
<button id="exportBtn" type="button">엑셀로 변환</button>
<button id="fileBtn" type="button">엑셀 저장</button>
<br>
<input type="text" id="excelName" placeholder="파일이름입력">
<div id="exportInfo"></div>
</body>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
<script>
$('#excelName').hide();
$('#exportBtn').hide();
$('#fileBtn').hide();
var result; //전역 변수
var keyData; 
var keyLength;
$('#queryBtn').click(function(){
	$('#excelName').hide();
	$('#excelName').val('')
	$('#fileBtn').hide();
	if($("#query").val() == '') { // 쿼리 입력하지않고 버튼눌렀을때
		alert("쿼리를 입력해주세요");
		$('#query').focus();
	} else {
		$('#resultTable').empty();
		$.ajax({
			type:'post'
			,url:'/excuteQuery'
			,data:{query:$('#query').val()}
			,success:function(data){
			console.log('data:', data);
			
			 result = data;
			 
			 keyLength = Object.keys(data[0]).length; //컬럼개수
			 
			 keyData = Object.keys(data[0]); // 컬럼값
			 
			 var error = data[0][keyData[0]];
			 if(keyData.indexOf('error') != -1){ // error가 포함된 문자열이 있으면
				 $('#exportBtn').hide();
				 console.log("error : ",error); 
				alert("error :"+error); 
				 return;
			 	}
				console.log(keyLength);
				$('#exportBtn').show();
				var tableData = '<thead>';
				tableData += '<tr>';
				for (var i=0; i<keyLength; i++){
					tableData += '<th>'+keyData[i]+'</th>';
				}
				tableData += '</tr>';
				tableData += '</thead>';
				tableData += '<tbody>';
				console.log(data);
				for(var j=0; j<data.length; j++){
					tableData += '<tr>';
					for(var i=0; i<keyLength; i++) {
						tableData += '<td>'+data[j][keyData[i]]+'</td>';
							}
					tableData += '</tr>';
				}
				tableData += '</tbody>';
				$('#resultTable').append(tableData);
			}
			,error:function(request, status, error){
				$('#resultTable').empty();
				$('#exportBtn').hide();
				console.log(request.responseText);
				alert("에러발생\n"+"message:"+request.responseText+"\n");
				
			}
		});
	}
});
$('#exportBtn').click(function(){ 
	$('#excelName').show();
	$('#fileBtn').show();
});

$('#fileBtn').click(function(){ //엑셀파일 저장버튼 클릭
	if($('#excelName').val() == '') {
		alert('이름을 입력해주세요');
		$('#excelName').focus();
	}else {
	console.log(result);
	let data =[];// 엑셀 파일의 내용이 될 배열(2중배열 형태)
	let column = [];

	for(var j=0; j<keyLength; j++){
		column.push(keyData[j])
	}
	data.push(column);
	$(result).each(function(index,item){
		let arr = []; 
		for(var i=0; i<keyLength; i++){ // 컬럼개수만큼 for문
			arr.push(item[keyData[i]])
		}
		data.push(arr);
	});
		console.log(data);
		// 엑셀파일 객체 생성 함수
		let wb = XLSX.utils.book_new();
		
		//생성된 액셀파일객체에 엑셀시트 이름 설정
		wb.SheetNames.push("DB 데이터");
		
		// 엑셀파일 데이터를 이용하여 첫번째 워크시트를 생성 
		let ws = XLSX.utils.aoa_to_sheet(data); 
		
		wb.Sheets['DB 데이터'] = ws;
		// 엑셀파일 객체를 엑셀파일로 만들기 
		let source = XLSX.write(wb,{bookType:'xlsx', type:'binary'});
		
		let buf = new ArrayBuffer(source.length);
		
		let view = new Uint8Array(buf);
		
		for(var i=0; i<source.length; i++) {
			view[i] = source.charCodeAt(i) & 0xFF;
		}
		saveAs(new Blob([buf],{type:"application/octet-stream"}), $('#excelName').val()+'.xlsx');
	}	
});
</script>
</html>