<%
    if (session.getAttribute("G-userId") == null || session.getAttribute("G-userId").equals("")){
    }else{
        if(session.getAttribute("G-userType") == "stud"){
            response.sendRedirect("../jsp-pages/StudentHomePage.jsp");
        }else{
            response.sendRedirect("../jsp-pages/TeacherHomePage.jsp");
        }
    }
%>
<!DOCTYPE html>
<html>
    <head>
        <title>Egy-Edu | Sign up</title>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link href="..//css-pages//outer-home-page-design.css" rel="stylesheet" type="text/css"/>
        
        <link href="../css-pages/inner-pages.css" rel="stylesheet" type="text/css"/>
        <script type="text/javascript">
            var gmailc = false;
            var passwordconfc = false;
            var phonec = false;
            var usrnmcheckc = false;
            //////////////////////////////////////////////////////////////////////////////////
            function showHidePassword(){
              var passTextFeild  = document.getElementById("pass-field");
              var signupShowPass = document.getElementById("change-image");

              if(passTextFeild.type === "password"){
                passTextFeild.type = "text";
                document.getElementById("conf-pass-field").type = "text";
                signupShowPass.innerHTML = '<img src = "../images/opened eye.png">';
              }else{

                document.getElementById("conf-pass-field").type = "password";
                passTextFeild.type = "password";
                signupShowPass.innerHTML = '<img src = "../images/closed eye.png">';
              }
            }
            //////////////////////////////////////////////////////////////////////////////////
            function checkUserSignup(){
                var elm = document.getElementById("usrnmSignuperr");
                var usrnm = document.getElementById("usernmsignup");
                var xmlhttp = new XMLHttpRequest();
                
                xmlhttp.open("GET", "../ajax_username_signup?usernm=" + usrnm.value, true);
                xmlhttp.send();
                
                xmlhttp.onreadystatechange = function() {
                    if (this.readyState === 4 && this.status === 200) {
                        if(xmlhttp.responseText === "False" ){
                            elm.style.color = "rgb(234, 182, 27)";
                            elm.innerHTML = "User already exists!!";                 
                            usrnmcheckc = false;
                        }else{
                            elm.style.color = "rgb(3, 169, 244)";
                            elm.innerHTML = "User Available!!";
                            usrnmcheckc = true;
                        }
                    } 
                };
            }
            //////////////////////////////////////////////////////////////////////////////////
            function validateGmail(){
                var emailAdress = document.getElementById("gmail-field").value;
            
                var x = document.getElementById("gmailCheck");
                let regexEmail = /^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/;
                if (emailAdress.match(regexEmail)) {
                    x.style.color = "rgb(3, 169, 244)";
                    x.innerHTML ="Valid Gmail!!";
                    gmailc = true;
                } else {
                    x.style.color = "rgb(234, 182, 27)";
                    x.innerHTML ="Invalid Gmail!!";
                    gmailc = false;
                }
            }
            //////////////////////////////////////////////////////////////////////////////////
            function passwordConfigCheck(){
                var p  = document.getElementById("pass-field").value;
                var pc = document.getElementById("conf-pass-field").value;
                var x  = document.getElementById("passconferr");
                if(p === pc){
                    x.style.color = "rgb(3, 169, 244)";
                    x.innerHTML ="Matched password!!";
                    passwordconfc = true;
                } else {
                    x.style.color = "rgb(234, 182, 27)";
                    x.innerHTML ="Not matched password!!";
                    passwordconfc = false;
                }
            }
            /////////////////////////////////////////////////////////////////////////////////
            function phoneNumCheck(){
                var phonenum  = document.getElementById("phone-number-field").value;
                let ch = phonenum.charAt(0) + phonenum.charAt(1);
                var x  = document.getElementById("phoneerr");
                if((ch === "01") && phonenum.length === 11){
                    x.style.color = "rgb(3, 169, 244)";
                    x.innerHTML ="Valid Phone Number!!";
                    phonec = true;
                } else {
                    x.style.color = "rgb(234, 182, 27)";
                    x.innerHTML ="Invalid Phone Number!!";
                    phonec = false;
                }
            }
            /////////////////////////////////////////////////////////////////////////////////
            function formCheck(){
                var bttn = document.getElementById("signupbttn");
                if((gmailc === false) || (passwordconfc === false) || (phonec === false) || (usrnmcheckc === false)){
                    bttn.disabled = true;
                    bttn.style.opacity = "0.5";
                    document.getElementById("confirmMassage").innerHTML = "Hint: Some entered data is invalid or wrong!!";
                }else{
                    bttn.disabled = false;
                    bttn.style.opacity = "1";
                    document.getElementById("confirmMassage").innerHTML = "Are you sure you want to submit?";
                }
            }
            /////////////////////////////////////////////////////////////////////////////////
            
        </script>
    </head>
    <body>
        
        <div class = "container">
          <img class = "home-page-background" src = "../images/ohpbackground.jpg">
          <div class = "signup-form">
              <form method="POST" >
                <label id = "signup-header">Sign up</label><br><br><br><br><br>
                <label id = "label-of-fields">First Name</label>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                <label id = "label-of-fields">Last Name</label><br>
                
                <input id = "personal-name-field" name = "first-name-signup" type = "text" minlength="3" maxlength="15" required="">
                <input id = "personal-name-field" name = "last-name-signup" type = "text" minlength="3" maxlength="15" required=""><br>
                
                <label id = "label-of-fields">User Name </label><br>
                <input id = "usernmsignup" class  = "user-name-field" name = "user-name-signup" type = "text" maxlength="25" minlength="6" required = "" oninput="checkUserSignup();this.value = this.value.replace(/[^\u0000-\u007F ]+/, '');this.value = this.value.replace(/\s/g, '');"><br>
                
                <label id = "label-of-fields">Password </label><br>
                <input id = "pass-field" class  = "user-name-field" name = "pasword-signup" type = "password" maxlength="25" minlength="6" required="" oninput = "passwordConfigCheck()"><br>
                
                <label id = "label-of-fields">Confirm Password </label><br>
                <input id = "conf-pass-field" class  = "user-name-field" name = "cnofirm-password-signup" type = "password" required="" oninput = "passwordConfigCheck()"><br>
                
                <p id = "passconferr"></p>
                
                <select id = "login-user-type" name="user-type">
                  <option value="1" selected="">Student</option>
                  <option value="2">Teacher</option>
                </select>

                <div class = "signup-show-password-button" id = "change-image" onclick = "showHidePassword()">
                  <img src = "../images/closed eye.png">
                </div>
                <a href = "../index.jsp">
                  <div class = "back-to-login-arrow" onclick = "redirctToLoginPage()">
                    <img src = "../images/arrow.png">
                  </div>  
                </a>

                <label class = "gmail-label" id = "label-of-fields">G-mail </label><br><p id = "gmailCheck"></p>
                <input class  = "user-name-field" id = "gmail-field" name = "user-gmail" placeholder = "example@gmail.com" type = "text" maxlength="50" required="" oninput="validateGmail()"><br>

                <label class = "phone-number-label" id = "label-of-fields">Phone Number </label><br>
                <input class  = "user-name-field" id = "phone-number-field" name = "phone-number-signup" type = "number" required="" oninput="phoneNumCheck();this.value = this.value.replace(/[^0-9.]/g, '').replace(/(\..*)\./g, '$1');"><br>

                <div id = "signup-recapcha"></div>
                <p id = "phoneerr"></p>
                <p id = "usrnmSignuperr"></p>
             </form>
              
              <input type = "submit" value = "Register" onclick = "document.getElementById('confirmationWindow').style.display = 'block';formCheck();">
            
          </div>
            
            <div id = "confirmationWindow">
                <span onclick="document.getElementById('confirmationWindow').style.display = 'none' ;"> X </span>
                <h2>Confirm Message</h2>
                <p id = "confirmMassage"></p>

                <button id = "signupbttn" form = "profileForm" formaction="../firstRegesterServlet" > Submit </button>
            </div>
        </div>
        
        
        
    </body>
</html>