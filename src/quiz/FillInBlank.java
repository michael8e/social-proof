package quiz;

import java.util.ArrayList;

public class FillInBlank extends Question{
	public FillInBlank(String question, ArrayList<String> answers) {
		super(question, answers);
	}
	
	@Override
	public int getType() {
		return 1;
	}
	
}