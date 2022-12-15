
package Edu_Website;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(name = "addExam", urlPatterns = {"/addExam"})
public class addExam extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, Exception {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            try{
                Notification noti = new Notification();
                Subject subject = new Subject();
                Exam exam = new Exam();
                Question ques = new Question();
                String exam_name = request.getParameter("exam-name");
                String sub_id = request.getParameter("subId");
                String start_date = request.getParameter("exam-start-date");
                String end_date = request.getParameter("exam-end-date");
                String end_time = request.getParameter("exam-end-time");
                int duration = Integer.parseInt(request.getParameter("duration"));

                String examid = exam.insert_exam(exam_name, sub_id, start_date, end_date, end_time, duration);
                for(int i = 0; i < Integer.parseInt(request.getParameter("numofq")); i++){
                    ques.insert_exams_questions(examid, new Question(request.getParameter("question-"+i), request.getParameter("q-"+i+"-correct"),
                    request.getParameter("q-"+i+"-A"), request.getParameter("q-"+i+"-B"), request.getParameter("q-"+i+"-C")));
                }
                //write it into notifications list
                noti.insert_notification(subject.get_subjectName(sub_id) + ": New Exam has been Added", sub_id);
                response.sendRedirect("./jsp-pages/teacherSubject.jsp?subjectid=" + sub_id);
            }catch(Exception exer){
                response.sendRedirect("./jsp-pages/404Page.jsp");
            }
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            processRequest(request, response);
        } catch (Exception ex) {
            Logger.getLogger(addExam.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            processRequest(request, response);
        } catch (Exception ex) {
            Logger.getLogger(addExam.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
