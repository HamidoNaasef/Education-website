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

@WebServlet(name = "accept_refeuse_enrollment", urlPatterns = {"/accept_refeuse_enrollment"})
public class accept_refeuse_enrollment extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, Exception {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            try{
                Notification noti = new Notification();
                Subject subject = new Subject();
                String studId = request.getParameter("studId");
                String subId = request.getParameter("subId");

                if(" Accept".equals(request.getParameter("statue"))){
                    subject.acceptEnrolment(studId, subId);
                    noti.insert_notification(subject.get_subjectName(subId) + ": Your Enrollment has been accepted!!", studId);
                } else {
                    noti.insert_notification(subject.get_subjectName(subId) + ": Your Enrollment has been refused!!", studId);
                }

                subject.refuseEnrolment(studId, subId);
                response.sendRedirect("index.jsp");
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
            Logger.getLogger(accept_refeuse_enrollment.class.getName()).log(Level.SEVERE, null, ex);
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
            Logger.getLogger(accept_refeuse_enrollment.class.getName()).log(Level.SEVERE, null, ex);
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
