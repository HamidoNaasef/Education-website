<%@page import="Edu_Website.*"%>
<%@page import="java.util.ArrayList"%>
<%
    if (session.getAttribute("G-userId") == null || session.getAttribute("G-userId").equals("")){
        response.sendRedirect("../index.jsp");
    }else{
        String sheetId = request.getParameter("ansersheet");
        String studentId = sheetId.substring(sheetId.indexOf('s'));
        ArrayList<HPair> studentAnswers = new ArrayList<>();
        Exam exam = new Exam();
        Student student = new Student();
        Question question = new Question();
        student.get_user_data(studentId);
        studentAnswers = exam.get_answers_from_file(sheetId);
    
%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Egy-Edu | <%=student.get_fname() %>'s Answers</title>
        <link href="..//css-pages//inner-pages.css" rel="stylesheet" type="text/css"/>
        <script>
            /*function checkexamname(){
                
            }*/
        /////////////////////////////////////////////////////////////////////////////////////
        /*function justifyheight(){
            console.log());
            
        }*/
        </script>
    </head>
    <body>
        <!-- Header Block -->
        <div class = "header">
            <a href="../index.jsp"><h2>Egy</h2><h2>Edu</h2><h4>.net</h4> </a>
            <img src = "../images/ohpbackground.jpg">
        </div>
        <div class = "addExamContent" >
            <h2> Exam Name</h2>
            <h4>Name: <span><%=student.getFullName(studentId) %></span></h4>
            <div class = "examQestions">
                <ol Type="1">
                    <%
                        int counter = studentAnswers.size();
                        for(int i = 0; i < counter; i++){
                            question.get_question(studentAnswers.get(i).getID());
                    %>
                    <li><%=question.get_qhead()%>
                        <ol type="a" class="qlist">
                            <li id = "correctans" <%if(question.get_ans().equals(studentAnswers.get(i).getDataA())){out.print("class = 'studans'");}%>><%=question.get_ans() %></li>
                            <li <%if(question.get_choiceA().equals(studentAnswers.get(i).getDataA())){out.print("class = 'studans'");}%> ><%=question.get_choiceA() %></li>
                            <li <%if(question.get_choiceB().equals(studentAnswers.get(i).getDataA())){out.print("class = 'studans'");}%> ><%=question.get_choiceB() %></li>
                            <li <%if(question.get_choiceC().equals(studentAnswers.get(i).getDataA())){out.print("class = 'studans'");}%> ><%=question.get_choiceC() %></li>
                        </ol>
                    </li>
                    <br>
                    <%
                        }
                    %>


                </ol>
            </div>
        </div
        <%
            }
        %>
        
    </body>
</html>
