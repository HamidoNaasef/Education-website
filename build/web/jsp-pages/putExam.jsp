<%@page import="Edu_Website.*"%>
<%
    if (session.getAttribute("G-userId") == null || session.getAttribute("G-userId").equals("")){
        response.sendRedirect("../index.jsp");
    }else{
        Subject subject = new Subject();
        if(session.getAttribute("G-userType").toString() == "stud"){
            response.sendRedirect("../jsp-pages/StudentHomePage.jsp");
        }
        if(!subject.is_id_exist(request.getParameter("examSubID"))){
//            response.sendRedirect("../jsp-pages/teacherSubject.jsp");
        }else{
            String subjectId = request.getParameter("examSubID").toString();
        
%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Egy-Edu | Add Exam</title>
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
                    <input type="text" name="exam-name" required="" onclick="checkexamname()"><br>
                    
                    <label> Start-date</label>
                    <label class = "exam-time"> Duration (by Minutes)</label><br>
                    
                    <input type="date" name="exam-start-date" required="" >
                    <input type="text" name="duration" required=""  oninput="this.value = this.value.replace(/[^0-9.]/g, '').replace(/(\..*)\./g, '$1');this.value = this.value.replace(/\s/g, '');"><br>
                    
                    <label> End-date</label>
                    <label class = "exam-time"> &nbsp; End-time</label><br>
                    
                    <input type="date" name="exam-end-date" required="" >
                    <input type="time" name="exam-end-time" required="" ><br>
                    
                    
                    
                    
                </div>

                <div class = "examQestions">
                    <ol Type="1">
                        <%
                            int counter = Integer.parseInt(request.getParameter("numberOfQuestions"));
                            for(int i = 0; i < counter; i++){
                        %>
                        <li>
                            <textarea name = "question-<%=i%>" class="Q-head" maxlength="300" required="" ></textarea>
                            <ol type="a">
                                <li><textarea name = "q-<%=i%>-correct" type="text" placeholder="(Please write here the correct answer)" maxlength="150" required="" ></textarea></li>
                                <li><textarea name = "q-<%=i%>-A" type="text" maxlength="150" required="" ></textarea> </li>
                                <li><textarea name = "q-<%=i%>-B" type="text" maxlength="150" required="" ></textarea> </li>
                                <li><textarea name = "q-<%=i%>-C" type="text" maxlength="150" required="" ></textarea> </li>
                            </ol>
                        </li>
                        <br>
                        <%
                        }
                        %>
                        
                        
                    </ol>
                </div>
                        <button formmethod="POST" formaction="../addExam?subId=<%=subjectId %>&numofq=<%=request.getParameter("numberOfQuestions")%>"> Submit Exam </button>
            </form>
        </div>
                        
        <%
            }
        }
        %>
    </body>
</html>
