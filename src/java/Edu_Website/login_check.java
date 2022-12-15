package Edu_Website;

/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

import java.io.IOException;
import java.io.PrintWriter;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 *
 * @author Nasef
 */
@WebServlet(urlPatterns = {"/login_check"})
public class login_check extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, Exception {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            try{    
                String user = request.getParameter("user-name-login").replace(((char) 39), ' ');
                String pass = request.getParameter("password-login").replace(((char) 39), ' ');
                HttpSession session = request.getSession(true);

                if (session.getAttribute("G-userId") == null || session.getAttribute("G-userId").equals("")){
                }else{
                    if(session.getAttribute("G-userId") == "stud"){
                        response.sendRedirect("jsp-pages/StudentHomePage.jsp");
                    }else{
                        response.sendRedirect("jsp-pages/TeacherHomePage.jsp");
                    }
                }
                if(Integer.parseInt(request.getParameter("user-type")) ==  1){
                    User student = new Student();
                    if(student.isUserExist(user, pass)){
                        session.setAttribute("G-userId", student.get_user_id(user));
                        session.setAttribute("G-userType", "stud");
                        response.sendRedirect("jsp-pages/StudentHomePage.jsp");
                    }else{
                        response.sendRedirect("index.jsp");
                        session.setAttribute("invalidLogin", "True");
                    }

                }else if(Integer.parseInt(request.getParameter("user-type")) ==  2){
                    User teacher = new Teacher();
                    if(teacher.isUserExist(user, pass)){
                        session.setAttribute("G-userId", teacher.get_user_id(user));
                        session.setAttribute("G-userType", "teach");
                        response.sendRedirect("jsp-pages/TeacherHomePage.jsp");
                    }else{
                        response.sendRedirect("index.jsp");
                        session.setAttribute("invalidLogin", "True");
                    }
                }            
            
            }catch(Exception exer){
                response.sendRedirect("./jsp-pages/404Page.jsp");
            }
        }
    }

    
    
    
    
    
    
    
    
    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
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
            Logger.getLogger(login_check.class.getName()).log(Level.SEVERE, null, ex);
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
