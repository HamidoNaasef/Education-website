<%@page import="java.time.format.DateTimeFormatter"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.text.DateFormat"%>
<%@page import="Edu_Website.*"%>
<%@page import="java.util.ArrayList"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    if (session.getAttribute("G-userId") == null || session.getAttribute("G-userId").toString().equals("")){
        response.sendRedirect("../index.jsp");
    }else{
        if(session.getAttribute("G-userType").toString() == "teach"){
            response.sendRedirect("../jsp-pages/TeacherHomePage.jsp");
        }
        User student = new Student();
        Subject subject = new Subject();
        Notification not = new Notification();
        Exam exam = new Exam();
        Question question = new Question();
        
        String sub_id = "";
        String stud_id = session.getAttribute("G-userId").toString();
        ArrayList<HPair> studnet_subject= new ArrayList<>();
        ArrayList<String> studw2benrolled = new ArrayList<>();
        ArrayList<HPair> sub_exams = new ArrayList<>();
                
        studnet_subject = subject.get_student_subjects(stud_id);
        studw2benrolled = subject.get_student_w2besubjects(stud_id);
        ArrayList<HPair> notlist = not.get_student_notification(stud_id);
        sub_exams = exam.get_exams_of_subject(request.getParameter("subId"));
                
        
%>
<!DOCTYPE html>
<html>
    <head>
        
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Egy-Edu</title>
        <link href="..//css-pages//inner-pages.css" rel="stylesheet" type="text/css"/>
        <script src='https://kit.fontawesome.com/a076d05399.js' crossorigin='anonymous'></script>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
        
        <script>
            var subcode = false;
            function turnArrow(){
                var x = document.getElementById("arrow-down");
                if(x.style.transform === 'rotate(180deg)'){
                    x.style.transform = 'rotate(0deg)';
                    document.getElementById("userinfo").style.display = "none";
                }else{
                    x.style.transform = 'rotate(180deg)';
                    document.getElementById("userinfo").style.display = "block";
                }
            }
            /////////////////////////////////////////////////////////////////////////////////////////                
            function notiList(){
                var x = document.getElementById("notifications");
                if(x.style.display === "none"){
                    x.style.display = "block";
                }else{
                    x.style.display = "none";
                }
                
            }
            /////////////////////////////////////////////////////////////////////////////////////////
            function ajax_subject_code(){
                var x = document.getElementById("code-f-check");
                var xmlhttp = new XMLHttpRequest(); 
                xmlhttp.open("GET", "../ajax_subject_code?subCode=" + document.getElementById("subjectEnCode").value, true);
                xmlhttp.send();
                
                
                xmlhttp.onreadystatechange = function() {
                    if (this.readyState === 4 && this.status === 200) {
                        if(xmlhttp.responseText === "True" ){
                            x.innerHTML = "Subject isn't Exist!!"; 
                            x.style.color = "rgb(205, 157, 14)";                
                            subcode = false;
                        }else{
                            x.innerHTML = "Subject Exist!!";
                            x.style.color = "rgb(30, 156, 30)";
                            subcode = true;
                        }
                    } 
                };
            }
            /////////////////////////////////////////////////////////////////////////////////////////
            function confirmEnrollment(){
                if(subcode === false){
                    document.getElementById("submitEnrollment").disabled = true;
                    document.getElementById("confirmMassage").innerHTML = "Hint: Code is not Exist!";
                    document.getElementById("submitEnrollment").style.opacity = "0.5";
                }else{
                    document.getElementById("submitEnrollment").disabled = false;
                    document.getElementById("confirmMassage").innerHTML = "Are you sure you want to submit?";
                    document.getElementById("submitEnrollment").style.opacity = "1";
                }
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
            
        <!-- content block -->
        <div class = "content">
            
            <!-- Side bar -->
            <!-- student subject block -->
            <div class = "side-bar">
                <button onclick="document.getElementById('enroll-to-subject').style.display = 'block';">Enroll to Subject</button>
                <%
                    for(int i = 0; i < studnet_subject.size(); i++){
                %>
                <a href = "../jsp-pages/StudentHomePage.jsp?subId=<%=studnet_subject.get(i).getID()%>"><p id = "subject"> <%=studnet_subject.get(i).getDataA()%> </p></a>  
                <%
                    }
                %>
                
                
                
                <h5 class = "braekWord">Waiting to be accepted</h5>
                <%
                    for(int i = 0; i < studw2benrolled.size(); i++){
                %>
                        <p id = "waiting-to-enroll"> <%=studw2benrolled.get(i)%></p>
                
                <%
                    }
                %>
            </div>
            
            <!-- mid content block -->
            <div class = "mid-content">
                <%
                    sub_id = request.getParameter("subId");
                    if(subject.is_id_exist(sub_id) && subject.is_student_enrolled(stud_id, sub_id)){
                %>
                    <div class = "Tsub-content">
                        <h2><%=subject.get_subjectName(sub_id) %>'s Exam(s) schedule</h2>
                        
                        <table>
                            <thead>
                                <tr>
                                    <th>Name</th>
                                    <th>Start Date</th>
                                    <th>Start Time</th>
                                    <th>End Date</th>
                                    <th>End Time</th>
                                    <th>Start Exam</th>
                                    <th>Student result</th>
                                </tr>
                            </thead>
                            <tbody>
                            <%
                                for(int i = 0; i < sub_exams.size(); i++){
                                    exam.get_exam_info(sub_exams.get(i).getID()); 

                            %>
                                    <tr>
                                        <td> <%=sub_exams.get(i).getDataA()%></td>
                                        <td> <%=exam.get_sdate() %></td>
                                        <td> 12:00 AM</td>
                                        <td> <%=exam.get_edate() %></td>
                                        <td> <%=exam.get_etime().toLocalTime().format(DateTimeFormatter.ofPattern("hh:mm a")) %></td>

                                        <%
                                            if(exam.is_examed(sub_exams.get(i).getID(), stud_id) ){
                                        %>
                                        <td><button disabled=""><%=exam.get_student_grade(sub_exams.get(i).getID(), stud_id) %>/<%=question.count_exam_questions(sub_exams.get(i).getID()) %></button></td>
                                        <%
                                            }else if(exam.can_exam(sub_exams.get(i).getID() )){
                                        %>
                                        <td>
                                            <form method="post">
                                                <input type="hidden" name="examId" value="<%=sub_exams.get(i).getID() %>">
                                                <button formaction = "confirmationToExam.jsp">Start Exam</button>
                                            </form>
                                        </td>
                                        <%
                                            }else{
                                        %>
                                                <td><button onclick = "window.alert('Exam isn`t available right now!!'+'\n'+'you can not exam before(after) the exam time')"> Start Exam</button></td>
                                        <%
                                            }
                                        %>

                                        <%
                                            if(exam.can_view_answer(sub_exams.get(i).getID() )){
                                        %>
                                            <td>
                                                <form method="post">
                                                    <input type="hidden" name="ansersheet" value="<%=sub_exams.get(i).getID() + stud_id%>">
                                                    <button formaction = "studentexamanswers.jsp"> Show your answers</button>
                                                </form>
                                            </td>
                                        <%
                                            }else{
                                        %>
                                            <td><button onclick = "window.alert('Answers will be available after exam time')"> Show your answers</button></td>
                                        <%
                                            }
                                        %>

                                    </tr>
                            <%
                                }
                            %>
                            </tbody>
                        </table>
                            
                    </div>
                <%
                    }else{
                %>
                    <h1>No subject was selected!!</h1>
                
                <%
                    }
                %>
            </div>
        
            <!-------   some user needs    -->
            <div class = "user-fname" onclick="turnArrow()">
                <h6><%=student.getFullName(stud_id) %></h6>
                <img id = "arrow-down" src="..//images/purple down arrow.png">
            </div>

            <!-------   notification block    -->

            <div id = "userinfo">
                <a href = "../jsp-pages/Profile.jsp"><img src="../images/user handmade purple.png" alt="Profile"><br> &nbsp; Profile</a><br>
                <a href = "../logOut"><img src="../images/logout purple.png" id = "logout"><br> &nbsp;Log Out</a>

            </div>
            
            <div id = "notif-bell">
                <img src="../images/noti bell.png" onclick = "notiList()">
            </div>
            
            <div id = "notifications">
                <%
                    if(notlist.size() > 0){
                        for(int i = 0; i < notlist.size(); i++){
                            if(notlist.get(i).getDataB() == "" ){
                %>
                                <a> -<%=notlist.get(i).getDataA()%> </a>
                        
                <%
                        }else{
                
                %>
                            <a href="../jsp-pages/StudentHomePage.jsp?subId=<%=notlist.get(i).getDataB()%>"> -<%=notlist.get(i).getDataA()%> </a>
                        
                <%    
                            }
                       }  
                    }else{
                %>  
                
                        <span id = 'no-info' > No notification right now!!</span>"
               <%
                   }
                %>

            </div>
            
            <!--    enroll to subject block         -->
            <div id = "enroll-to-subject">
                <span id = "closeX" onclick="document.getElementById('enroll-to-subject').style.display = 'none';"> X </span>
                <form id = "enrollform" >
                    <label class = "addsubheader">Enroll to Subject</label><br>
                    <br><br><br>
                    

                    <label class = "subcode-lbl">Code</label>
                    <label class = "subpass-lbl">Password</label><br>

                    <input type="text" id = "subjectEnCode"  name="subject-enroll-code" minlength="5" maxlength="10" required="" oninput="ajax_subject_code();this.value = this.value.replace(/[^\u0000-\u007F ]+/, '');this.value = this.value.replace(/\s/g, '');">
                    <input type="text" name="subject-password" minlength="5" maxlength="10" required=""> <br>
                    <p id = "code-f-check"></p>
                    <br><br><br>
                    
                </form> 
                <button onclick="document.getElementById('confirmationWindow').style.display = 'block';confirmEnrollment();"> Submit </button>           
            </div>
            
            <div id = "confirmationWindow">
                <span onclick="document.getElementById('confirmationWindow').style.display = 'none' ;"> X </span>
                <h2>Confirm Message</h2>
                <p id = "confirmMassage"></p>
                
                <button id = "submitEnrollment" form = "enrollform" formaction = "../goToWaitingQueue"> Submit </button>
            </div>
            
        </div>

        <%
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
