<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11.2.0/dist/sweetalert2.all.min.js"></script>
<meta charset="UTF-8">
<title>로그아웃</title>
</head>
<body>
<%
   session.invalidate();
%>

<script type="text/javascript">
   swal.fire({
      title : '로그아웃 되었습니다',
      icon : 'success'
   }).then((result) => {
      if(result.isConfirmed) {
         
               window.location.href='./main.jsp'
      }
   })

</script>
</body>
</html>