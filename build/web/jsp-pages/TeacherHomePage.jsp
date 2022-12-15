<%@page import="Edu_Website.*"%>
<%@page import="java.util.ArrayList"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    if (session.getAttribute("G-userId") == null || session.getAttribute("G-userId").equals("")){
        response.sendRedirect("../index.jsp");
    }else if(session.getAttribute("G-userType").toString() == "stud"){
        response.sendRedirect("../jsp-pages/StudentHomePage.jsp");
    }else{
        
        String T_id = session.getAttribute("G-userId") + "";
        Teacher teacher = new Teacher();
        User user = new User();
        Notification not = new Notification();
        Subject wsubjet= new Subject();
        ArrayList<HPair> w2estudents = new ArrayList<>();
        
        ArrayList<HPair> Teachersubjects = teacher.getTeacherSubjects(T_id);
        ArrayList<HPair> notlist = not.get_teacher_notification(T_id);
        w2estudents = wsubjet.get_w2e_students(T_id);
%>
    
<!DOCTYPE html>
<html>
    <head>
        <title>Egy-Edu</title>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link href="..//css-pages//inner-pages.css" rel="stylesheet" type="text/css"/>
        <script src='https://kit.fontawesome.com/a076d05399.js' crossorigin='anonymous'></script>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
        <script>
            var subcode = false;
            var subname= false;
            
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
            function sub_code_Ajax(){
                var elm = document.getElementById("SCcheck");
                var xmlhttp = new XMLHttpRequest();
                xmlhttp.open("GET", "../ajax_subject_code?subCode=" + document.getElementById("subjectCode").value, true);
                xmlhttp.send();
                xmlhttp.onreadystatechange = function() {
                    if (this.readyState === 4 && this.status === 200) {
                        elm.innerHTML = "xmlhttp.responseText";
                        if(xmlhttp.responseText === "True" ){
                            elm.innerHTML = "Code Available!!"; 
                            elm.style.color = "rgb(30, 156, 30)";                
                            subcode = true;
                        }else{
                            elm.innerHTML = "Code already exist!!";
                            elm.style.color = "rgb(205, 157, 14)";
                            subcode = false;
                        }
                    } 
                };
            }
            /////////////////////////////////////////////////////////////////////////////////////////
            function sub_name_Ajax(){
                var elm = document.getElementById("SNcheck");
                var xmlhttp = new XMLHttpRequest();
                xmlhttp.open("GET", "../ajax_subject_name?subname=" + document.getElementById("subjectName").value, true);
                xmlhttp.send();
                xmlhttp.onreadystatechange = function() {
                    if (this.readyState === 4 && this.status === 200) {
                        elm.innerHTML = "xmlhttp.responseText";
                        if(xmlhttp.responseText === "True" ){
                            elm.innerHTML = "Name Available!!"; 
                            elm.style.color = "rgb(30, 156, 30)";                
                            subname = true;
                        }else{
                            elm.innerHTML = "Name already exist!!";
                            elm.style.color = "rgb(205, 157, 14)";
                            subname = false;
                        }
                    } 
                };
            }
            /////////////////////////////////////////////////////////////////////////////////////////
            function submit_new_subject(){
                var x = document.getElementById("addsubjectbttn");
                if(subcode === false || subname === false ){
                    x.disabled = true;
                    x.style.opacity = "0.5";
                    document.getElementById("confirmMassage").innerHTML = "Hint: can't use code or name that is invalid or already exist";
                }else{
                    x.disabled = false;
                    x.style.opacity = "1";
                    document.getElementById("confirmMassage").innerHTML = "Are you sure you want to submit?";
                }
            }
        </script>
    </head>
    <body>
        <!-- Header Block -->
        <div class = "header">
            <a href="../index.jsp">
                <div>
                    <h2>Egy-Edu</h2>
                    <h4>.net</h4>
                    
                </div>
            </a>
            <img src = "../images/ohpbackground.jpg">
        </div>

        <!-- content block -->
        <div class = "content">
            <!-- Teacher subject block -->
            <div class = "side-bar">
                <button onclick="document.getElementById('add-subject').style.display = 'block';">Add Subject</button>
                <%    
                    for(int i = 0; i <Teachersubjects.size(); i++){
                        
                %>
                <a href = "../jsp-pages/teacherSubject.jsp?subjectid=<%=Teachersubjects.get(i).getID()%>"><p id = "subject"> <%=Teachersubjects.get(i).getDataA()%> </p></a>
                <%
                    }
                %>
            </div>
            
            <!-- mid content block -->
            <div class = "mid-content">
                <%
                    if(w2estudents.size() > 0){
                %>
                    <h1>Waiting students to be enrolled</h1>
                    <div class = "enroll-waiting-stud">
                         <%
                            String currentSubject = "";
                            String enrollmentLink;
                            for(int i = 0; i < w2estudents.size(); i++){
                                enrollmentLink = "../accept_refeuse_enrollment?subId=" + w2estudents.get(i).getID() + "&studId=" + w2estudents.get(i).getDataB() + "&statue=";
                                if(currentSubject.equals(w2estudents.get(i).getDataA())){
                        %>
                                    <ul>
                                        <li><span><%=user.getFullName(w2estudents.get(i).getDataB()) %></span> <a class = "accept-to-enroll" href ="<%=enrollmentLink%>+Accept">Accept</a><a href ="<%=enrollmentLink%>+Refuse">Refuse</a> </li>
                                    </ul>
                        <%
                                }else{
                                currentSubject = w2estudents.get(i).getDataA();

                        %>

                        <p class = "ews-sub-name"><%=w2estudents.get(i).getDataA()%></p>
                        <ul>
                            <li><span><%=user.getFullName(w2estudents.get(i).getDataB()) %></span> <a class = "accept-to-enroll" href ="<%=enrollmentLink%>+Accept">Accept</a><a href ="<%=enrollmentLink%>+Refuse">Refuse</a> </li>
                        </ul>
                    
                    <%
                            }
                        }
                    %>
                </div>
                <%
                    }else{
                %>
                    <h1>No students in waiting queue</h1>
                <%
                    }
                %>
            </div>
        </div>
        
        <!-------   some user needs    -->
        <div class = "user-fname" onclick="turnArrow()">
            <h6><%=teacher.getFullName(T_id)%></h6>
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
              for(int i = 0; i < notlist.size(); i++){
                  if(notlist.get(i).getDataB() == "" ){
            %>
                        <a> -<%=notlist.get(i).getDataA()%> </a>
                        
            <%
                }else{
                
            %>
                        <a href="../jsp-pages/teacherSubject.jsp?subjectid=<%=notlist.get(i).getDataB()%>"> -<%=notlist.get(i).getDataA()%> </a>
                        
            <%    
                }
              }  
            %>
        </div>
        
        <!--    add subject block         -->
        <div id = "add-subject">
            <span id = "closeX" onclick="document.getElementById('add-subject').style.display = 'none';"> X </span>
            <form id = "addSubjectForm">
                <label class = "addsubheader">Add New Subject</label><br>
                <br><br><br>
                <label class = "subnm-lbl" >Subject Name</label>
                
                <label class = "subyear-lbl">Year</label>
                <br>
                
                <input id = "subjectName" type="text" name="subject-name" minlength="6" maxlength="30" required="" oninput = "sub_name_Ajax();this.value = this.value.replace('\'', '');">
                <span id = "SNcheck"></span>
                
                <select name="subject-year">
                    <option value="1" selected="">1</option>
                    <option value="2">2</option>
                    <option value="3">3</option>
                </select>
                <br><br>
                
                
                <label class = "subcode-lbl">Code</label><span id = "SCcheck"></span>
                <label class = "subpass-lbl">Password</label><br>
                
                <input id = "subjectCode" type="text" name="subject-code" minlength="5" maxlength="10" required=""  oninput="sub_code_Ajax();this.value = this.value.replace('\'', '');this.value = this.value.replace(/[^\u0000-\u007F ]+/, '');this.value = this.value.replace(/\s/g, '');">
                <input type="text" name="subject-password" minlength="5" maxlength="10" required="" oninput="this.value = this.value.replace('\'', '');"><br>
                <br><br><br>
            </form>            
            <button onclick = "document.getElementById('confirmationWindow').style.display = 'block' ;submit_new_subject()" > Submit </button>
        </div>

        <div id = "confirmationWindow">
            <span onclick="document.getElementById('confirmationWindow').style.display = 'none' ;"> X </span>
            <h2>Confirm Message</h2>
            <p id = "confirmMassage"></p>

            <button id = "addsubjectbttn" form = "addSubjectForm" formaction="../addNewSubject" > Submit </button>
        </div>
        
        <%}%>
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