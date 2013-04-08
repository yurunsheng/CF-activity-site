/**
 * 
 */
package cloudfoundry.activity.domain;

import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

@Document(collection="users")
public class User {

	public final static int LEVEL_DEFAULT = 1; // default level
	public final static int LEVEL_ADMIN = 0; // administrator

	@Id
	private String id;

	private String email;

	private String name;

	private String password;

	private int level;

	public User() {

	}

	// name is by default the same as email
	public User(String email) {
		this.email = email;
		name = email;
		level = LEVEL_DEFAULT;
	}

	public User(String email, String name, String pswd, int level) {
		this.email = email;
		this.name = name;
		this.password = pswd;
		this.level = level;
	}

	/*
	 * Don't set id manually
	 * 
	 * public void setId(int id){ this.id = id; }
	 */
	
	public String getId() {
		return id;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public String getEmail() {
		return email;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getName() {
		return name;
	}

	public void setPassword(String pswd) {
		password = pswd;
	}

	public String getPassword() {
		return password;
	}

	public void setLevel(int level) {
		this.level = level;
	}

	public int getLevel() {
		return level;
	}

	public String toString() {
		return "User{id=" + id + ",email=" + email + ",name=" + name
				+ ",password=" + password + ",level=" + level + "}";
	}
}
