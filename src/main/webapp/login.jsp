 <%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link rel="stylesheet" href="../css/style.css">
<link href = "login.css" rel = "stylesheet" type = "text/css"> 
<title>로그인</title>
</head>
<body id="login_body">
	<div id = "logincontent" class="login-page"> 
		<div class="form">
		<h2>로그인</h2>
		<form method="post" action="./login_Action.jsp" class="login-form">
			
			<div class="loginID">
				<input type="text" class="input" placeholder="아이디" name="employee_id" maxlength="20">
			</div>
			
			<div class="loginPassword">
				<input type="password" class="input" placeholder="비밀번호"
					name="employee_pw" maxlength="20">
			</div>
			<br>
			<input type="submit" id="button" value="로그인">
		</form>
		</div>
	</div>
</body>
</html>