package cloudfoundry.activity.util;

import java.util.ResourceBundle;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;

import cloudfoundry.activity.domain.User;
import cloudfoundry.activity.service.UserService;

public class MongoInitializer {
	
	@Autowired
	private UserService us;
	
	private static final Logger logger = LoggerFactory.getLogger(MongoInitializer.class);
	
	public void init(){
		logger.info("Initializing MongoDB...");
		ResourceBundle rb = ResourceBundle.getBundle("config");
		if(us.findByEmail(rb.getString("ROOT_EMAIL"))==null){
			us.create(new User(rb.getString("ROOT_EMAIL"),rb.getString("ROOT_NAME"),rb.getString("ROOT_PASSWORD"),User.LEVEL_ADMIN));
			logger.info("Root user "+rb.getString("ROOT_NAME")+" successfully initialized.");
		}else
			logger.info("Database already exists.");
	}
}
