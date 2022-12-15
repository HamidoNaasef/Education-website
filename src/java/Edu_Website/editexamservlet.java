package Edu_Website;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "editexamservlet", urlPatterns = {"/editexamservlet"})
public class editexamservlet extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, Exception {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            try{
                HttpSession session = request.getSession(true);
                session.getAttribute("");
                Notification noti = new Notification();
                Exam exam = new Exam();
                int question_counter = Integer.parseInt(request.getParameter("numOfQ"));

                Question question = new Question();

                exam.update_exams_info( request.getParameter("exam_id") ,request.getParameter("exam-name"),
                            request.getParameter("exam-start-date"), request.getParameter("exam-end-date"), request.getParameter("exam-end-time"),
                            Integer.parseInt(request.getParameter("duration")));

                ArrayList<String> id_stamp = (ArrayList<String>) session.getAttribute("array");


                for(int i = 0; i < question_counter; i++){
                    String loopid = id_stamp.get(i);
                    question.update_exams_questions(loopid, request.getParameter(loopid),
                            request.getParameter(loopid + "-correct"),
                            request.getParameter(loopid + "-A"),
                            request.getParameter(loopid + "-B"),
                            request.getParameter(loopid + "-C"));
                }

                noti.insert_notification(request.getParameter("exam-name") + " exam has been modified!!", exam.get_related_subject_id(request.getParameter("exam_id")) );
                
                response.sendRedirect("./jsp-pages/editExam.jsp");
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
            Logger.getLogger(editexamservlet.class.getName()).log(Level.SEVERE, null, ex);
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
            Logger.getLogger(editexamservlet.class.getName()).log(Level.SEVERE, null, ex);
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
