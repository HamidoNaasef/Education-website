<%@page import="java.util.ArrayList"%>
<%@page import="Edu_Website.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    if (session.getAttribute("G-userId") == null || session.getAttribute("G-userId").equals("")){
        response.sendRedirect("../index.jsp");
    }else{
        Subject subject = new Subject();
        Exam exam = new Exam();
        ArrayList<HPair> examSchedule = new ArrayList<>();
        ArrayList<HPair> enrolledStudents = new ArrayList<>();
        
        if(session.getAttribute("G-userType").toString() == "stud"){
            response.sendRedirect("../jsp-pages/StudentHomePage.jsp");
        }
        
        if(!subject.is_id_exist(request.getParameter("subjectid"))){
            response.sendRedirect("../jsp-pages/TeacherHomePage.jsp");
        }else{
        
        String subject_id = request.getParameter("subjectid");
        
        String sub_name = subject.get_subjectName(subject_id);
        examSchedule = exam.get_exams_of_subject(subject_id);
        enrolledStudents = subject.get_enrolled_student_names(subject_id);
        
        
        for(int i = 0; i < examSchedule.size(); i++){
            examSchedule.get(i).setDataB( String.valueOf(exam.get_attendance(examSchedule.get(i).getID())) );
        }
%>
<!DOCTYPE html>
<html>
    <head>
        <title>Egy-Edu | <%=sub_name%></title>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link href="..//css-pages//inner-pages.css" rel="stylesheet" type="text/css"/>
        <script src='https://kit.fontawesome.com/a076d05399.js' crossorigin='anonymous'></script>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
        <script>
            
            /////////////////////////////////////////////////////////////////////////////////////////
            function showTab(tabName) {
                document.getElementById("exam").style.boxShadow = "none";
                document.getElementById("exam").style.backgroundColor = "transparent";
                
                document.getElementById("matrial").style.boxShadow = "none";
                document.getElementById("matrial").style.backgroundColor = "transparent";
                
                document.getElementById("codeandpass").style.boxShadow = "none";
                document.getElementById("codeandpass").style.backgroundColor = "transparent";
                
                document.getElementById("matrialTab").style.display = "none";
                document.getElementById("codeandpassTab").style.display = "none";
                document.getElementById("examTab").style.display = "none";
                
                
                document.getElementById(tabName +"Tab").style.display = "block";
                
                        
                document.getElementById(tabName).style.boxShadow = "rgba(0, 0, 0, 0.1) 0px 4px 12px";
                document.getElementById(tabName).style.backgroundColor  = "rgba(21, 22, 22, 0.5)";
                    
            }
            /////////////////////////////////////////////////////////////////////////////////////////
            
        </script>
    </head>
    <body>
        <!-- Header Block -->
        <div class = "header">
            <a href="../index.jsp"> </a>
            <img src = "../images/ohpbackground.jpg">
            
            
        </div>
        <!-- mid content -->
        <div class = "Tsub-content">
            <nav>
                
                <h3 onclick = "document.getElementById('popupwindowstudname').style.display = 'block';"><img src = "../images/user handmade purple.png"> <%=subject.count_enrolled_students(subject_id)%></h3>
                <h3 id = "subname"><%=sub_name%></h3>
                <button onclick="document.getElementById('numofQ').style.display = 'block';"> Add Exam </button>
            </nav>
            
            <button id = "exam" class = "tab" onclick="showTab('exam')" >Exam(s)</button>
            <button id = "matrial" class = "tab" onclick="showTab('matrial')" >Materials</button>
            <button id = "codeandpass" class = "tab" onclick="showTab('codeandpass')" >code& password</button>
            <br><br>
            <div id = "matrialTab" >
            </div>
            
            
            <div id = "codeandpassTab" >
                <h4><b>Code:</b> <%=subject.get_code_and_pass_by_id(subject_id).getID()%> </h4>
                <h4><b>Pass:</b> <%=subject.get_code_and_pass_by_id(subject_id).getDataA()%></h4>
                
            </div>
            
            
            <div id = "examTab" >
                <table>
                    <thead>
                        <tr>
                            <th>Name</th>
                            <th>Attendance</th>
                            <th>Student result</th>
                            <th>Edit Exam</th>
                            <th>Delete Exam</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            for(int i = 0; i < examSchedule.size(); i++){
                        %>
                                <tr>
                                    <td><%=examSchedule.get(i).getDataA()%></td>
                                    <td><%=examSchedule.get(i).getDataB()%></td>
                                    <td>
                                        <form method="post">
                                            <input type="hidden" name = "examID" value = "<%=examSchedule.get(i).getID()%>">
                                            <button formaction = "viewResults.jsp"> view results</button>
                                        </form>
                                    </td>
                                    <td>
                                        <form method="post">
                                            <input type="hidden" name = "examID" value = "<%=examSchedule.get(i).getID()%>">
                                            <button formaction = "editExam.jsp"> Edit</button>
                                        </form>
                                    </td>
                                    <td>
                                        <form method="post">
                                            <input type="hidden" name = "examID" value = "<%=examSchedule.get(i).getID()%>">
                                            <button formaction = "../deleteExam"> Delete</button>
                                        </form>    
                                    </td>
                                </tr>
                        <%
                            }
                        %>
                    </tbody>
                </table>
                
            </div>
            <div id="numofQ">
                <form method="post">
                    <span onclick="document.getElementById('numofQ').style.display = 'none';document.body.style.filter = 'none';">X</span>
                    <br><br>
                    <label>Enter number of questions</label><br>
                    <input type="text" name="numberOfQuestions" size="3" maxlength="3" required=""  oninput="this.value = this.value.replace(/[^0-9.]/g, '').replace(/(\..*)\./g, '$1');this.value = this.value.replace(/\s/g, '');"><br>
                    <input type="hidden" name = "examSubID" value = "<%=subject_id%>">
                    <button formaction="putExam.jsp"&> Go </button>
                </form>
            </div>
        </div>
                    
        <div id = "popupwindowstudname">
            <span id="dclose" onclick="document.getElementById('popupwindowstudname').style.display = 'none';">X</span>
            <h3>Student(s)</h3>
            <ul>
                <%
                    for(int i = 0; i < enrolledStudents.size(); i++){
                %>
                <li> <%=enrolledStudents.get(i).getDataA()%> <!--button>Ban</button--></li>
                <%
                    }
                %>
            </ul>
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