<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<title>salariesList</title>
<!-- boot strap 4 -->
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
<link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.7.0/css/all.css" integrity="sha384-lZN37f5QGtY3VHgisS14W3ExzMWZxybE1SJSEsQp9S+oqd12jhcu+A56Ebc1zFSJ" crossorigin="anonymous">

</head>
<body>
	<!-- 내용 -->
	<%
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
		
		// 1. mariadb(sw)를 사용할 수 있게
		Class.forName("org.mariadb.jdbc.Driver"); // new Driver();
		
		// 2. mariadb 접속 (주소 + 포트넘버 + db이름 , db계정 , db계정 암호)
		Connection conn = DriverManager.getConnection("jdbc:mariadb://ahmo.kro.kr:3306/employees","root","java1004");

		int beginSalary = 0;
		int endSalary = 0;
		int maxSalary = 0;
		String sql = "select MAX(salary) as max from salaries";
		PreparedStatement stmt = conn.prepareStatement(sql);
		ResultSet rs = stmt.executeQuery();
		if(rs.next()){
			maxSalary = rs.getInt("max");
			endSalary = maxSalary;
		}
		
		if(request.getParameter("beginSalary") != null){
			beginSalary = Integer.parseInt(request.getParameter("beginSalary"));
		} 
		if(request.getParameter("endSalary") != null){
			endSalary = Integer.parseInt(request.getParameter("endSalary"));
		}

		address = "/salariesList.jsp?beginSalary=" + beginSalary + "&endSalary=" + endSalary + "&";
		
		// 3. 쿼리(sql) 생성
		String sql2 = "SELECT emp_no,salary,from_date,to_date FROM salaries where salary between ? and ? ORDER BY emp_no ASC LIMIT ?, ?";
		PreparedStatement stmt2 = conn.prepareStatement(sql2);
		stmt2.setInt(1, beginSalary);
		stmt2.setInt(2, endSalary);
		stmt2.setInt(3, (currentPage-1) * 10);
		stmt2.setInt(4, rowPage);
		
		// 4. 쿼리문 결과 저장
		ResultSet rs2 = stmt2.executeQuery();

		// 페이지 최대 개수 구하기
		int cnt = 0;
		String sql3 = "SELECT count(*) as cnt FROM salaries where salary between ? and ?";
		PreparedStatement stmt3 = conn.prepareStatement(sql3);
		stmt3.setInt(1, beginSalary);
		stmt3.setInt(2, endSalary);
		ResultSet rs3 = stmt3.executeQuery();
		
		if(rs3.next()){
			cnt = rs3.getInt("cnt");
			cnt = cnt%10 == 0 ? (int)(cnt / 10) : (int)(cnt / 10)+1;
		}
		

	%>
	<div class="container" style="background-color:white">
		<!-- Top Menu -->
		<div class="">
			<div>
				<nav class="navbar navbar-expand-sm bg-success navbar-dark">
					<ul class="navbar-nav">
						<li class="nav-item">
							<a class="nav-link" href="<%=request.getContextPath()%>/index.jsp">HOME</a>
						</li>
						<li class="nav-item">
							<a class="nav-link" href="<%=request.getContextPath()%>/employeesList.jsp?currentPage=1">employeesList</a>
						</li>
						<li class="nav-item">
							<a class="nav-link" href="<%=request.getContextPath()%>/departmentsList.jsp?currentPage=1">departmentsList</a>
						</li>
						<li class="nav-item">
							<a class="nav-link" href="<%=request.getContextPath()%>/deptEmpList.jsp?currentPage=1">deptEmpList</a>
						</li>
						<li class="nav-item">
							<a class="nav-link" href="<%=request.getContextPath()%>/deptManagerList.jsp?currentPage=1">deptManagerList</a>
						</li>
						<li class="nav-item active">
							<a class="nav-link" href="<%=request.getContextPath()%>/salariesList.jsp?currentPage=1">salariesList</a>
						</li>
						<li class="nav-item">
							<a class="nav-link" href="<%=request.getContextPath()%>/titlesList.jsp?currentPage=1">titlesList</a>
						</li>
					</ul>
				</nav>
			</div>
		</div>
		<!-- Page Content -->
		<div class="container mt-3">
			<h1>
				<span class="badge badge-pill badge-success" style="background-color:#59DA50">
					Salaries List
				</span>	
			</h1>
			<table class="table">
				<thead style="background-color:#E0FFDB">
					<tr>
						<th>emp_no</th>
						<th>salary</th>
						<th>from_date</th>
						<th>to_date</th>
					</tr>
				</thead>
				<tbody>
				<%
					while(rs2.next()){
				%>
						<tr>
							<td><%=rs2.getString("emp_no") %></td>
							<td><%=rs2.getString("salary") %></td>
							<td><%=rs2.getString("from_date") %></td>
							<td><%=rs2.getString("to_date") %></td>
						</tr>
				<%
					}
				%>
				</tbody>
			</table>
			
			<!-- 페이징 버튼 -->
			<div>
				<ul class="pagination">
					<%
						if(currentPage > 1) {
					%>
						<li class="page-item">
							<a style="color:#53C14B; font-weight: bold;" class="page-link" href="<%=request.getContextPath()%><%=address%>currentPage=1">처음으로</a>	
						</li>
						<li class="page-item">
							<a style="color:#53C14B; font-weight: bold;" class="page-link" href="<%=request.getContextPath()%><%=address%>currentPage=<%=currentPage -1 %>">이전</a>
						</li>
					<%
						}
					%>
					<%
						if(currentPage < cnt) {
					%>
						<li class="page-item">
							<a style="color:#53C14B; font-weight: bold;" class="page-link" href="<%=request.getContextPath()%><%=address%>currentPage=<%=currentPage +1 %>">다음</a>
						</li>
						<li class="page-item">
							<a style="color:#53C14B; font-weight: bold;" class="page-link" href="<%=request.getContextPath()%><%=address%>currentPage=<%=cnt %>">마지막으로</a>
						</li>
					<%
						}
					%>
					
				</ul>
			</div>
		
			<!-- 검색 옵션 -->
			<form method="post" action="<%=request.getContextPath()%>/salariesList.jsp">
				<div class="input-group"> 
					<div class="input-group-prepend btn">
						최소 금액 : 
					</div>
					<div class="input-group-prepend">
						<select class="form-control" name="beginSalary">
							<%
								for(int i = 0; i <= 100000 ; i += 10000){
							%>
									<option value=<%=i %>
									<%
										if(beginSalary == i){
									%>
											selected="selected"
									<%
										}
									%>								
									><%=i %></option>
							<%
								}
							%>
						</select>		
					</div>
					<div class="input-group-prepend btn">
						최대 금액 : 		
					</div>			
					<div class="input-group-prepend">
						<select class="form-control" name="endSalary">
							<option value=<%=maxSalary %>
										<%
											if(endSalary == maxSalary){
										%>
												selected="selected"
										<%
											}
										%>								
										><%=maxSalary %></option>
							<%
								for(int i = maxSalary - 10000; i > maxSalary -100000 ; i -= 10000){
									int ii = (int)(i / 10000) * 10000;
							%>
									<option value=<%=ii %>
									<%
										if(endSalary == ii){
									%>
											selected="selected"
									<%
										}
									%>								
									><%=ii %></option>
							<%
								}
							%>
						</select>	
					</div>		
					<div class="input-group-prepend">					
						<button class="btn btn-outline-success" type="submit">검색</button>	
					</div>		
				</div>
			</form>
		</div>
		<!-- footer -->
		<div class="navbar navbar-expand-sm bg-success mt-5" style="height:50px">
		</div>
	</div>
</body>
</html>