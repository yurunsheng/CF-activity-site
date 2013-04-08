package cloudfoundry.activity.repository;

import java.util.List;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;
import cloudfoundry.activity.domain.Activity;
import cloudfoundry.activity.domain.User;

@Repository("ar")
public interface ActivityRepository extends MongoRepository<Activity, String> {
	Activity findByTitle(String title);
	List<Activity> findBySponsor(User sponsor);
	Page<Activity> findByTitleLike(String title, Pageable page);
}
