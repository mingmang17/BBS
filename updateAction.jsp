<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import = "bbs.BbsDAO" %>
<%@ page import = "bbs.Bbs" %>
<%@ page import = "java.io.PrintWriter" %>
<% request.setCharacterEncoding("UTF-8"); %>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title>JSP 게시판 웹 사이트</title>
	</head>
	<body>
		<%
			//이미 로그인 된 사람은 회원가입 페이지에 접속할수 없게 한다.
			String userID = null;
			if(session.getAttribute("userID") != null){
				userID = (String)session.getAttribute("userID");
			}
			if (userID == null){ //로그인을 안한경우
				PrintWriter script = response.getWriter();
				script.println("<script>");
				script.println("alert('로그인을 하세요')");
				script.println("location.href = 'login.jsp'");
				script.println("</script>");
			} 
			int bbsID=0;
			//update.jsp에서 url파라메터로 보낸 bbsID를 받는다.
			if(request.getParameter("bbsID")!=null){
				bbsID= Integer.parseInt(request.getParameter("bbsID"));
			}
			if(bbsID==0){ //bbsID가 존재하지않으면 alert띄우고 bbs.jsp로 돌려보냄
				PrintWriter script = response.getWriter();
				script.println("<script>");
				script.println("alert('유효하지 않은 글입니다.')");
				script.println("location.href = 'bbs.jsp'");
				script.println("</script>");
			}
			Bbs bbs = new BbsDAO().getBbs(bbsID);//작성자로 bbs를 가져옴
			if(!userID.equals(bbs.getUserID())){
				PrintWriter script = response.getWriter();
				script.println("<script>");
				script.println("alert('수정권한이 없습니다.')");
				script.println("location.href = 'view.jsp'");
				script.println("</script>");
			} else{
				if(request.getParameter("bbsTitle") == null || request.getParameter("bbsContent") == null 
					|| request.getParameter("bbsTitle").equals("") || request.getParameter("bbsContent").equals("")){
						PrintWriter script = response.getWriter();
						script.println("<script>");
						script.println("alert('입력되지 않은 사항이 있습니다.')");
						script.println("history.back()");//이전페이지로 돌려보냄
						script.println("</script>");
					}else{
						BbsDAO bbsDAO = new BbsDAO();
						int result = bbsDAO.update(bbsID,request.getParameter("bbsTitle"),request.getParameter("bbsContent"));
						if(result == -1){
							PrintWriter script = response.getWriter();
							script.println("<script>");
							script.println("alert('글 수정에 실패했습니다.')");
							script.println("history.back()");
							script.println("</script>");
						}else {
							PrintWriter script = response.getWriter();
							script.println("<script>");
							script.println("location.href='bbs.jsp'");
							script.println("</script>");
						}
					}		
			}
			
			
		%>		
    </body>
</html>