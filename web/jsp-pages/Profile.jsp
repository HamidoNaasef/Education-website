<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="Edu_Website.User"%>
<%
    User user = new User();
    String userID="";
    if (session.getAttribute("G-userId") == null || session.getAttribute("G-userId").equals("")){
        response.sendRedirect("../index.jsp");
    }else{
        userID = session.getAttribute("G-userId").toString();
        user.get_user_data(userID);
    
    
%>
<!DOCTYPE html>
<html>

    
    <head>
        <title>Egy-Edu | Profile</title>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link href="../css-pages/inner-pages.css" rel="stylesheet" type="text/css"/>
        <script src='https://kit.fontawesome.com/a076d05399.js' crossorigin='anonymous'></script>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
        <script type="text/javascript">
            var gmailc = true;
            var passwordconfc = true;
            var phonec = true;
            var passcheck = false;
            
            //////////////////////////////////////////////////////////////////////////////////
            function showHidePassword(){
              var x  = document.getElementById("oldpass");
              var y = document.getElementById("newpass");
              var z = document.getElementById("confpass");
              var w = document.getElementById("showPassword");
              
              if(x.type === "password"){
                x.type = "text";
                y.type = "text";
                z.type = "text";
                w.innerHTML ="Hide Password!!";
              }else{
                x.type = "password";
                y.type = "password";
                z.type = "password";
                w.innerHTML ="Show Password!!";
              }
            }
            //////////////////////////////////////////////////////////////////////////////////
            function validateGmail(){
                var emailAdress = document.getElementById("gmail").value;
            
                var x = document.getElementById("gmailPCheck");
                let regexEmail = /^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/;
                if (emailAdress.match(regexEmail)) {
                    x.style.color = "rgb(30, 156, 30)";
                    x.innerHTML ="Valid Gmail!!";
                    gmailc = true;
                } else {
                    x.style.color = "rgb(205, 157, 14)";
                    x.innerHTML ="Invalid Gmail!!";
                    gmailc = false;
                }
            }
            //////////////////////////////////////////////////////////////////////////////////
            function checkoldpassword(){
                var elm = document.getElementById("oldPassword");
                var xmlhttp = new XMLHttpRequest();
                xmlhttp.open("GET", "../ajax_oldpass?oldpass=" + document.getElementById("oldpass").value, true);
                xmlhttp.send();
                xmlhttp.onreadystatechange = function() {
                    if (this.readyState === 4 && this.status === 200) {
                        elm.innerHTML = "xmlhttp.responseText";
                        if(xmlhttp.responseText === "True" ){
                            elm.innerHTML = "Correct Password!!"; 
                            elm.style.color = "rgb(30, 156, 30)";                
                            passcheck = true;
                        }else{
                            elm.innerHTML = "Wrong Password!!";
                            elm.style.color = "rgb(205, 157, 14)";
                            passcheck = false;
                        }
                    } 
                };
            }
            //////////////////////////////////////////////////////////////////////////////////
            function passwordConfigCheck(){
                var p  = document.getElementById("newpass").value;
                var pc = document.getElementById("confpass").value;
                var x  = document.getElementById("passconfg");
                
                    x.innerHTML ="Matched password!!";
                if(p === pc){
                    x.style.color = "rgb(30, 156, 30)";
                    x.innerHTML ="Matched password!!";
                    passwordconfc = true;
                } else {
                    x.style.color = "rgb(205, 157, 14)";
                    x.innerHTML ="Not matched password!!";
                    passwordconfc = false;
                }
            }
            /////////////////////////////////////////////////////////////////////////////////
            function phoneNumCheck(){
                var phonenum  = document.getElementById("phonenum").value;
                let ch = phonenum.charAt(0) + phonenum.charAt(1);
                var x  = document.getElementById("phonePerr");
                
                    x.innerHTML ="try Number!!";
                if((ch === "01") && phonenum.length === 11){
                    x.style.color = "rgb(30, 156, 30)";
                    x.innerHTML ="Valid Phone Number!!";
                    phonec = true;
                } else {
                    x.style.color = "rgb(205, 157, 14)";
                    x.innerHTML ="Invalid Phone Number!!";
                    phonec = false;
                }
            }
            /////////////////////////////////////////////////////////////////////////////////
            function formCheck(){
                var x = document.getElementById("profileInfobttn");
                if((gmailc === false) || (passwordconfc === false) || (phonec === false) || (passcheck === false)){
                    x.disabled = true;
                    x.style.opacity = "0.5";
                    document.getElementById("confirmMassage").innerHTML = "Hint: some of your data is invalid or wrong!!";                
                }else{
                    x.disabled = false;
                    x.style.opacity = "1";
                    document.getElementById("confirmMassage").innerHTML = "Are you sure you want to submit?";
                }
            }
            ///////////////////////////////////////////////////////////////////////////////// /////////////////////////////////////////////////////////////////////////////////
            
        </script>
    </head>
    <body>
        <div class = "header">
            <a href="../index.jsp"> </a>
            <img src = "../images/ohpbackground.jpg">
                        
        </div>

        <div class = "content">
            <div class = "profile-form">
                <img src = "../images/arrow.png" alt = "back to home page" onclick = "location.href = '../index.jsp';">
                <form id = "profileForm">
                    <p>Profile</p><br><br><br>
                
                    <label>First Name</label>
                    <label>Last Name</label><br>
                    
                    <input class = "pname" name = "fname" type = "text" maxlength="15" minlength="3" value="<%=user.get_fname()%>" oninput="this.value = this.value.replace('\'', '');">
                    <input class = "pname" name = "lname" type = "text" maxlength="15" minlength="3" value="<%=user.get_lname()%>" oninput="this.value = this.value.replace('\'', '');"><br>
                    
                    <label> User Name<small>(cannot be changed!)</small> </label><br>
                    <input class = "usrname" type = "text"  value="<%=user.get_username()%>" disabled="" oninput="this.value = this.value.replace('\'', '');"><br>
                    
                    <label>Password</label><br>
                    <input id = "oldpass" name = "oldpass" type = "password" maxlength="25" minlength="6" required="" oninput="checkoldpassword();this.value = this.value.replace('\'', '');"><br>
                    <span id = "oldPassword"></span>
                    <span id = "showPassword" onclick = "showHidePassword()">Show Password!!</span>
                    
                    <label>New Password</label><br>
                    <input id = "newpass" name = "newpass" type = "password" maxlength="25" minlength="6" oninput="this.value = this.value.replace('\'', '');passwordConfigCheck();"><br>
                    
                    <label>confirm Password</label><br>
                    <input id = "confpass" name = "configpass" type = "password" maxlength="25" minlength="6" oninput="this.value = this.value.replace('\'', '');passwordConfigCheck();"><br>
                    <span id = "passconfg"></span>
                    
                    
                    <label>Phone Number</label><br>
                    <input id = "phonenum" name = "phone" type = "text" value="0<%=user.get_phone()%>" oninput="this.value = this.value.replace('\'', '');this.value = this.value.replace(/[^0-9.]/g, '').replace(/(\..*)\./g, '$1');this.value = this.value.replace(/\s/g, '');phoneNumCheck()"><br>
                    <span id = "phonePerr"></span>
                    
                    <label>Gmail</label><br>
                    <input id = "gmail" name = "gmail" type = "email" value="<%=user.get_gmail()%>" oninput="validateGmail();this.value = this.value.replace('\'', '');"><br>
                    <span id = "gmailPCheck"></span>
                </form>
                    <button onclick = "document.getElementById('confirmationWindow').style.display = 'block';formCheck();"> Submit</button>
            </div>
        </div>
                    
        <div id = "confirmationWindow">
            <span onclick="document.getElementById('confirmationWindow').style.display = 'none' ;"> X </span>
            <h2>Confirm Message</h2>
            <p id = "confirmMassage"></p>

            <button id = "profileInfobttn" form = "profileForm" formaction="../editProfile" > Submit </button>
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