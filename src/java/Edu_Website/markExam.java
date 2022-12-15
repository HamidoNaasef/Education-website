package Edu_Website;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "markExam", urlPatterns = {"/markExam"})
public class markExam extends HttpServlet {

    
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException, Exception {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            
            try{
                HttpSession session = request.getSession(true);
                ArrayList<HPair> student_ans = new ArrayList<>();
                Exam exam = new Exam();
                int grade = 0;
                String exam_id = request.getParameter("examId");
                String student_id = session.getAttribute("G-userId").toString() ;
                
//                System.err.println(exam_id);
//                System.err.println(request.getParameter("numofquestions"));
                
                //collect answers from form
                for(int i = 0; i < Integer.parseInt(request.getParameter("numofquestions")); i++){
                    student_ans.add(new HPair(request.getParameter("question"+i), request.getParameter(request.getParameter("question"+i)) ) );
                }

                for(int i = 0; i < student_ans.size(); i++){
                    if(exam.is_correct(student_ans.get(i).getID(), student_ans.get(i).getDataA()) ){
                        grade++;
                    }
                    exam.store_answers_to_files(exam_id, student_id, student_ans.get(i).getID(), student_ans.get(i).getDataA());
                }
                exam.store_grade_to_db(exam_id, student_id, grade);

                
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
            Logger.getLogger(markExam.class.getName()).log(Level.SEVERE, null, ex);
        } catch (Exception ex) {
            Logger.getLogger(markExam.class.getName()).log(Level.SEVERE, null, ex);
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
            Logger.getLogger(markExam.class.getName()).log(Level.SEVERE, null, ex);
        } catch (Exception ex) {
            Logger.getLogger(markExam.class.getName()).log(Level.SEVERE, null, ex);
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
