<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>index</title>
<!-- boot strap 4 -->
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
<link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.7.0/css/all.css" integrity="sha384-lZN37f5QGtY3VHgisS14W3ExzMWZxybE1SJSEsQp9S+oqd12jhcu+A56Ebc1zFSJ" crossorigin="anonymous">
<style>
</style>
</head>
<body>
	<div class="container" style="background-color:white">
		<!-- Top Menu -->
		<div class="">
			<div>
				<nav class="navbar navbar-expand-sm bg-success navbar-dark">
					<ul class="navbar-nav">
						<li class="nav-item active">
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
		<!-- Page Content --
		<div class="container mt-3">
			<h1>Employees</h1>
		</div>
		<!-- footer -->
		<div class="navbar navbar-expand-sm bg-success mt-5" style="height:50px">
		</div>
	</div>
</body>
</html>