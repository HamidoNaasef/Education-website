<%@page import="java.util.concurrent.TimeUnit"%>
<%@page import="java.util.ArrayList"%>
<%@page import="Edu_Website.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%
    if (session.getAttribute("G-userId") == null || session.getAttribute("G-userId").equals("")){
        response.sendRedirect("../index.jsp");
    }else{
        if(session.getAttribute("G-userType").toString() == "teach"){
            response.sendRedirect("../jsp-pages/TeacherHomePage.jsp");
        }
        Exam exam = new Exam();
        Subject subject = new Subject();
        
        if(!exam.is_exam_exist(request.getParameter("examId") )){
            response.sendRedirect("../index.jsp");
        }else {
            String examIDD = request.getParameter("examId");
            if( (!exam.is_examed(examIDD, session.getAttribute("G-userId").toString())) && (exam.can_exam(examIDD)) &&
                    (subject.is_student_enrolled(session.getAttribute("G-userId").toString(), exam.get_related_subject_id(examIDD))) ){
                
                ArrayList<Question> loadedquestions= new ArrayList<>();
                ArrayList<RandomQuestion> randomedQuestions = new ArrayList<>();
                RandomQuestion rq = new RandomQuestion();
                Question q = new Question();
                int randVaue = 0;

                exam.get_exam_info(examIDD);
                loadedquestions = q.getExamQuestions(examIDD);
                

                while(loadedquestions.size() != 0){
                    randVaue = (int) Math.floor(Math.random()*(loadedquestions.size()));
                    randomedQuestions.add(rq.setRQuestion(loadedquestions.get(randVaue)));
                    loadedquestions.remove(randVaue);
                }
            
%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link href="..//css-pages//inner-pages.css" rel="stylesheet" type="text/css"/>
        <title>Egy-Edu | <%=exam.get_name() %></title>
        <script>
            var min = 0;
            var sec = 0;
            <%
                if(exam.is_exam_page_reloaded(examIDD, session.getAttribute("G-userId").toString())){
            %>
                min = <%=exam.get_remaining_time(examIDD, session.getAttribute("G-userId").toString())%>;
            <%
                }else{
                    exam.set_first_view(examIDD, session.getAttribute("G-userId").toString());
            %>
                min = <%=exam.get_duration()%>;
            <%
                }
            %>
            
            
        </script>
            
    </head>
    <body>
        <div id = "exam_container">
            <h1><%=exam.get_name() %> </h1>
            <form id = "exam_form" name = "examForm" action="../markExam">
                <input type="hidden" name = "numofquestions" value = "<%=randomedQuestions.size()%>">
                <input type="hidden" name = "examId" value = "<%=examIDD%>">
                <%
                    for(int i = 0; i < randomedQuestions.size(); i++){
                        
                        
                %>
                    <div id = "question">
                        <h3 class = "question-head"><%=(i)+1%>- <%=randomedQuestions.get(i).get_head_of_question() %> </h3>
                        <input type="hidden" name="question<%=i%>" value="<%=randomedQuestions.get(i).get_id_of_question() %>">
                        
                        <%
                            for(int x = 0; x < 4; x++){
                        %>

                            <input class = "radio" type = "radio" value = "<%=randomedQuestions.get(i).get_ans_of_index(x) %>" id = "question<%=i%>-option<%=x%>" name = "<%=randomedQuestions.get(i).get_id_of_question() %>">
                            <label  class = "label" for = "question<%=i%>-option<%=x%>"> <%=randomedQuestions.get(i).get_ans_of_index(x) %> </label><br>



                        <%
                            }
                        %>
                            
                    </div>
                <%
                    }
                %>
                <div id="subnitexa" onclick = "document.getElementById('confirm_submitting_exam').style.display = 'block'"> Submit Exam</div>
                
            </form>
        </div>
                
            <div id = "timerContent" >
                <h5> Exam Timer </h5>:
                <div id = "timer"> </div>
            </div>
                
        <div id = "confirm_submitting_exam">
            <span onclick="document.getElementById('confirm_submitting_exam').style.display = 'none'">X</span>
            <h2> Are you sure you want to submit exam?</h2>
            <button formmethod="post" id = "submitAnswer" form = "exam_form" formaction="../markExam?numofquestions=<%=randomedQuestions.size()%>&examId=<%=examIDD%>"> Submit Exam</button>
        </div>
    <%
            }else{
                response.sendRedirect("../index.jsp");
            }
        }
    }
    %>
    <script>
        // Update the count down every 1 second
            var timerView = document.getElementById("timer");
            
        var x = setInterval(function() {
            var timerValue = "";
            //timer countdown
            if(min > 0){
                if(sec === 0){
                    min--;
                    sec = 59;
                }else if(sec > 0){
                    sec--;
                }
            }else{
                timerView.style.color = "rgb(165, 42, 42)";
                if(sec === 0){
                    document.getElementById("exam_form").submit();
                }else{
                    sec--;
                }
            }
            
            if(min < 10){
                timerValue += "0" + min;
            }else{
                timerValue += min;
            }
            timerValue += " : ";

            if(sec < 10){
                timerValue += "0" + sec;
            }else{
                timerValue += sec;
            }
            
          // Output the result in the element 
          timerView.innerHTML = timerValue;

          // If the count down is over, write some text 
          if (min === 0 && sec === 0) {
            clearInterval(x);
            timerView.innerHTML = "Over!!";
            document.getElementById("exam_form").submit();
            //submit form here!!
          }
        }, 1000);
    </script>
    
    </body>
</html>
