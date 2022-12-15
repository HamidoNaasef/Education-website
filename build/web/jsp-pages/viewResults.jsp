<%@page import="java.util.ArrayList"%>
<%@page import="Edu_Website.*"%>
<%
    if (session.getAttribute("G-userId") == null || session.getAttribute("G-userId").equals("")){
        response.sendRedirect("../index.jsp");
    }else{
        Exam exam = new Exam();
        String examId = request.getParameter("examID");
        
        if(session.getAttribute("G-userType").toString() == "stud"){
            response.sendRedirect("../jsp-pages/StudentHomePage.jsp");
        }
        if(!exam.is_exam_exist(examId)){
            response.sendRedirect("../jsp-pages/teacherSubject.jsp");
        }else{
            ArrayList<HPair> studentGrades = exam.get_student_grades(examId);
            
%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Egy-Edu | View Results</title>
        <link href="..//css-pages//inner-pages.css" rel="stylesheet" type="text/css"/>
        <script src='https://kit.fontawesome.com/a076d05399.js' crossorigin='anonymous'></script>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
        
    </head>
    <body>
        <!-- Header Block -->
        <div class = "header">
            <a href="../index.jsp"> </a>
            <img src = "../images/ohpbackground.jpg">            
        </div>
        <!-- mid content -->
        <div class = "Tstud-grades">
            <nav>
                <img src = "../images/arrow.png" alt = "back to home page" onclick = "location.href = '../index.jsp';">
                <h1 id = "subname"> Subject Name</h1>
                <h2>(Student(s) Grades)</h2>
            </nav>
            
            
            <table>
                <thead>
                    <tr>
                        <th>Name</th>
                        <th>Grade</th>
                        <th>Student Answer</th>
                    </tr>
                </thead>
                <tbody>
                    
                    <%
                        for(int i = 0; i < studentGrades.size(); i++){
                    %>
                    <tr>
                        <td><%=studentGrades.get(i).getDataA()%></td>
                        <td><%=studentGrades.get(i).getDataB()%></td>
                        <td>
                            <form method="post">
                                <input type="hidden" name="ansersheet" value="<%=studentGrades.get(i).getID()%>">
                                <button formaction = "studentexamanswers.jsp"> View Answer</button>
                            </form>
                        </td>
                        
                    </tr>
                   
                    <%
                       }
                   %>
                   
                </tbody>
            </table>
        </div>
        
        
        
        
        
        
        
        <%
            }
        }
        %>
        <!-- Footer block -->
        <footer class = "footer">
            <img src = "../images/line.png"><br>
            <div class = "devoFooter">
                <ul style = "list-style-type: none;">
                    <h4>Developers</h4>
                    <li>
                        <a href="https://www.facebook.com/abdelhamid.nasef.5" target="_blank">
                            <i class="fa fa-facebook-square" aria-hidden="true" style="color:rgb(216, 219, 225);font-size: 14px; margin-right: 4px;"></i>Eng.Abd El-Hamid Nasef
                        </a>
                    </li>
                    <li>
                        <a href="https://www.facebook.com/profile.php?id=100012812267337" target="_blank">
                            <i class="fa fa-facebook-square" aria-hidden="true" style="color:rgb(216, 219, 225);font-size: 14px; margin-right: 4px;"></i>Eng.Abdalla Adly
                        </a>
                    </li>
                </ul>
            </div>
            <div class = "devoFooter">
                <ul style = "list-style-type: none;">
                    <h4>egy-edu Owner</h4>
                    <li>
                        <a href="https://www.facebook.com/profile.php?id=100004511610422" target="_blank">
                            <i class="fa fa-facebook-square" aria-hidden="true" style="color:rgb(216, 219, 225);font-size: 14px; margin-right: 4px;"></i>Mr\ Walid Khamis
                        </a>
                    </li>
                </ul>
            </div>
            <div class = "devoFooter">
                <ul style = "list-style-type: none;">
                    <h4>Related links</h4>
                    <li>
                        <a href="https://www.ekb.eg" target="_blank"><i class="fas fa-book-reader" style="color:rgb(216, 219, 225)"></i>
                           بنك المعرفة
                        </a>
                    </li>
                    <li>
                        <a href="https://study.ekb.eg" target="_blank"><i class="fas fa-book-reader" style="color:rgb(216, 219, 225)"></i>
                            منصة المذاكرة الرقمية
                        </a>
                    </li>
                    <li>
                        <a href="https://office365.emis.gov.eg" target="_blank"><i class="fas fa-book-reader" style="color:rgb(216, 219, 225)"></i>
                            الحساب المدرسى الالكترونى 
                        </a>
                    </li>
                    <li>
                        <a href="https://moe-register.emis.gov.eg" target="_blank"><i class="fas fa-book-reader" style="color:rgb(216, 219, 225)"></i>
                            تسجيل استمارة التقدم للامتحان الاليكترونى
                            </a>
                    </li>
                </ul>
            </div>
        </footer>
    </body>
</html>
