<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>employeeSearch</title>
<style>
	#btnMenu{
		padding:10px 20px;
		background-color:white; font-size:20px;
		}
	#btnPage{
		padding:7px 10px;
		 font-size:20px;
	}
</style>
</head>
<body>
<%
	request.setCharacterEncoding("utf-8");
	
	// 페이지 주소
	String address = "";
	
	/* 
	시작 게시글 번호 지정을 위한 페이징 변수 수정
	ex) 1 페이지 = 0번째 게시글~9번째 게시글
		2 페이지 = 10번째 게시글~19번쨰 게시글 
		...
		n 페이지 = (n-1)*10 번째 게시글 ~ (n-1)*10+9 번째 게시글
	*/
	
	// 페이징 변수
	int currentPage = 1;
	if(request.getParameter("currentPage") != null)
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	
	// 출력 게시글 개수
	int rowPage = 10;
	
	String searchGender = "선택안함"; // 성별 검색 변수
	String searchNameOption = "선택안함"; // 이름 검색 옵션
	String searchName = ""; //  이름 검색 변수
	
	// 성별 검색 받기
	if(request.getParameter("searchGender") != null){
		searchGender = request.getParameter("searchGender");
	}
	// 이름 검색 옵션 받기
	if(request.getParameter("searchNameOption") != null){
		searchNameOption = request.getParameter("searchNameOption");
	}
	// 이름 검색 받기
	if(request.getParameter("searchName") != null){
		searchName = request.getParameter("searchName");
	}
	
	
	// db
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://ahmo.kro.kr:3306/employees","root","java1004");
		
	
	// 쿼리문 시작
	String sql = "";
	String sql2 = "";	

	
	PreparedStatement stmt = null;
	PreparedStatement stmt2 = null;
	// 1. 검색 x
	if(searchGender.equals("선택안함") && searchNameOption.equals("선택안함")) {
		sql = "select * from employees limit ?, ?";
		stmt = conn.prepareStatement(sql);
		stmt.setInt(1, (currentPage-1) * 10);
		stmt.setInt(2, rowPage);
		sql2 = "SELECT count(*) as cnt FROM employees";
		stmt2 = conn.prepareStatement(sql2);
		address = "./employeesList.jsp?";
	// 2. gender o, first_name x, last_name x
	} else if(!searchGender.equals("선택안함") && searchNameOption.equals("선택안함")){
		sql = "select * from employees where gender=? limit ?, ?";
		stmt = conn.prepareStatement(sql);
		stmt.setString(1, searchGender);
		stmt.setInt(2, (currentPage-1) * 10);
		stmt.setInt(3, rowPage);
		sql2 = "SELECT count(*) as cnt FROM employees where gender=?";
		stmt2 = conn.prepareStatement(sql2);
		stmt2.setString(1, searchGender);
		address = "./employeesList.jsp?searchGender=" + searchGender + "&";
	// 3. gender x, first_name o, last_name x
	}else if(searchGender.equals("선택안함") && searchNameOption.equals("searchFirstName")){
		sql = "select * from employees where first_name like ? limit ?, ?";
		stmt = conn.prepareStatement(sql);
		stmt.setString(1, "%" + searchName + "");
		stmt.setInt(2, (currentPage-1) * 10);
		stmt.setInt(3, rowPage);
		sql2 = "SELECT count(*) as cnt FROM employees where first_name like ?";
		stmt2 = conn.prepareStatement(sql2);
		stmt2.setString(1, "%" + searchName + "");
		address = "./employeesList.jsp?searchNameOption=" + searchNameOption + "&searchName=" + searchName + "&";
	// 4. gender x, first_name x, last_name o
	}else if(searchGender.equals("선택안함") && searchNameOption.equals("searchLastName")){
		sql = "select * from employees where last_name like ? limit ?, ?";
		stmt = conn.prepareStatement(sql);
		stmt.setString(1, "%" + searchName + "");
		stmt.setInt(2, (currentPage-1) * 10);
		stmt.setInt(3, rowPage);
		sql2 = "SELECT count(*) as cnt FROM employees where last_name like ?";
		stmt2 = conn.prepareStatement(sql2);
		stmt2.setString(1, "%" + searchName + "");
		address = "./employeesList.jsp?searchNameOption=" + searchNameOption + "&searchName=" + searchName + "&";
	// 5. gender x, first_name o, last_name o
	}else if(searchGender.equals("선택안함") && searchNameOption.equals("searchFirstOrLast")){
		sql = "select * from employees where first_name like ? or last_name like ? limit ?, ?";
		stmt = conn.prepareStatement(sql);
		stmt.setString(1, "%" + searchName + "");
		stmt.setString(2, "%" + searchName + "");
		stmt.setInt(3, (currentPage-1) * 10);
		stmt.setInt(4, rowPage);
		sql2 = "SELECT count(*) as cnt FROM employees where first_name like ? or last_name like ?";
		stmt2 = conn.prepareStatement(sql2);
		stmt2.setString(1, "%" + searchName + "");
		stmt2.setString(2, "%" + searchName + "");
		address = "./employeesList.jsp?searchNameOption=" + searchNameOption + "&searchName=" + searchName + "&";
	// 6. gender o, first_name o, last_name x
	}else if(!searchGender.equals("선택안함") && searchNameOption.equals("searchFirstName")){
		sql = "select * from employees where gender = ? and first_name like ? limit ?, ?";
		stmt = conn.prepareStatement(sql);
		stmt.setString(1, searchGender);
		stmt.setString(2, "%" + searchName + "");
		stmt.setInt(3, (currentPage-1) * 10);
		stmt.setInt(4, rowPage);
		sql2 = "SELECT count(*) as cnt FROM employees where gender = ? and first_name like ? ";
		stmt2 = conn.prepareStatement(sql2);
		stmt2.setString(1, searchGender);
		stmt2.setString(2, "%" + searchName + "");
		address = "./employeesList.jsp?searchGender=" + searchGender + "&searchNameOption=" + searchNameOption +  "&searchName=" + searchName + "&";
	// 7. gender o, first_name x, last_name o
	}else if(!searchGender.equals("선택안함") && searchNameOption.equals("searchLastName")){
		sql = "select * from employees where gender = ? and last_name like ? limit ?, ?";
		stmt = conn.prepareStatement(sql);
		stmt.setString(1, searchGender);
		stmt.setString(2, "%" + searchName + "");
		stmt.setInt(3, (currentPage-1) * 10);
		stmt.setInt(4, rowPage);
		sql2 = "SELECT count(*) as cnt FROM employees where gender = ? and last_name like ? ";
		stmt2 = conn.prepareStatement(sql2);
		stmt2.setString(1, searchGender);
		stmt2.setString(2, "%" + searchName + "");
		address = "./employeesList.jsp?searchGender=" + searchGender  + "&searchNameOption=" + searchNameOption + "&searchName=" + searchName + "&";
	// 8. gender o, first_name o, last_name o
	}else if(!searchGender.equals("선택안함") && searchNameOption.equals("searchFirstOrLast")){
		sql = "select * from employees where gender = ? and (first_name like ? or last_name like ?) limit ?, ?";
		stmt = conn.prepareStatement(sql);
		stmt.setString(1, searchGender);
		stmt.setString(2, "%" + searchName + "");
		stmt.setString(3, "%" + searchName + "");
		stmt.setInt(4, (currentPage-1) * 10);
		stmt.setInt(5, rowPage);
		sql2 = "SELECT count(*) as cnt FROM employees where gender = ? and (first_name like ? or last_name like ?) ";
		stmt2 = conn.prepareStatement(sql2);
		stmt2.setString(1, searchGender);
		stmt2.setString(2, "%" + searchName + "");
		stmt2.setString(3, "%" + searchName + "");
		address = "./employeesList.jsp?searchGender=" + searchGender + "&searchNameOption=" + searchNameOption + "&searchName=" + searchName + "&";
	}
	
	// 페이지 최대 개수 구하기
	int cnt = 0;
	
	ResultSet rs2 = stmt2.executeQuery();
	
	if(rs2.next()){
		cnt = rs2.getInt("cnt");
		cnt = cnt%10 == 0 ? (int)(cnt / 10) : (int)(cnt / 10)+1;
	}

	ResultSet rs = stmt.executeQuery();

