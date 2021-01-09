<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<title>deptEmptList</title>
<!-- boot strap 4 -->
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
<link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.7.0/css/all.css" integrity="sha384-lZN37f5QGtY3VHgisS14W3ExzMWZxybE1SJSEsQp9S+oqd12jhcu+A56Ebc1zFSJ" crossorigin="anonymous">

</head>
<body>
	
	<!-- 내용 -->
	<div>
		<%
			request.setCharacterEncoding("utf-8");
			boolean deptOption = false;
			String deptName = "전체";
			// 페이지 주소
			String address = "";
			
			// 검색 받기
			if(request.getParameter("deptName") != null){
				deptName = request.getParameter("deptName");
			}
			
			if(request.getParameter("deptOption") != null){
				if(request.getParameter("deptOption").equals("on"))
					deptOption = true;
				else
					deptOption = false;
			}
			
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
			String sql = "";
			String sql2 = "";
			PreparedStatement stmt = null;
			PreparedStatement stmt2 = null;
			int cnt = 0;
			
			// 근무중인 아닌 사람까지 출력
			if(!deptOption){
				// 전체부서 선택일 경우
				if(deptName.equals("전체")){
					sql = "SELECT emp_no,dept_no,from_date,to_date FROM dept_emp ORDER BY emp_no ASC LIMIT ?, ?";
					stmt = conn.prepareStatement(sql);
					stmt.setInt(1, (currentPage-1) * 10);
					stmt.setInt(2, rowPage);
					sql2 = "select count(*) as cnt from dept_emp";
					stmt2 = conn.prepareStatement(sql2);
					address = "/deptEmpList.jsp?deptOption=off&deptName=전체&";					
				}
				// 한 부서 선택일 경우
				else{
					sql = "select * from dept_emp where dept_no = ? order by emp_no asc limit ?,?";
					stmt = conn.prepareStatement(sql);
					stmt.setString(1, deptName);
					stmt.setInt(2, (currentPage-1) * 10);
					stmt.setInt(3, rowPage);				
					sql2 = "select count(*) as cnt from dept_emp where dept_no = ?";
					stmt2 = conn.prepareStatement(sql2);
					stmt2.setString(1, deptName);
					address = "/deptEmpList.jsp?deptOption=off&deptName=" + deptName + "&";			
				}	
			// 근무중인 사람 출력
			}else{
				// 전체부서
				if(deptName.equals("전체")){
					sql = "SELECT emp_no,dept_no,from_date,to_date FROM dept_emp where to_date = '9999-01-01' ORDER BY emp_no ASC LIMIT ?, ?";
					stmt = conn.prepareStatement(sql);
					stmt.setInt(1, (currentPage-1) * 10);
					stmt.setInt(2, rowPage);
					sql2 = "select count(*) as cnt from dept_emp where to_date = '9999-01-01'";
					stmt2 = conn.prepareStatement(sql2);
					address = "/deptEmpList.jsp?deptOption=on&deptName=전체&";				
				}
				// 한 부서
				else{
					sql = "select * from dept_emp where to_date = '9999-01-01' and dept_no = ? order by emp_no asc limit ?,?";
					stmt = conn.prepareStatement(sql);
					stmt.setString(1, deptName);
					stmt.setInt(2, (currentPage-1) * 10);
					stmt.setInt(3, rowPage);				
					sql2 = "select count(*) as cnt from dept_emp where to_date = '9999-01-01' and dept_no = ?";
					stmt2 = conn.prepareStatement(sql2);
					stmt2.setString(1, deptName);
					address = "/deptEmpList.jsp?deptOption=on&deptName=" + deptName + "&";					
				}
			}
			
			// 4. 쿼리문 결과 저장
			ResultSet rs = stmt.executeQuery();

			// 페이지 최대 개수 구하기
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
							<a class="nav-link" href="<%=request.getContextPath()%>/departmentsList.jsp?currentPage=1">departmentsList</a>
						</li>
						<li class="nav-item">
							<a class="nav-link active" href="<%=request.getContextPath()%>/deptEmpList.jsp?currentPage=1">deptEmpList</a>
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
					DeptEmp List
				</span>	
			</h1>
			<table class="table">
				<thead style="background-color:#E0FFDB">
					<tr>
						<th>emp_no</th>
						<th>dept_no</th>
						<th>from_date</th>
						<th>to_date</th>
					</tr>
				</thead>
				<tbody>
				<%
					while(rs.next()){
				%>
						<tr>
							<td><%=rs.getString("emp_no") %></td>
							<td><%=rs.getString("dept_no") %></td>
							<td><%=rs.getString("from_date") %></td>
							<td><%=rs.getString("to_date") %></td>
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
			<!-- 조건 선택 -->
			<%
				String sql3 = "select dept_no from departments order by dept_no asc";
				PreparedStatement stmt3 = conn.prepareStatement(sql3);
				ResultSet rs3 = stmt3.executeQuery();
				
			%>
			<div class="mt-3">
				<form method="post" action="<%=request.getContextPath()%>/deptEmpList.jsp">
					<div class="input-group">
						<div class="input-group-prepend">
							<div class="form-check">
								<div class="checkbox">
	  								<label>
		  								<input type="checkbox" name="deptOption"
										<%
											if(deptOption){
										%>
											checked="checked"
										<%
											}
										%>
										>	
									재직중
	  								</label>
								</div>
							</div>
						</div>
						<div class="input-group-prepend ml-5">
							<select class="form-control" name="deptName">
								<option>==전체==</option>
								<%
								while(rs3.next()){
								%>
									<option
									<%
										if(deptName.equals(rs3.getString("dept_no"))){
									%>
										selected="selected"
									<%
										}
									%>
									><%=rs3.getString("dept_no") %></option>
								<%
								}
								%>
							</select>
						</div>
						<div class="input-group-prepend">
							<button style="width:120px" type="submit" class="btn btn-outline-success">검색</button>
						</div>
					</div>
				</form>
			</div>
		</div>
		<!-- footer -->
		<div class="navbar navbar-expand-sm bg-success mt-5" style="height:50px">
		</div>
	</div>
</body>
</html>