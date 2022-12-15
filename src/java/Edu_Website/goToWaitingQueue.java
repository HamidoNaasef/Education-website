package Edu_Website;

import java.io.*;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet(name = "goToWaitingQueue", urlPatterns = {"/goToWaitingQueue"})
public class goToWaitingQueue extends HttpServlet {

    
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException, Exception {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            try{
                HttpSession session = request.getSession(true);
                String stud_id = session.getAttribute("G-userId").toString();
                Subject subject = new Subject();
                Notification noti = new Notification();

                String code = request.getParameter("subject-enroll-code");
                String pass = request.getParameter("subject-password");
                String sub_id = subject.getIdbycodeandpass(code, pass);

                if(subject.is_id_exist(sub_id) && (!subject.is_student_enrolled(stud_id, sub_id))){
                    subject.add_stud_to_waitinglist(stud_id, sub_id);
                }
                noti.insert_notification(subject.get_subjectName(sub_id) + " : now you are in waiting queue waiting teacher to accept your enrollment!", stud_id);
                response.sendRedirect("./jsp-pages/StudentHomePage.jsp");
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
        } catch (SQLException ex) {
            Logger.getLogger(goToWaitingQueue.class.getName()).log(Level.SEVERE, null, ex);
        } catch (Exception ex) {
            Logger.getLogger(goToWaitingQueue.class.getName()).log(Level.SEVERE, null, ex);
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
        } catch (SQLException ex) {
            Logger.getLogger(goToWaitingQueue.class.getName()).log(Level.SEVERE, null, ex);
        } catch (Exception ex) {
            Logger.getLogger(goToWaitingQueue.class.getName()).log(Level.SEVERE, null, ex);
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
