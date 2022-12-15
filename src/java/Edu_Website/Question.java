
package Edu_Website;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;

public class Question extends Model{
    String q_id = "";
    String q_head = "";
    String ans_correct = "";
    String ans_A = "";
    String ans_B = "";
    String ans_C = "";
    
    ///////////////////////////////////////////////////////////////////////////////////
    public Question(){}
    ///////////////////////////////////////////////////////////////////////////////////
    public Question(String q_head, String ans_correct, String ans_A, String ans_B, String ans_C){
        this.q_head = q_head;
        this.ans_correct = ans_correct;
        this.ans_A = ans_A;
        this.ans_B = ans_B;
        this.ans_C = ans_C;
        
    }
    ///////////////////////////////////////////////////////////////////////////////////
    public Question(String q_id, String q_head, String ans_correct, String ans_A, String ans_B, String ans_C){
        this.q_id = q_id;
        this.q_head = q_head;
        this.ans_correct = ans_correct;
        this.ans_A = ans_A;
        this.ans_B = ans_B;
        this.ans_C = ans_C;
        
    }
    ///////////////////////////////////////////////////////////////////////////////////
    public String get_qid(){return this.q_id;}
    ///////////////////////////////////////////////////////////////////////////////////
    public String get_qhead(){return this.q_head;}
    ///////////////////////////////////////////////////////////////////////////////////
    public String get_ans(){return this.ans_correct;}
    ///////////////////////////////////////////////////////////////////////////////////
    public String get_choiceA(){return this.ans_A;}
    ///////////////////////////////////////////////////////////////////////////////////
    public String get_choiceB(){return this.ans_B;}
    ///////////////////////////////////////////////////////////////////////////////////
    public String get_choiceC(){return this.ans_C;}
    ///////////////////////////////////////////////////////////////////////////////////
    public void get_question(String q_id) throws Exception{
        try (Connection con = this.connection.connect(); Statement stmt = con.createStatement()) {
            String query = "SELECT * FROM grandmaster.exam_question  "
                    + "where q_id = '" + q_id + "';";
            try (ResultSet res = stmt.executeQuery(query)) {
                res.next();
                
                this.q_head = res.getString("question");
                this.ans_correct = res.getString("answer");
                this.ans_A = res.getString("option_a");
                this.ans_B = res.getString("option_b");
                this.ans_C = res.getString("option_c");
                res.close();
                stmt.close();
                con.close();
            }
        }
    }
    ///////////////////////////////////////////////////////////////////////////////////
    public void insert_exams_questions(String exam_id, Question question) throws Exception{
        String ques_id = "q-" + java.time.LocalDate.now() + "-";
        try (Connection con = this.connection.connect(); Statement stmt = con.createStatement()) {
            String query_1 = "select count(q_id) as numberofquestion FROM exam_question;";
            String insert_question;
            // get the number of question
            try (Statement stmt2 = con.createStatement();ResultSet temp_res = stmt.executeQuery(query_1)) {
              
                temp_res.next();
                int question_counter;
                question_counter = temp_res.getInt("numberofquestion");
                question_counter++;
                ques_id += question_counter;
                
                // inserting question to DB
                insert_question = "insert into exam_question values ('" + ques_id + "', '" + question.q_head + "',"
                        + " '" + question.ans_correct + "', '" + question.ans_A + "', '" + question.ans_B + "',"
                        + " '" + question.ans_C + "', '" + exam_id + "');";
                System.err.println("==> "+ insert_question);
                stmt2.executeUpdate(insert_question);
                
                temp_res.close();
                stmt.close();
                stmt2.close();
                con.close();
            }
        }
    }
    ///////////////////////////////////////////////////////////////////////////////////
    public int count_exam_questions(String exam_id) throws Exception{
        try (Connection con = this.connection.connect(); Statement stmt = con.createStatement()) {
            String query = "select count(q_id) as numberofquestion FROM exam_question where exam_id = '" + exam_id + "';";
            try (ResultSet res = stmt.executeQuery(query)) {
                res.next();
                int count = res.getInt("numberofquestion");
                
                res.close();
                stmt.close();
                con.close();
                return count;
            }
        }
    }
    ///////////////////////////////////////////////////////////////////////////////////
    public ArrayList<Question> getExamQuestions(String examId) throws Exception{
        ArrayList<Question> questions = new ArrayList<>();
        try (Connection con = this.connection.connect(); Statement stmt = con.createStatement()) {
            String query = "select * FROM exam_question where exam_id = '" + examId + "';";
            try (ResultSet res = stmt.executeQuery(query)) {
                
                while(res.next()){
                    questions.add(new Question(res.getString("q_id"), res.getString("question"), res.getString("answer"),
                    res.getString("option_a"), res.getString("option_b"), res.getString("option_c")));
                }
                res.close();
                stmt.close();
                con.close();
            }
        }
        
        return questions;
    }
    ///////////////////////////////////////////////////////////////////////////////////
    public void update_exams_questions(String quesId, String q_head, String ans_correct,
            String ans_A, String ans_B, String ans_C) throws Exception{
        try (Connection con = this.connection.connect(); Statement stmt = con.createStatement()) {
            String update_question = "update exam_question set question = '" + q_head + "',"
                    + "  answer = '" + ans_correct + "', option_a = '" + ans_A + "',"
                    + " option_b = '" + ans_B + "',option_c = '" + ans_C + "'"
                    + " where q_id = '" + quesId + "';";
                
            // update question in DB
            stmt.executeUpdate(update_question);

            stmt.close();
            con.close();
            
        }
    }
    ///////////////////////////////////////////////////////////////////////////////////
    
    ///////////////////////////////////////////////////////////////////////////////////
}
