/**
 * 
 */
package cloudfoundry.activity.domain;

import java.util.Date;
import org.springframework.data.annotation.Id;
import org.springframework.data.annotation.Transient;
import org.springframework.data.mongodb.core.mapping.DBRef;
import org.springframework.data.mongodb.core.mapping.Document;
import org.springframework.web.multipart.MultipartFile;

@Document(collection="activities")
public class Activity {

    @Id
    private String id;
    
    private String title;

    private String content;

    private Date startTime;

    private Date endTime;
    
    private String location;
    
    private byte[] banner;//in binary format
    
    private int capacity;
    
    @DBRef
    private User sponsor;
    
    @Transient
    private MultipartFile file;
    @Transient
    private long total;
    @Transient
    private String s_time;
    @Transient
    private String e_time;
    @Transient
	private String imgSrc;
    
    public Activity(){
    	
    }
    
    public Activity(String title,String content,String location){
    	this.title = title;
    	this.content = content;
    	this.location = location;
    }
    
/*  Don't set id manually
 *   
  	public void setId(int id){
    	this.id = id;
    }*/
    
    public String getId(){
    	return id;
    }
    
    public void setSponsor(User user){
    	sponsor = user;
    }
    public User getSponsor(){
    	return sponsor;
    }

    public void setTitle(String title){
    	this.title=title;
    }
    public String getTitle(){
    	return title;
    }
    
    public void setContent(String c){
    	this.content=c;
    }
    public String getContent(){
    	return content;
    }
    
    public void setLocation(String l){
    	location = l;
    }
    public String getLocation(){
    	return location;
    }
    
    public void setStartTime(Date t){
    	this.startTime = t;
    }
    public Date getStartTime(){
    	return startTime;
    }
    
    public void setEndTime(Date t){
    	this.endTime = t;
    }
    public Date getEndTime(){
    	return endTime;
    }

    public void setCapacity(int c){
    	this.capacity = c;
    }
    public int getCapacity(){
    	return capacity;
    }
    
    public void setBanner(byte[] banner){
    	this.banner = banner;
    }
    public byte[] getBanner(){
    	return banner;
    }
    
    public void setFile(MultipartFile file){
    	this.file = file;
    }
    public MultipartFile getFile(){
    	return file;
    }
    
    public void setS_time(String st){
    	s_time = st;
    }
    public String getS_time(){
    	return s_time;
    }
    
    public void setE_time(String et){
    	e_time = et;
    }
    public String getE_time(){
    	return e_time;
    }
    
    public String toString(){
    	return "Activity{" +
    			"id=" + id +
    			",title=" + title +
    			",content=" + content +
    			",location=" + location +
    			",start_time=" + startTime +
    			",end_time=" + endTime +
    			",capacity=" + capacity +
    			",banner=" + banner;
    }

	public void setImgSrc(String imgPath) {
		// TODO Auto-generated method stub
		this.imgSrc = imgPath;
	}
	public String getImgSrc(){
		return imgSrc;
	}
	
	public void setTotal(long t){
		total=t;
	}
	public long getTotal(){
		return total;
	}
}
