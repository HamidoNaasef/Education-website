<%@page import="java.util.ArrayList"%>
<%@page import="Edu_Website.*"%>
<%
    if (session.getAttribute("G-userId") == null || session.getAttribute("G-userId").equals("")){
        response.sendRedirect("../index.jsp");
    }else{
        Exam exam = new Exam();
        Question ques = new Question(); 
        String examId = request.getParameter("examID");
        
        if(session.getAttribute("G-userType").toString() == "stud"){
            response.sendRedirect("../jsp-pages/StudentHomePage.jsp");
        }
        if(!exam.is_exam_exist(examId)){
            response.sendRedirect("../jsp-pages/teacherSubject.jsp");
        }else{
            int numberOfQuestions = ques.count_exam_questions(examId);
            exam.get_exam_info(examId);
            ArrayList<Question> exam_questions = ques.getExamQuestions(examId);
%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Egy-Edu | Edit Exam</title>
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
            <a href="../index.jsp"> </a>
            <img src = "../images/ohpbackground.jpg">
        </div>
        <div class = "addExamContent" >
            <h2> Add New Exam</h2>
            <form>
                <div class = "examInfo">
                    <label> Exam Name</label><br>
                    <input type="text" name="exam-name" value = "<%=exam.get_name()%>" required="" onclick="checkexamname()"><br>
                    
                    <label> Start-date</label>
                    <label class = "exam-time"> Duration (by Minutes)</label><br>
                    
                    <input type="date" name="exam-start-date" value = "<%=exam.get_sdate() %>" required="" >
                    <input type="text" name="duration" required="" value = "<%=exam.get_duration()%>" oninput="this.value = this.value.replace(/[^0-9.]/g, '').replace(/(\..*)\./g, '$1');this.value = this.value.replace(/\s/g, '');"><br>
                    <input type="hidden" name="exam_id" value="<%=examId%>">
                    <label> End-date</label>
                    <label class = "exam-time"> &nbsp; End-time</label><br>
                    
                    <input type="date" name="exam-end-date" value = "<%=exam.get_edate() %>" required="" >
                    <input type="time" name="exam-end-time" value = "<%=exam.get_etime() %>" required="" ><br>
                    
                    
                    
                    
                </div>

                <div class = "examQestions">
                    <ol Type="1">
                        <%
                            ArrayList<String> qids = new ArrayList<>();
                            
                            for(int i = 0; i < numberOfQuestions; i++){
                                qids.add(exam_questions.get(i).get_qid());
                        %>
                        <li>
                            <textarea class="Q-head" name = "<%=exam_questions.get(i).get_qid()%>" maxlength="300" required="" ><%=exam_questions.get(i).get_qhead()%></textarea>
                            <ol type="a">
                                <li><textarea name = "<%=exam_questions.get(i).get_qid()%>-correct" placeholder="(Please write here the correct answer)" maxlength="150" required="" ><%=exam_questions.get(i).get_ans()%></textarea></li>
                                <li><textarea name = "<%=exam_questions.get(i).get_qid()%>-A" maxlength="150" required="" ><%=exam_questions.get(i).get_choiceA()%> </textarea> </li>
                                <li><textarea name = "<%=exam_questions.get(i).get_qid()%>-B" maxlength="150" required="" ><%=exam_questions.get(i).get_choiceB()%></textarea> </li>
                                <li><textarea name = "<%=exam_questions.get(i).get_qid()%>-C" maxlength="150" required="" ><%=exam_questions.get(i).get_choiceC()%></textarea> </li>
                            </ol>
                        </li>
                        <br>
                        <%
                            }
                            session.setAttribute("array", qids);
                        %>
                        
                        
                    </ol>
                </div>
                        <button formmethod="POST" formaction="../editexamservlet?numOfQ=<%=numberOfQuestions%>"> Submit Exam </button>
            </form>
        </div>
                        
    <%
        }
    }
    %>
        
    </body>
</html>
