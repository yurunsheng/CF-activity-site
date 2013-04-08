package cloudfoundry.activity.repository;

import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;
import cloudfoundry.activity.domain.User;

@Repository("ur")
public interface UserRepository extends MongoRepository<User, String>{
	User findOne(String id);
	User findByEmail(String email);
	User findByName(String name);
	User findByEmailAndPassword(String email, String password);
}
