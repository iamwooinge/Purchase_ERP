<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
 <%@ page import = "java.sql.*" %>
 <%@page import="util.DatabaseUtil" %>
 <%@ page import="java.util.Date" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.text.*"%>
<%@ page import="javax.naming.*"%>
 
 
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
<title>물품 구매 내역서</title>

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
.search th{
   color: gray;
}
</style>

</head>
<body>

<%  
//SQL 연동 코드
Connection conn = null;
PreparedStatement pstmt = null;
ResultSet rs = null;
PreparedStatement pstmt2 = null;
ResultSet rs2 = null;
int hap = 0;

   try{
   Class.forName("com.mysql.cj.jdbc.Driver");
   
   String jdbcUrl = "jdbc:mysql://localhost:3306/purchasing_manage?serverTimezone=UTC";
   String dbid = "root";
   String dbpass="1234";
   
   conn = DriverManager.getConnection(jdbcUrl, dbid, dbpass);
   
   System.out.println("Success");

   
      //##########################################################
   //사원코드->사원명 품번->품명 변환 기본코드
      String sql = "select t1.income_no,t1.income_return_no, t3.employee_name, t1.client_name,t2.product_name, t1.product_standard,t1.product_unit, t1.order_date, t1.product_count, t1.product_unitprice, t1.product_supply, t1.order_vat, t1.order_price, t1.income_date, t1.income_count,t1.nincome_count,t1.income_state,t1.income_category from income t1, product t2, employee t3 where t1.product_no = t2.product_no and t1.employee_no = t3.employee_no ";
   //총합계 구하기
    String sql2 = "select sum(t1.order_price) from income t1, product t2, employee t3 where t1.product_no = t2.product_no and t1.employee_no = t3.employee_no ";
   //청구현황 검색창에서 입력값/체크박스값 받아오기
      request.setCharacterEncoding("utf-8"); //파라미터로 값 넘어갈 때 한글 안깨지게
      String start_date = request.getParameter("start_set_mb");   //시작일자
      String end_date = request.getParameter("end_set_mb");       //끝일자
      String employee_name = request.getParameter("manager");       //담당자
      String client_name = request.getParameter("account"); //거래처 
      String income_category = request.getParameter("type"); //입고유형
      String income_state =  request.getParameter("state"); //입고상태
      
      
      String[] check = null;
      
      check = request.getParameterValues("condition");   //체크박스 체크 여부
      if (check != null){ //체크박스 값 넘어가는지 콘솔 출력 확인용
         for(int i=0;i<check.length;i++){
            System.out.println(check[i]+income_category);
         }
   
         for(int i=0;i<check.length;i++){
            if(check[i].equals("일자") && start_date != "" &&end_date !=""){ 
               sql += "and date(income_date) between '"+start_date+"' and '"+end_date+"' ORDER BY t1.income_num DESC";
               sql2 += "and date(income_date) between '"+start_date+"' and '"+end_date+"' ORDER BY t1.income_num DESC";
            }else if(check[i].equals("담당자") && employee_name !=""){ 
               sql += "and t3.employee_name ='"+employee_name+"' ORDER BY t1.income_num DESC";
               sql2 += "and t3.employee_name ='"+employee_name+"' ORDER BY t1.income_num DESC";
               
            }else if(check[i].equals("거래처") && client_name !=""){
               sql += "and t1.client_name like '%"+client_name+"%' ORDER BY t1.income_num DESC";
               sql2 += "and t1.client_name like '%"+client_name+"%' ORDER BY t1.income_num DESC";
            }else if(check[i].equals("입고유형") && income_category !=""){
               if(income_category.equals("all")){
                  sql += "ORDER BY t1.income_num DESC";
                  sql2 += "ORDER BY t1.income_num DESC";
               }else{
                  sql += "and t1.income_category like '"+income_category+"%' ORDER BY t1.income_num DESC";
                  sql2 += "and t1.income_category like '"+income_category+"%' ORDER BY t1.income_num DESC";
               }
               
            }else if(check[i].equals("입고상태") && income_state !=""){
               if(income_state.equals("all")){
                  sql += "ORDER BY t1.income_num DESC";
                  sql2 += "ORDER BY t1.income_num DESC";
               }else{
                  sql += "and t1.income_state like '"+income_state+"%' ORDER BY t1.income_num DESC";
                  sql2 += "and t1.income_state like '"+income_state+"%' ORDER BY t1.income_num DESC";
               }
            }
         
         }
         
   
      }else{
         sql += "ORDER BY t1.income_num DESC";
         sql2 += "ORDER BY t1.income_num DESC";
      }
       
   pstmt = conn.prepareStatement(sql);
   rs = pstmt.executeQuery(sql);
   pstmt2 = conn.prepareStatement(sql2);
   rs2= pstmt2.executeQuery(sql2);      
   if(rs2.next()){
       hap = rs2.getInt(1);
   }
    %>
<br>
<br>
<br>
<br>
<form method="post" action="receipt.jsp" align="center">
    <table class="search" border = "1px" style="width: 890px; background-color: #eeeeee; margin:0 auto; align="center""> 
               <thead>
                 <tr>
                   <td class="td_check"><input type="checkbox" name="condition" id="check_date" value="일자"></td>
                   <th>일자</th>
                   <td><input type = "date" name = "start_set_mb" class="search_date"> - <input type = "date" name = "end_set_mb" class="search_date"></td>
                   <td><input type="checkbox" name="condition" value="거래처" ></td>
	                   <th>거래처</th>
	                   <td>
				            <select name = "account" class="search_input" style="width: 115px;">
				                   <option>선택</option>
				                   <option value = "싱싱청과">싱싱청과</option>
				                   <option value = "달콤청과">달콤청과</option>
				                   <option value = "저염상회">저염상회</option>
				                   <option value = "고운 고춧가루">고운 고춧가루</option>
				                   <option value = "서대문 포장">서대문 포장</option>
				            </select>
	                </td>
                   </tr>
                   <tr>
                   <td class="td_check"><input type="checkbox" name="condition" value="담당자" id="check_manager"></td>
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
                   <td><input type="checkbox" name="condition" value="입고유형"></td>
                   <th>입고유형</th>
                   <td>
	               <select name = "type" class="search_input">
	                   <option>선택</option>
	                   <option value = "정상입고">정상입고</option>
	                   <option value = "반품">반품</option>
	                   <option value = "교환출고">교환출고</option>
	                   <option value = "교환입고">교환입고</option>
	                </select>
                   
                   </td>
                   	  
                   </tr>
                   <tr>
                       <td class="search_btn" style="border-left: none;"colspan="9">
                         <div class="search_btn_billing">    
                                 <button type="submit" class="button button2">검색</button>
                                 <button type="submit" class="button button2">초기화</button>
                           </div> 
                       </td>
                   </tr>
                   
               </thead>
            </table>

   
</form>

<div align="center" >
<form style="display:inline-block;" id ="pdfArea" class="page">

<div id='dd'>

<h1 align="center"> 물품 구매 내역서</h1>

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
   <table id = "apftable" align="center" width="100%" style="font-size: 12px;">
   <thead>
      <tr>
         
         <th>주문 번호</th>
         <th>입고 유형</th>
         
         <th>담당자명</th>
         <th>거래처명</th>
         <th>품명</th>
         <th>규격</th>
         <th>단위</th>
         <th>단가</th>
         <th>금액</th>
         <th>부가세</th>
         <th>총액</th>
         
         <th>주문 수량</th>
         
      </tr>
      </thead>
      <tbody>
      <tr>
      <%
         while(rs.next()){
         int product_count = rs.getInt("product_count");
         int income_count = rs.getInt("income_count");
         int nincome_count = rs.getInt("nincome_count");
         //천단위 콤마 
         DecimalFormat df = new DecimalFormat("###,###");
         String product_unitprice = df.format(rs.getInt("product_unitprice"));
         String product_supply = df.format(rs.getInt("product_supply"));
         String order_vat = df.format(rs.getInt("order_vat"));
         String order_price = df.format(rs.getInt("order_price"));
         //
                  %>
     
      <td align="center"><%=rs.getString("income_no")%></td> <!--주문번호-->
        <td align="center"><%=rs.getString("income_category")%></td> <!--입고유형-->
      
      <td align="center""><%=rs.getString("employee_name")%></td> <!--담당자명-->
      <td align="center"><%=rs.getString("client_name")%></td> <!--거래처명-->
      <td align="center"><%=rs.getString("product_name")%></td> <!--품명-->
      <td align="center"><%=rs.getInt("product_standard")%></td> <!--규격-->
      <td align="center"><%=rs.getString("product_unit")%></td> <!--단위-->
      <td align="center"><%=product_unitprice%></td> <!--단가-->
      <td align="center"><%=product_supply%></td> <!--공급가액-->
      <td align="center"><%=order_vat%></td> <!--부가세-->
      <td align="center"><%=order_price%></td> <!--금액-->
      
      <td align="center"><%=product_count %></td> <!--주문수량-->
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
         <tr>
         <th colspan='10'>합계</th>
         <%  
         DecimalFormat df = new DecimalFormat("###,###");
         String all_hap = df.format(hap);%>
         <td align="center"><%=all_hap%></td>
         </tr>
      </tbody>
   </table>
   <br>
   <br>
   </div>
   </form>
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