
package Edu_Website;

import java.util.ArrayList;

public class RandomQuestion {
    String id = "";
    String head = "";
    String[] answers = new String[4];
    
    ///////////////////////////////////////////////////////////////////////////////////
    public String get_head_of_question(){ return this.head; }
    ///////////////////////////////////////////////////////////////////////////////////
    public String get_id_of_question(){ return this.id; }
    ///////////////////////////////////////////////////////////////////////////////////
    public String get_ans_of_index(int india){
        return this.answers[india];
    }
    ///////////////////////////////////////////////////////////////////////////////////
    public RandomQuestion setRQuestion(Question q){
        RandomQuestion rq = new RandomQuestion();
        ArrayList<Integer> ind = new ArrayList<>();
        
        ind.add(0);
        ind.add(1);
        ind.add(2);
        ind.add(3);
        int currentIndia = (int) Math.floor(Math.random()*(ind.size()));        
        rq.id = q.get_qid();
        rq.head = q.q_head;
        
        rq.answers[ind.get(currentIndia)] = q.ans_A;
        ind.remove(currentIndia);
        currentIndia = (int) Math.floor(Math.random()*(ind.size()));
        
        rq.answers[ind.get(currentIndia)] = q.ans_B;
        ind.remove(currentIndia);
        currentIndia = (int) Math.floor(Math.random()*(ind.size()));
        
        rq.answers[ind.get(currentIndia)] = q.ans_C;
        ind.remove(currentIndia);
        currentIndia = (int) Math.floor(Math.random()*(ind.size()));
        
        rq.answers[ind.get(currentIndia)] = q.ans_correct;
        
//        System.err.println(q.get_ans() );
//        System.err.println(q.get_choiceA() );
//        System.err.println(q.get_choiceB() );
//        System.err.println(q.get_choiceC() );
//        
//        System.err.println("new Arrangment: " );
//        
//        System.err.println(rq.answers[0] );
//        System.err.println(rq.answers[1] );
//        System.err.println(rq.answers[2] );
//        System.err.println(rq.answers[3] );
        
        
        return rq;
    }
}
