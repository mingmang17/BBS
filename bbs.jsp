<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import = "java.io.PrintWriter" %>
<%@ page import = "bbs.BbsDAO" %>
<%@ page import = "bbs.Bbs" %>
<%@ page import = "java.util.ArrayList" %>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<meta name="viewport" content="width=device",initial-scale="1">
		<link rel="stylesheet" href="css/bootstrap.css">
		<script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
		<title>JSP 게시판 웹 사이트</title>
	</head>
	<style type="text/css">
		a{
			color: #000000;
			text-decoration:none;
		}
		a:hover{
			color: #000000;
			text-decoration:none;
			font-weight:600;
		}
	</style>
	<body>
		<%
			//로그인 성공한 사람들은 userID로 세션값을 갖고,로그인을 안한 사람은 null
			String userID = null;
			if(session.getAttribute("userID") != null){
				userID = (String)session.getAttribute("userID");
			}
			int pageNumber = 1; //기본페이지
			if(request.getParameter("pageNumber") != null){
				pageNumber = Integer.parseInt(request.getParameter("pageNumber"));
			}
			System.out.println(pageNumber);
		%>
 		<nav class="navbar navbar-default">
  			<div class="navbar-header">
   				<button type="button" class="navbar-toggle collapsed"
    				data-toggle="collapse" data-target="#bs-example-navbar-collapse-1"
    				aria-expanded="false">
  				 	<span class="icon-bar"></span>
   				 	<span class="icon-bar"></span>
   					<span class="icon-bar"></span>
  				</button>  
  				<a class="navbar-brand" href="main.jsp">JSP 게시판 웹사이트</a>
 			</div>
 			<div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
  				<ul class="nav navbar-nav">
  					<li><a href="main.jsp">메인</a>
   					<li class="active"><a href="main.jsp">게시판</a>
  				</ul>
  				<%
  				//로그인 안한 사람들만 로그인/회원가입 보이게
  					if(userID == null){
  				%>
  				<ul class="nav navbar-nav navbar-right">
   					<li class="dropdown">
    					<a href="#" class="dropdown-toggle"
    						data-toggle="dropdown" role="button" aria-haspopup="true"
    						aria-expanded="false">접속하기<span class="caret"></span></a>
    					<ul class="dropdown-menu">
   				 			<li><a href="login.jsp">로그인</a></li>
    						<li ><a href="join.jsp">회원가입</a></li>
   						</ul>
    				</li>
    			</ul>		
  				<%
  					} else {
  						
  				%>
  				<ul class="nav navbar-nav navbar-right">
   					<li class="dropdown">
    					<a href="#" class="dropdown-toggle"
    						data-toggle="dropdown" role="button" aria-haspopup="true"
    						aria-expanded="false">회원관리<span class="caret"></span></a>
    					<ul class="dropdown-menu">
   				 			<li><a href="logoutAction.jsp">로그아웃</a></li>
   						</ul>
    				</li>
    			</ul>
    			<%
  					}
    			%>	
    		</div>
    	</nav>
    	<div class="container">
    		<div class="row">
    			<table class="table table-striped" style="text-align=center; border: 1px solid #dddddd">
    				<thead>
    					<tr>
    						<th style="backgroud-color: #eeeeee; text-align=center;">번호</th>
    						<th style="backgroud-color: #eeeeee; text-align=center;">제목</th>
    						<th style="backgroud-color: #eeeeee; text-align=center;">작성자</th>
    						<th style="backgroud-color: #eeeeee; text-align=center;">작성날짜</th>
    					</tr>
    				</thead>
    				<tbody>
    					<%
    						BbsDAO bbsDAO = new BbsDAO(); //BbsDAO객체화
    						ArrayList<Bbs> list = bbsDAO.getList(pageNumber);//getList함수 호출
    						for(int i = 0; i < list.size(); i++){
    					%>	
    					<tr>
    						<td><%=list.get(i).getBbsID() %></td>
    						<!-- 제목을 눌렀을때 view.jsp로 이동하면서 해당 bbsID를 파라메터로 보낸다. -->
    						<td><a href="view.jsp?bbsID=<%=list.get(i).getBbsID() %>">
    						<%=list.get(i).getBbsTitle().replaceAll(" ","&nbsp;").replaceAll("<", "&lt;") 
    								.replaceAll(">", "&gt;").replaceAll("\n", "<br>") %></a></td>
    						<td><%=list.get(i).getUserID() %></td>
    						<!-- bbsDate를 보기쉽게 substring함수 사용 -->
    						<td><%=list.get(i).getBbsDate().substring(0,11) + list.get(i).getBbsDate().substring(11,13) +"시" 
    							+list.get(i).getBbsDate().substring(14,16) + "분"
    							    %></td>
    					</tr>
    					<% }%>
    				</tbody>
    			</table>
    			<%
    				if(pageNumber != 1){
    			%>
    				  <a href="bbs.jsp?pageNumber=<%=pageNumber-1%>" class="btn btn-success btn-arraw-left">이전</a>
    			<%} if(bbsDAO.nextPage(pageNumber+1)){%> <!-- 다음페이지가 존재하는지 물어봐야하니까 +1-->
    				  <a href="bbs.jsp?pageNumber=<%=pageNumber+1%>" class="btn btn-success btn-arraw-left">다음</a>
    			<%} %>
    			<a href="write.jsp" class="btn btn-primary pull-right">글쓰기</a>
    		</div>
    	</div>
		<script src="js/bootstrap.js"></script>
    </body>
</html>