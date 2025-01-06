<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
 <%@ page import = "java.sql.*" %>
 <%@page import="util.DatabaseUtil" %>
 <%@ page import="java.util.Date" %>
<%@ page import="java.text.SimpleDateFormat" %>

 
 
<!DOCTYPE html>
<script src ="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<html>
<head>
<script type = "text/javascript" src = "http://code.jquery.com/jquery-latest.min.js"></script>
<script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/jspdf/1.5.3/jspdf.min.js"></script>

<script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/jspdf/1.5.3/jspdf.min.js"></script>
<script type="text/javascript" src="https://html2canvas.hertzen.com/dist/html2canvas.min.js"></script>

<%
Date nowTime = new Date();
SimpleDateFormat sf = new SimpleDateFormat("yyyy년 MM월 dd일");


%>

<meta charset="UTF-8">
<title>발주서</title>

<style>
  table {
    width:100%;
	line-height:21px;
	border-top: 1px solid #cccccc;
	border-left: 1px solid #cccccc;
	border-collapse: collapse;
  }
  th, td {
    
	text-align:center;
	border-right: 1px solid #cccccc;
	border-bottom: 1px solid #cccccc;
	padding: 3px 0;
	text-align:center;
  }
  th {
  	background-color: #eeeeee;
  }
  
  * {
  box-sizing: border-box;
  -moz-box-sizing: border-box;
}

body {
  margin: 0;
  padding: 0;
}

.page {
  width: 21cm;
  min-height: 29.7cm;
  padding: 1.5cm 1.5cm 1.5cm 1.5cm;
}

@page {
  size: A4;
  margin: 0;
}

@media print {
  .page {
    margin: 0;
    border: initial;
    border-radius: initial;
    width: initial;
    min-height: initial;
    box-shadow: initial;
    background: initial;
    page-break-after: always;
  }
}

#dd {
	border-width: 1px;
  	border-style: solid;
  	
  	padding-top :1cm;
  	padding-left : 20px;
  	padding-right : 20px;
  	padding-bottom : 20px;
  	width:19cm;
  	height: 27.7cm;
  	
}

.button {
    
    border: none;
    color: white;
    padding: 8px 10px;
    text-align: center;
    text-decoration: none;
    display: inline-block;
    font-size: 16px;
    margin: 4px 2px;
    -webkit-transition-duration: 0.4s; /* Safari */
    transition-duration: 0.4s;
    cursor: pointer;
    border-radius: 8px;
    
}
.button1 {
  background:#454545;
  color:#fff;
  border:none;
  width: 120px;
  height:30px;
  font-size:0.85em;
  line-height:25px;
  padding:0 2em;
  cursor:pointer;
  transition:800ms ease all;
  outline:none;
  border-radius: 8px;
}

.button1:hover {
    background:#8b8b8b;
}

