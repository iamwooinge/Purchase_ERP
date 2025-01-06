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
<title>물품 구매 신청서</title>

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
    margin: 4px 2px;
    -webkit-transition-duration: 0.4s; /* Safari */
    transition-duration: 0.4s;
    cursor: pointer;
    
    
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

.button2 {
  background:#454545;
  color:#fff;
  border:none;
  width: 100px;
  height:25px;
  font-size:0.85em;
  line-height:25px;
  padding:0 2em;
  cursor:pointer;
  transition:800ms ease all;
  outline:none;
}

.button2:hover {
 background:#8b8b8b;
}

select {
width: 110px;
padding: .5em .3em;
border: 1px solid #999;
font-family: inherit;
border-radius: 0px;

}

input[type=date] {
width: 150px;
padding: .5em .3em;
border: 1px solid #999;
font-family: inherit;
border-radius: 0px;

}

[class^=count-] tr {
  counter-increment: mycounter;
}
[class^=count-] tr>td:first-child:before {
  content: counter(mycounter) " ";
}
.count-1 tr:nth-child(1) { counter-reset: mycounter; }
.count-2 tr:nth-child(2) { counter-reset: mycounter; }
}

</style>

</head>
<body>

<%  
   //SQL 연동 코드
   Connection conn = null;
   PreparedStatement pstmt = null;
   ResultSet rs = null;
   
      try{
       Class.forName("com.mysql.cj.jdbc.Driver");
       
       String jdbcUrl = "jdbc:mysql://localhost:3306/purchasing_manage?serverTimezone=UTC";
       String dbid = "root";
       String dbpass="1234";
       
       conn = DriverManager.getConnection(jdbcUrl, dbid, dbpass);
       
       System.out.println("Success");
    
       
      //##########################################################
       //사원코드->사원명 품번->품명 변환 기본코드
      String sql = "select t1.claim_date,t1.claim_no,t2.product_name,t3.employee_name,t1.product_amount, t1.product_standard,t1.product_unit,t1.claim_state from claim t1, product t2, employee t3 where t1.product_no = t2.product_no and t1.employee_no = t3.employee_no ";
      
       //청구현황 검색창에서 입력값/체크박스값 받아오기
      request.setCharacterEncoding("utf-8"); //파라미터로 값 넘어갈 때 한글 안깨지게
       String start_date = request.getParameter("start_set_mb");   //시작일자
      String end_date = request.getParameter("end_set_mb");       //끝일자
      String employee_name = request.getParameter("manager");       //담당자
      String product_Name = request.getParameter("Product_Name"); //품명
      String[] check = null;
      
      check = request.getParameterValues("condition");   //체크박스 체크 여부
      if (check != null){ //체크박스 값 넘어가는지 콘솔 출력 확인용
         for(int i=0;i<check.length;i++){
            System.out.println(check[i]+employee_name);
         }
   
         for(int i=0;i<check.length;i++){
            if(check[i].equals("일자") && start_date != "" &&end_date !=""){ 
               sql += "and date(claim_date) between '"+start_date+"' and '"+end_date+"'";
               
            }else if(check[i].equals("담당자") && employee_name !=""){ 
               sql += "and t3.employee_name ='"+employee_name+"'";
               
            }else if(check[i].equals("품명") && product_Name !=""){
               sql += "and t2.product_Name like '%"+product_Name+"%'";
            }
         
         }
         
   
      }
      
       
       pstmt = conn.prepareStatement(sql);
      rs = pstmt.executeQuery(sql);
            
      
    %>
<br>
<br>
<br>
<br>
<form method="post" action="application_form.jsp" align="center" >

 <table class="search" border = "1px" style="width: 890px; background-color: #eeeeee; " align="center" margin:0 auto;>
               <thead>
                 <tr>
                   <td class="td_check"><input type="checkbox" name="condition" id="check_date" value="일자"></td>
                   <th>일자</th>
                   <td><input type = "date" name = "start_set_mb" class="search_date"> - <input type = "date" name = "end_set_mb" class="search_date"></td>
                   <td class="td_check"><input type="checkbox" name="condition" value="담당자" id="check_manager"/></td>
                   <th>담당자</th>
                   <td>
                   <select name = "manager" class="search_input">
                         <option value = "">선택</option>
                         <option value = "홍길동">홍길동</option>
                         <option value = "김현정">김현정</option>
                         <option value = "이예닮">이예닮</option>
                         <option value = "추민하">추민하</option>
                         <option value = "장홍도">장홍도</option>
                         <option value = "이우주">이우주</option>
                      </select>
                     </td>
                   <td class="td_check"> <input type="checkbox" name="condition" value="품명" id="check_pName"></td>
                   <th>품명</th>
                   <td>
                   <select name = "Product_Name" class="search_input">
                         <option value = "">선택</option>
                         <option value = "고랭지 배추">고랭지 배추</option>
                         <option value = "제주 햇무">제주 햇무</option>
                         <option value = "청송 꿀 사과">청송 꿀 사과</option>
                         <option value = "나주 배">나주 배</option>
                         <option value = "의성 햇마늘">의성 햇마늘</option>
                         <option value = "햇 고춧가루">햇 고춧가루</option>
                         <option value = "신안 천일염">신안 천일염</option>
                         <option value = "액젓">액젓</option>
                         <option value = "젓갈">젓갈</option>
                         <option value = "박스테이프">박스테이프</option>
                         <option value = "아이스박스">아이스박스</option>
                          <option value = "비닐">비닐</option>
                      </select>
                   </td> 
                   </tr>
                   <tr>
                       <td class="search_btn" style="border-left: none;"colspan="9">  
                            <button type="submit" class="button button2">검색</button>
                            <button type="submit" class="button button2">초기화</button>
 
                       </td>
                   </tr>
                   
               </thead>
            </table>
  
</form>

<div align="center" >
<form style="display:inline-block;" id ="pdfArea" class="page">

<div id='dd'>

<h1 align="center"> 물품 구매 신청서</h1>

<p style="clear:both;">&nbsp;</p>

   <div style="float:right;">
      <table >
         <tr>
         <th colspan='7'>결재</th>
         </tr>
         <tr>
         <th rowspan='2' style="padding: 5px;">신청부서</th>
         <th style="padding: 5px;">담당자</th>
         <th style="padding: 5px;">팀장</th>
         <th rowspan='2' style="padding: 5px;">담당부서</th>
         <th style="padding: 5px;">담당자</th>
         <th style="padding: 5px;">팀장</th>
         <th style="padding: 5px;">본부장</th>
         </tr>
         
         <tr>
         <td>&nbsp;</td>
         <td>&nbsp;</td>
         <td>&nbsp;</td>
         <td>&nbsp;</td>
         <td>&nbsp;</td>
         </tr>
      </table>
   </div>
   <p style="clear:both;">&nbsp;</p>
   <div align="left">
   <b><%=sf.format(nowTime) %>기준</b>
   </div>
   <br>
   <table id = "apftable" class='count-1' align="center" width="100%" style="font-size: 12px;">
   <thead>
      <tr>
         <th>No.</th>
         <th>청구 일자</th>
         <th>주문 번호</th>
         <th>품명</th>
         <th>담당자</th>
         <th>수량</th>
         <th>규격</th>
         <th>단위</th>   
      </tr>
      </thead>
      <tbody>
      <%
         while(rs.next()){
                  %>
      <tr>
         <td align="center"></td>
         <td align="center"><%=rs.getString("claim_date")%></td> <!--청구일자-->
            <td align="center""><%=rs.getString("claim_no")%></td> <!--주문번호-->
            <td align="center""><%=rs.getString("product_name")%></td> <!--품명-->
            <td align="center"><%=rs.getString("employee_name")%></td> <!--담당자-->
            <td align="center"><%=rs.getInt("product_amount")%></td> <!--수량-->
            <td align="center"><%=rs.getString("product_standard")%></td> <!--규격-->
            <td align="center"><%=rs.getString("product_unit")%></td> <!--단위-->
            
      </tr>
      <%         
            }
         
         }catch(Exception e){
         
         }finally {
            if ( rs != null ) try{rs.close();}catch(Exception e){} 
             if ( pstmt != null ) try{pstmt.close();}catch(Exception e){}
             if ( conn != null ) try{conn.close();}catch(Exception e){}
         }
         
         %>
      </tbody>
   </table>
   <br>
   <br>
   </div>
   </from>
</div>
   
   <div style="width:100%;" align="center">
   <form align="center">
      <input type="button" class="button button1" value="파일 저장" onclick="savePDF()"/>
      <input type="button" class="button button1" value="창 닫기" onclick="opener.location.reload();window.close();"/>
   </form>
   </div>
   <br>
   <br>
<script> 
   function windowClose(){ 
      opener.location.reload(); 
      window.close(); 
   } 
   
   

</script>

<script type="text/javascript">

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
      doc.save('물품구매신청서.pdf');
    });
  }
</script>

</body>
</html>