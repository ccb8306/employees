<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<title>departments 테이블 목록</title>
<!-- boot strap 4 -->
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
<link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.7.0/css/all.css" integrity="sha384-lZN37f5QGtY3VHgisS14W3ExzMWZxybE1SJSEsQp9S+oqd12jhcu+A56Ebc1zFSJ" crossorigin="anonymous">

</head>
<body>
	<!-- 내용 -->
	<div>
		<%
			request.setCharacterEncoding("utf-8");
			
			// 페이지 주소
			String address = "";
			
			String searchDept = "";
			if(request.getParameter("searchDept") != null)
				searchDept = request.getParameter("searchDept");
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
			
			// 3. 쿼리(sql) 생성
			PreparedStatement stmt = null;
			PreparedStatement stmt2 = null;
			String sql = "";
			String sql2 = "";
			if(!searchDept.equals("")){
				sql = "select * from departments where dept_name like ? ORDER BY dept_no desc LIMIT ?,?";
				stmt = conn.prepareStatement(sql);
				stmt.setString(1, "%" + searchDept + "%");
				stmt.setInt(2, (currentPage-1) * 10);
				stmt.setInt(3, rowPage);
				sql2 = "SELECT count(*) as cnt FROM departments where dept_name = ?";
				stmt2 = conn.prepareStatement(sql2);
				stmt2.setString(1, searchDept);
				address = "/departmentsList.jsp?searchDept=" + searchDept + "&";
				
			}else{
				sql = "SELECT dept_no,dept_name FROM departments ORDER BY dept_no desc LIMIT ?,?";
				stmt = conn.prepareStatement(sql);
				stmt.setInt(1, (currentPage-1) * 10);
				stmt.setInt(2, rowPage);
				sql2 = "SELECT count(*) as cnt FROM departments";
				stmt2 = conn.prepareStatement(sql2);
				address = "/departmentsList.jsp?";
			}
			// 4. 쿼리문 결과 저장
			ResultSet rs = stmt.executeQuery();
			
			// 페이지 최대 개수 구하기
			int cnt = 0; 
			
			ResultSet rs2 = stmt2.executeQuery();
			
			if(rs2.next()){
				cnt = rs2.getInt("cnt");
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
							<a class="nav-link active" href="<%=request.getContextPath()%>/departmentsList.jsp?currentPage=1">departmentsList</a>
						</li>
						<li class="nav-item">
							<a class="nav-link" href="<%=request.getContextPath()%>/deptEmpList.jsp?currentPage=1">deptEmpList</a>
						</li>
						<li class="nav-item">
							<a class="nav-link" href="<%=request.getContextPath()%>/deptManagerList.jsp?currentPage=1">deptManagerList</a>
						</li>
						<li class="nav-item">
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
					Departments List 
				</span>	
			</h1>
			<table class="table">
				<thead style="background-color:#E0FFDB">
					<tr>
						<th>dept_no</th>
						<th>dept_name</th>
					</tr>
				</thead>
				<tbody>
				<%
					while(rs.next()){
				%>
						<tr>
							<td><%=rs.getString("dept_no") %></td>
							<td><%=rs.getString("dept_name") %></td>
						</tr>
				<%
					}
				%>
				</tbody>
			</table>
			<br />
			
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
			<form method="post" action="<%=request.getContextPath()%>/departmentsList.jsp">
				<div class="input-group"> 
					<div class="input-group-prepend btn">
						부서 이름 검색 : 
					</div>
					<div class="input-group-prepend">
						<input class="form-control" type="text" name="searchDept" value=<%=searchDept %>>
					</div>
					<div class="input-group-prepend">
						<button type="submit" class="btn btn-outline-success">검색</button>
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