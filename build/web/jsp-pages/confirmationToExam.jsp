
<%@page import="Edu_Website.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%
    if (session.getAttribute("G-userId") == null || session.getAttribute("G-userId").equals("")){
        response.sendRedirect("../index.jsp");
    }else{
        if(session.getAttribute("G-userType").toString() == "teach"){
            response.sendRedirect("../jsp-pages/TeacherHomePage.jsp");
        }
        Exam exam = new Exam();
        if(!exam.is_exam_exist(request.getParameter("examId") )){
            response.sendRedirect("../index.jsp");
        }else{
            String examIDD = request.getParameter("examId");
%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link href="..//css-pages//inner-pages.css" rel="stylesheet" type="text/css"/>
        <title>Egy-Edu | Ready for exam?</title>
        
    </head>
    <body>
        <!-- Go to exam -->
            <div id = "confirm_to_exam">
                <span id = "exit_exam" onclick = "location.href = '../jsp-pages/StudentHomePage.jsp?'">X</span><br>
                
                <%
                    Question question = new Question();
                    exam.get_exam_info(examIDD);
                    session.setAttribute("timerStartValue", exam.get_duration());
                %>
                <h3>Ready For Exam?</h3>
                <h4>Exam Duration: <%=exam.get_duration() %> minute(s)</h4>
                <h4>Number of Questions: <%=question.count_exam_questions(examIDD) %></h4>
                
                <form method="post">
                    <input type = "hidden" name = "examId" value = "<%=examIDD %>">
                    <button formaction = "startExam.jsp" >Start Exam</button>
                </form>
                
            </div>
<%
        }
    }
%>
    </body>
</html>