</style>
</head>
<body> 
   <div style="margin:auto;">
   <form style="display:inline-block; align-content: center;" id ="pdfArea" class="page">
   <br>
   <br>
   <div  id='dd' >
   <h1 align="center"> 발주서</h1>
  
  
   <p style="clear:both;">&nbsp;</p>
   
   <table width="100%">
   <tr>
      <th rowspan='4'>발주처</th>
      <th>발주처명</th>
      <td>(주)서대문김치명가</td>
      <th>사업자번호</th>
      <td>273-52-4885</td>
   </tr>
   <tr>
      <th>담당 부서</th>
      <td>발주팀</td>
      <th>담당자</th>
      <td align="center"> <div id = "employee_name"></div></td>
   </tr>
   <tr>
      <th>전화번호</th>
      <td>02-303-7777</td>
      <th>Fax</th>
      <td>02-300-2727</td>
   </tr>
   <tr>
      <th>주소</th>
      <td colspan="3">서울특별시 서대문구 홍은2동 가좌로 134</td>
   </tr>
   </table>
   <br>
   <br>
   <table width="100%">
   <tr>
      <th rowspan='4' width="76.42px">거래처</th>
      <th width="110.16px">거래처명</th>
      <td align="center" name="client_name" width="216.42px"><div id="client_name"></div></td>
      <th width="125.34px">사업자번호</th>
      <td id ="client_no" name="client_no" width="145.77px"><div id="client_no"></div></td>
   </tr>
   <tr>
   	<th>담당자</th>
   	<td align="center" name="client_manager"><div id="client_manager"></td>
   	<th>Email</th>
   	<td align="center" name="client_email"><div id="client_email"></td>
   </tr>
   <tr>
    <th>전화번호</th>
      <td id ="client_tel" name="client_tel"><div id="client_tel"></div></td>
    <th>Fax</th>
      <td id ="client_fax" name="client_fax"><div id="client_fax"></div></td>
   </tr>
  
   <tr>
      <th>주소</th>
      <td id ="client_address" name="client_address" colspan="3"><div id="client_address"></div></td>
   </tr>
   	
   </table>
   <br>
   <br>
   <table width="100%">
   <tr>
      <th>주문일자</th>
      <td align="center"><div id = "order_date"></div></td>
      <th>주문번호</th>
      <td align="center"> <div id = "order_no"> </div></td>
   </tr>
   <tr>
      <th>품명</th>
      <th>규격</th>
      <th>단위</th>
      <th>발주수량</th>
   </tr>
   <tr>
      <td align="center"> <div id = "product_name"></div></td>
      <td align="center"> <div id = "product_standard"></div></td>
      <td align="center"> <div id = "product_unit"></div></td>
      <td align="center"> <div id = "order_amount"></div></td>
   </tr>
   <tr>
      <th>단가</th>
      <th>금액</th>
      <th>부가세</th>
      <th>총액</th>
   </tr>
   <tr>
      <td align="center"> <div id = "product_unitprice"></div></td>
      <td align="center"> <div id = "product_supply"></div></td>
      <td align="center"> <div id = "order_vat"></div></td>
      <td align="center"> <div id = "order_price"></div></td>
   </tr>
   </table>
   
   <br>
   <br>
   <div align="center">
   <b style="color: gray; ">------------------------------------------------------------------------------------------------</b>
   <br>
   <br>
   <b>위와 같이 발주 합니다.</b>
   <br>
   <br>
   
   <b><%=sf.format(nowTime) %></b>
   </div>
  
   <br>
   <br>
   <br>
   <br>
   
   <div align="right" style="absolute;">
   <b style=" font-size: 150%;" >(주)서대문 김치명가</b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
   <b style=" font-size: 150%; ">(인)</b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
   <br>
   <br>
   <br>
   <br>
   <b style=" font-size: 150%;" id="or_client_name"></b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
   <b style=" font-size: 150%;">(인)</b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
   </div>
   <div style="relative;">
         <img src="./assets/img/Stamp.jpg" style="position:relative; width:60px; height:60px; left:585px; top:-135px; opacity:0.6; "alt="">
   </div>
    
   <br>
   <br>
   
   </div>
   
   </form>
   </div>
   
   <div align="center" style="width: 793.69px">
   <form align="center">
      <input type="button" class="button button1" value="파일 저장" onclick="savePDF()"/>
      <input type="button" class="button button1" value="창 닫기" onclick="opener.location.reload();window.close();"/>
   </form>
   </div>
   
   <br>
   <br>
   
   <script type="text/javascript">
   
   
   function windowClose(){ 
      opener.location.reload(); 
      window.close(); 
   } 
   
   var order_date = opener.document.getElementById("order_date").value;
   var order_no = opener.document.getElementById("order_no").value;
   var employee_name = opener.document.getElementById("employee_name").value;
   var client_name = opener.document.getElementById("client_name").value;
   var product_name = opener.document.getElementById("product_name").value;
   var product_standard = opener.document.getElementById("product_standard").value;
   var product_unit = opener.document.getElementById("product_unit").value;
   var order_amount = opener.document.getElementById("order_amount").value;
   var product_unitprice = opener.document.getElementById("product_unitprice").value;
   var product_supply = opener.document.getElementById("d_product_supply").value;
   var order_vat = opener.document.getElementById("d_order_vat").value;
   var order_price = opener.document.getElementById("d_order_price").value;
   var client_no = opener.document.getElementById("d_client_no").value;
   var client_tel = opener.document.getElementById("d_client_tel").value;
   var client_fax = opener.document.getElementById("d_client_fax").value;
   var client_address = opener.document.getElementById("d_client_address").value;
   //var client_zipcode = opener.document.getElementById("d_client_zipcode").value;
   var client_email = opener.document.getElementById("d_client_email").value;
   var client_manager = opener.document.getElementById("d_client_manager").value;
   
   var or_client_name = opener.document.getElementById("client_name").value;
   
   
   $('#order_date').text(order_date);
   $('#order_no').text(order_no);
   $('#employee_name').text(employee_name);
   $('#client_name').text(client_name);
   $('#product_name').text(product_name);
   $('#product_standard').text(product_standard);
   $('#product_unit').text(product_unit);
   $('#order_amount').text(order_amount);
   $('#product_unitprice').text(product_unitprice);
   $('#product_supply').text(product_supply);
   $('#order_vat').text(order_vat);
   $('#order_price').text(order_price);
   
   $('#client_no').text(client_no);
   $('#client_tel').text(client_tel);
   $('#client_fax').text(client_fax);
   $('#client_address').text(client_address);
   //$('#client_zipcode').text(client_zipcode);
   $('#client_email').text(client_email);
   $('#client_manager').text(client_manager);
   
   $("#or_client_name").text(or_client_name);
   
   

   
  
   
   function savePDF(){
       //저장 영역 div id
       html2canvas($('#pdfArea')[0] ,{   
         //logging : true,      // 디버그 목적 로그
         //proxy: "html2canvasproxy.php",
         allowTaint : true,   // cross-origin allow 
         useCORS: true,      // CORS 사용한 서버로부터 이미지 로드할 것인지 여부
         scale : 2         // 기본 96dpi에서 해상도를 두 배로 증가
         
       }).then(function(canvas) {   
         // 캔버스를 이미지로 변환
         var imgData = canvas.toDataURL('image/png');

         var imgWidth = 190; // 이미지 가로 길이(mm) / A4 기준 210mm
         var pageHeight = imgWidth * 1.414;  // 출력 페이지 세로 길이 계산 A4 기준
         var imgHeight = canvas.height * imgWidth / canvas.width;
         var heightLeft = imgHeight;
         var margin = 10; // 출력 페이지 여백설정
         var doc = new jsPDF('p', 'mm');
         var position = 0;

         // 첫 페이지 출력
         doc.addImage(imgData, 'PNG', margin, position, imgWidth, imgHeight);
         heightLeft -= pageHeight;

         // 한 페이지 이상일 경우 루프 돌면서 출력
         while (heightLeft >= 20) {         // 35
         position = heightLeft - imgHeight;
         position = position - 20 ;      // -25

         doc.addPage();
         doc.addImage(imgData, 'PNG', margin, position, imgWidth, imgHeight);
         heightLeft -= pageHeight;
         }

         // 파일 저장
         doc.save('발주서.pdf');
       });
     }


   </script>
   
</body>
</html>