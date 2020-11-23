<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<title>departments 테이블 목록</title>
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
				address = "./departmentsList.jsp?searchDept=" + searchDept + "&";
				
			}else{
				sql = "SELECT dept_no,dept_name FROM departments ORDER BY dept_no desc LIMIT ?,?";
				stmt = conn.prepareStatement(sql);
				stmt.setInt(1, (currentPage-1) * 10);
				stmt.setInt(2, rowPage);
				sql2 = "SELECT count(*) as cnt FROM departments";
				stmt2 = conn.prepareStatement(sql2);
				address = "./departmentsList.jsp?";
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
		<!-- 메뉴 -->
		<button id="btnMenu" type="button" onclick="location.href='./index.jsp'">HOME</button>
		<button id="btnMenu" type="button" onclick="location.href='./employeesList.jsp?currentPage=1'">employeesList</button>
		<button id="btnMenu" type="button" onclick="location.href='./departmentsList.jsp?currentPage=1'">departmentList</button>
		<button id="btnMenu" type="button" onclick="location.href='./deptEmpList.jsp?currentPage=1'">deptEmpList</button>
		<button id="btnMenu" type="button" onclick="location.href='./deptManagerList.jsp?currentPage=1'">deptManagerList</button>
		<button id="btnMenu" type="button" onclick="location.href='./salariesList.jsp?currentPage=1'">salariesList</button>
		<button id="btnMenu" type="button" onclick="location.href='./titlesList.jsp?currentPage=1'">titlesList</button>
		
		<h1>departments 테이블 목록</h1>
		<table border="1">
			<thead>
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
		
	</div>
	<br /><br />
	<!-- 검색 -->
	<div>
		<form method="post" action="./departmentsList.jsp">
			<div>
				부서 이름 검색 : <input type="text" name="searchDept" value=<%=searchDept %>>
			</div>
			<button type="submit">검색</button>
		</form>
	</div>
</body>
</html>