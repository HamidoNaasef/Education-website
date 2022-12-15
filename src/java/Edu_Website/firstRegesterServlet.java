package Edu_Website;

import java.io.IOException;
import java.io.PrintWriter;
import static java.lang.System.err;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(urlPatterns = {"/firstRegesterServlet"})
public class firstRegesterServlet extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, Exception {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            try{
                String fname, lname, pass, usrnm, gmail, phone;
                HttpSession session = request.getSession(true);
                Notification noti = new Notification();

                fname = request.getParameter("first-name-signup").replace(((char) 39), ' ');
                lname = request.getParameter("last-name-signup").replace(((char) 39), ' ');
                pass = request.getParameter("pasword-signup").replace(((char) 39), ' ');
                usrnm = request.getParameter("user-name-signup").replace(((char) 39), ' ');
                gmail = request.getParameter("user-gmail").replace(((char) 39), ' ');
                phone = (request.getParameter("phone-number-signup")).replace(((char) 39), ' ');

                if("1".equals(request.getParameter("user-type"))){
                    Student stud = new Student();

                    stud.insert_user(fname, lname, usrnm, pass, gmail, phone);
                    session.setAttribute("G-userId", stud.get_user_id(usrnm));
                    session.setAttribute("G-userType", "stud");
                    
                    noti.insert_notification("Welcome to egy-edu.net", stud.get_user_id(usrnm));
                    response.sendRedirect("./jsp-pages/StudentHomePage.jsp");
                }else{
                    Teacher teacher = new Teacher();

                    teacher.adding_teacher_to_waiting_list(fname, lname, usrnm, pass, gmail, phone);

                    session.setAttribute("G-userType", "wteach");
                    response.sendRedirect("./jsp-pages/waitingTeacher.jsp");


                }
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
            Logger.getLogger(firstRegesterServlet.class.getName()).log(Level.SEVERE, null, ex);
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
            Logger.getLogger(firstRegesterServlet.class.getName()).log(Level.SEVERE, null, ex);
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
