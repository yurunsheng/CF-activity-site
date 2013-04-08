package cloudfoundry.activity.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.mongodb.core.MongoTemplate;
import org.springframework.data.mongodb.core.query.Criteria;
import org.springframework.data.mongodb.core.query.Query;
import org.springframework.stereotype.Service;

import cloudfoundry.activity.domain.Activity;
import cloudfoundry.activity.domain.Participant;
import cloudfoundry.activity.repository.ActivityRepository;
import cloudfoundry.activity.repository.ParticipantRepository;

@Service("ps")
public class ParticipantService {

	@Autowired
	private ActivityRepository ar;
	
	@Autowired
	private ParticipantRepository pr;
	
	@Autowired
	private MongoTemplate mongoTemplate;
	
	/**
	 * The <b>create</b> method will first check whether the (email, url) pair in <b>@param p</b> has participated the same activity. If so, null is returned.
	 * @param p
	 * @return
	 */
	public Participant create(Participant p){
		if(pr.findByEmailAndUrlAndActivity(p.getEmail(), p.getUrl(), p.getActivity())==null)
			return pr.save(p);
		else return null;
	}

	/**
	 * Find those who participate the specific activity
	 * @param act
	 * @return
	 */
	public List<Participant> findByActivity(Activity act){
		return pr.findByActivity(act);
	}
	
	/**
	 * 
	 * @param act
	 * @return total number of participants correlated with the specific activity
	 */
	public long findTotalOf(Activity act){
		return mongoTemplate.count(new Query(Criteria.where("activity").is(act)), Participant.class);
	}
	
	/**
	 * remove all participants related to the specific activity
	 */
	public int removeByActivity(String actId){
		Query q = new Query(Criteria.where("activity").is(ar.findOne(actId)));
		int n = mongoTemplate.find(q, Participant.class).size();
		mongoTemplate.remove(q, "participants");
		return n;
	}
}