%>
	<!-- 메뉴 -->
	<button id="btnMenu" type="button" onclick="location.href='./index.jsp'">HOME</button>
	<button id="btnMenu" type="button" onclick="location.href='./employeesList.jsp?currentPage=1'">employeesList</button>
	<button id="btnMenu" type="button" onclick="location.href='./departmentsList.jsp?currentPage=1'">departmentList</button>
	<button id="btnMenu" type="button" onclick="location.href='./deptEmpList.jsp?currentPage=1'">deptEmpList</button>
	<button id="btnMenu" type="button" onclick="location.href='./deptManagerList.jsp?currentPage=1'">deptManagerList</button>
	<button id="btnMenu" type="button" onclick="location.href='./salariesList.jsp?currentPage=1'">salariesList</button>
	<button id="btnMenu" type="button" onclick="location.href='./titlesList.jsp?currentPage=1'">titlesList</button>
		
	<h1>사원목록</h1>
		<table border="1">
			<thead>
				<tr>
					<th>emp_no</th>
					<th>birth_date</th>
					<th>first_name</th>
					<th>last_name</th>
					<th>gender</th>
					<th>hire_date</th>
				</tr>
			</thead>
			<tbody>
		<%
			while(rs.next()){
					String sYear = rs.getString("birth_date");
		%>			
				<tr>
					<td><%=rs.getString("emp_no") %></td>
					<td><%=sYear %></td>
					<td><%=rs.getString("first_name") %></td>
					<td><%=rs.getString("last_name") %></td>
					<td>
					<%
						if(rs.getString("gender").equals("M")) out.print("남");
						else out.print("여");
					%>
					</td>
					<td><%=rs.getString("hire_date") %></td>
				</tr>
		<%
			}
		%>
			</tbody>
		</table>
		<br />
		
		<!-- 페이징 버튼 -->
		<div>
			<%
				if(currentPage > 1) {
			%>
				<a href="<%=address%>currentPage=1">처음으로</a>	
				<a href="<%=address%>currentPage=<%=currentPage -1 %>">이전</a>
			<%
				}
			%>
			<%
				if(currentPage < cnt) {
			%>
				<a href="<%=address%>currentPage=<%=currentPage +1 %>">다음</a>
				<a href="<%=address%>currentPage=<%=cnt %>">마지막으로</a>
			<%
				}
			%>
			
		</div>
		<br /><br />
		
		<!-- 검색 옵션 -->
		<form method="post" action="./employeesList.jsp">
			<div>
				gender : 
				<select name="searchGender">
					<option value="선택안함"
						<%
							if(searchGender.equals("선택안함")){
						%>
							selected="selected"
						<%
							}
						%>
						>선택 안함</option>
					<option value="M" 
						<%
							if(searchGender.equals("M")){
						%>
							selected="selected"
						<%
							}
						%>
					>남</option>
					<option value="F"
						<%
							if(searchGender.equals("F")){
						%>
							selected="selected"
						<%
							}
						%>
						>여</option>
				</select>
			</div>
			<div>
				<select name="searchNameOption">
					<option value="선택안함" 
					<%
						if(searchNameOption.equals("선택안함")){
					%>
						selected="selected"
					<%
						}
					%>>=====선택 안함=====</option>
					<option value="searchFirstName"
					<%
						if(searchNameOption.equals("searchFirstName")){
					%>
						selected="selected"
					<%
						}
					%>>First Name</option>
					<option value="searchLastName"
					<%
						if(searchNameOption.equals("searchLastName")){
					%>
						selected="selected"
					<%
						}
					%>>Last Name</option>
					<option value="searchFirstOrLast"
					<%
						if(searchNameOption.equals("searchFirstOrLast")){
					%>
						selected="selected"
					<%
						}
					%>>First Name + Last Name</option>
				</select>
				<input type="text" name="searchName" value=<%=searchName %>>
			</div>
			<button type="submit">검색</button>
		</form>
		<!-- 살려줘 -->
</body>
</html>