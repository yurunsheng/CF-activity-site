package cloudfoundry.activity.repository;

import java.util.List;

import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;

import cloudfoundry.activity.domain.Activity;
import cloudfoundry.activity.domain.Participant;

@Repository("pr")
public interface ParticipantRepository extends MongoRepository<Participant, String> {
	List<Participant> findByActivity(Activity act);
	Participant findByEmailAndUrlAndActivity(String email, String url,Activity act);
}
