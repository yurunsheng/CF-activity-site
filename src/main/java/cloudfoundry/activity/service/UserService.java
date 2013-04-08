package cloudfoundry.activity.service;

import java.util.List;

import cloudfoundry.activity.domain.User;
import cloudfoundry.activity.repository.UserRepository;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service("us")
public class UserService{
    
	@Autowired
	private UserRepository ur;
	
	public User create(User user) {
		// TODO Auto-generated method stub
		if(user.getId()==null){
			return ur.save(user);
		}
		else return null;
	}

	public User update(User user){
		User existingUser = ur.findOne(user.getId());
		if(existingUser == null)
			return null;
		
		existingUser.setEmail(user.getEmail());
		existingUser.setName(user.getName());
		existingUser.setLevel(user.getLevel());
		existingUser.setPassword(user.getPassword());
		
		return ur.save(existingUser);
	}
	
	public User remove(String id){
		User existingUser = ur.findOne(id);
		if(existingUser != null)
			ur.delete(existingUser);
		return existingUser;
	}
	
	public User findOne(String id){
		return ur.findOne(id);
	}
	
	public List<User> findAll() {
		// TODO Auto-generated method stub
		return ur.findAll();
	}

	/**
	 * Check if the user's passport is valid
	 * @param email
	 * @param pswd
	 * @return
	 */
	public User isValid(String email, String pswd) {
		// TODO Auto-generated method stub
		return ur.findByEmailAndPassword(email, pswd);
	}
	
	public User findByEmail(String email){
		return ur.findByEmail(email);
	}

}

