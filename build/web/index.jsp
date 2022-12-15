<%
    if (session.getAttribute("G-userId") == null || session.getAttribute("G-userId").equals("")){
    }else{
        if(session.getAttribute("G-userType").toString() == "stud"){
            response.sendRedirect("./jsp-pages/StudentHomePage.jsp");
        }else{
            response.sendRedirect("./jsp-pages/TeacherHomePage.jsp");
        }
    }
%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <title>Egy-Edu | Login</title>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link href="css-pages//outer-home-page-design.css" rel="stylesheet" type="text/css"/>
        
        <script>
            function showHidePassword(){
              var passTextFeild = document.getElementById("pass-field");
              if(passTextFeild.type === "password"){
                passTextFeild.type = "text";
                document.getElementById("change-image").innerHTML = '<img src = "./images/opened eye.png">';
              }else{
                passTextFeild.type = "password";
                document.getElementById("change-image").innerHTML = '<img src = "./images/closed eye.png">';
              }            
            }
            ////////////////////////////////////////////////////////////////////////////////////////////////////////////
            function checkuserlogin(){
                var elm = document.getElementById("usernotexist");
                var usrnm = document.getElementById("lgn-username");
                var xmlhttp = new XMLHttpRequest();
                
                xmlhttp.open("GET", "ajax_username?usernm=" + usrnm.value, true);
                xmlhttp.send();
                
                xmlhttp.onreadystatechange = function() {
                  if (this.readyState === 4 && this.status === 200) {
                      if(xmlhttp.responseText === "True" ){
                        elm.style.display = 'block';
                        elm.style.color = "rgb(3, 169, 244)";
                        elm.innerHTML = "User Exists!!";
                        document.getElementById("invalidLogin").style.opacity = "0";
                        
                      }else{
                          elm.style.display = 'block';
                          elm.style.color = "rgb(234, 182, 27)";
                          elm.innerHTML = "User doesn't Exist!!";
                          document.getElementById("invalidLogin").style.opacity = "0";
                      }
                  }
                };
            }
            ////////////////////////////////////////////////////////////////////////////////////////////////////////////
            function checkuserinfo(){
                <%    
                    if(session.getAttribute("invalidLogin") == "True"){
                    
                %>
                    document.getElementById("invalidLogin").style.opacity = "1";
                <%
                    }
                %>
            }
        </script>
    </head>
    <body onload="checkuserinfo()">
        <div class = "container">
            <img class = "home-page-background" src = "./images/ohpbackground.jpg">
           
            <p class = "brief">"Life is the most difficult exam. Many people fail because they try to copy others, not realizing that everyone has a different question paper."</p>
            
            <a class = "join-us-link" href = "./jsp-pages/Signup.jsp">
              <div class = "join-us-button"> Join Us </div>
            </a>
            
            <div class = "login-form">
              <form action = "login_check"  method = "POST">
                <label class = "login-header">Login</label><br><br><br><br><br>
                
                <label class = "user-name-label">User Name </label><br>
                <input id = "lgn-username" class  = "user-name-field" name = "user-name-login"type = "text" required="" oninput="checkuserlogin()">
                
                <label class = "password-label">Password </label><br>
                <input class  = "password-field" id = "pass-field" name = "password-login" type = "password" required>
                
                <div class = "show-password-button" id = "change-image" onclick = "showHidePassword()">
                  <img src = "./images/closed eye.png">
                </div>
                
                <label class = "user-type-label">User Type </label><br>
                
                <select id = "login-user-type" name="user-type">
                    <option value="1" selected="">Student</option>
                    <option value="2">Teacher</option>
                </select>
                
                <input class  = "login-button" type = "submit" value = "Login">
                <p id = "usernotexist"></p>
              </form>
            </div> 
            <p id = "invalidLogin">Sorry, Wrong Username or Password!!</p>
        </div>
        
                
    </body>
</html>