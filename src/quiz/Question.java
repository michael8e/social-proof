package quiz;

import java.util.ArrayList;

public class Question {
	String question;
	ArrayList<String> answers;
	
	public Question(String question, ArrayList<String> answers) {
		this.question = question;
		this.answers = answers;
	}
	
	public int getType() {
		return -1;
	}
	
	public String getQuestion() {
		return question;
	}
	
	public ArrayList<String> getAnswers() {
		return answers;
	}
}