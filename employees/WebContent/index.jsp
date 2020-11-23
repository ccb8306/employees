<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>index</title>
<style>
	img{
		width:437px; height:595px; 
		opacity: 0.3;
		}
	.main{
		position: absolute;
		}
	h3{color:red;}
</style>
</head>
<body>
	<h1>Employees</h1>
	<div class="main">
		<img src="./image/main.JPG">
	</div>
	<div class="main">
		<h3><br />코딩이 제일 쉬운 하루였다.<br /> by 김주성(1998~2020)</h3><br/><br />
		<a href="./employeesList.jsp?currentPage=1">-- employees</a><br /><br />
		<a href="./departmentsList.jsp?currentPage=1">-- departmentsList</a><br /><br />
		<a href="./deptEmpList.jsp?currentPage=1">-- deptEmpList</a><br /><br />
		<a href="./deptManagerList.jsp?currentPage=1">-- deptManagerList</a><br /><br />
		<a href="./salariesList.jsp?currentPage=1">-- salariesList</a><br /><br />
		<a href="./titlesList.jsp?currentPage=1">-- titlesList</a>
	</div>
</body>
</html>