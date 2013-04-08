package cloudfoundry.activity.domain;

import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.index.Indexed;
import org.springframework.data.mongodb.core.mapping.DBRef;
import org.springframework.data.mongodb.core.mapping.Document;

@Document(collection="participants")
public class Participant {
	
	@Id
    private String id;
	
	private String email;
	
	private String url;
	
	@DBRef
	@Indexed
	private Activity activity;
	
	public Participant(){
		
	}
	public Participant(String email, String url){
		this.email = email;
		this.url = url;
	}
	
	public String getId(){
		return id;
	}
	
	public void setEmail(String email){
		this.email = email;
	}
	public String getEmail(){
		return email;
	}
	
	public void setUrl(String url){
		this.url = url;
	}
	public String getUrl(){
		return url;
	}
	
	public void setActivity(Activity act){
		activity = act;
	}
	public Activity getActivity(){
		return activity;
	}
}
