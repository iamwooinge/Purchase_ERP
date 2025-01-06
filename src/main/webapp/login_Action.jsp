<%@ page language="java" contentType="text/html; charset=UTF-8"
   pageEncoding="UTF-8"%>
<%@ page import="user.UserDAO"%>
<%@ page import="java.io.PrintWriter"%>
<% request.setCharacterEncoding("UTF-8"); %>
<!DOCTYPE html>
<html>
<head>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11.2.0/dist/sweetalert2.all.min.js"></script>
<meta charset="UTF-8">
<title>로그인오류</title>
</head>
<body>
   <%
   String employee_id = request.getParameter("employee_id");
   String employee_pw = request.getParameter("employee_pw");
   UserDAO userDAO = new UserDAO();
   int result = userDAO.login(employee_id, employee_pw);
   if (result == 1) {
      session.setAttribute("employee_no", employee_id);
      out.println("<script>swal.fire({title : '로그인 되었습니다:)',icon : 'success'}).then((result) => {if(result.isConfirmed) {window.location.href='./main.jsp'}})</script>");      
   } else if (result == 0) {
      out.println("<script>swal.fire({title:'아이디/패스워드를 확인해주세요:)',icon:'warning'}).then((result) => {if(result.isConfirmed) {window.history.back();}})</script>");
   } else if (result == -1) {
      out.println("<script>swal.fire({title : '서버오류입니다:(',icon : 'error'}).then((result) => {if(result.isConfirmed) {window.location.href='./main.jsp'}})</script>");
   }
   %>
</body>