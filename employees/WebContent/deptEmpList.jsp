<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<title>deptEmptList</title>
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
					address = "./deptEmpList.jsp?deptOption=off&deptName=전체&";					
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
					address = "./deptEmpList.jsp?deptOption=off&deptName=" + deptName + "&";			
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
					address = "./deptEmpList.jsp?deptOption=on&deptName=전체&";				
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
					address = "./deptEmpList.jsp?deptOption=on&deptName=" + deptName + "&";					
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
		<!-- 메뉴 -->
		<button id="btnMenu" type="button" onclick="location.href='./index.jsp'">HOME</button>
		<button id="btnMenu" type="button" onclick="location.href='./employeesList.jsp?currentPage=1'">employeesList</button>
		<button id="btnMenu" type="button" onclick="location.href='./departmentsList.jsp?currentPage=1'">departmentList</button>
		<button id="btnMenu" type="button" onclick="location.href='./deptEmpList.jsp?currentPage=1'">deptEmpList</button>
		<button id="btnMenu" type="button" onclick="location.href='./deptManagerList.jsp?currentPage=1'">deptManagerList</button>
		<button id="btnMenu" type="button" onclick="location.href='./salariesList.jsp?currentPage=1'">salariesList</button>
		<button id="btnMenu" type="button" onclick="location.href='./titlesList.jsp?currentPage=1'">titlesList</button>
		
		<h1>deptEmp 테이블 목록</h1>
		<table border="1">
			<thead>
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
		
	
	</div>
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
		
	</div><br /><br />
	
	<!-- 조건 선택 -->
	<%
		String sql3 = "select dept_no from departments order by dept_no asc";
		PreparedStatement stmt3 = conn.prepareStatement(sql3);
		ResultSet rs3 = stmt3.executeQuery();
		
	%>
	<div>
		<form method="post" action="./deptEmpList.jsp">
			<div>
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
				<select name="deptName">
					<option>전체</option>
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
			<button type="submit">검색</button>
		</form>
	</div>
</body>
</html>