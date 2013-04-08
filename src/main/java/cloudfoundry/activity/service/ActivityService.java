package cloudfoundry.activity.service;

import java.io.IOException;
import java.util.Date;
import java.util.List;

import cloudfoundry.activity.domain.Activity;
import cloudfoundry.activity.domain.User;
import cloudfoundry.activity.repository.ActivityRepository;
import cloudfoundry.activity.repository.UserRepository;

import org.apache.commons.io.IOUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Sort;
import org.springframework.data.mongodb.core.MongoTemplate;
import org.springframework.data.mongodb.core.query.Criteria;
import org.springframework.data.mongodb.core.query.Query;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

@Service("as")
public class ActivityService {

	@Autowired
	private ActivityRepository ar;

	@Autowired
	private UserRepository ur;
	
	@Autowired
	private MongoTemplate mongoTemplate;

	/**
	 * No User transaction involved.<br>
	 * Return null if act already has id, which means act is not a new Activity
	 * object
	 * 
	 * @param act
	 * @return
	 */
	public Activity create(Activity act) {
		// TODO Auto-generated method stub
		if (act.getId() == null) {
			return ar.save(act);
		} else
			return null;
	}

	/**
	 * 
	 * @param newAct
	 *            contains new changes
	 * @return the newly updated activity, null in case of failure
	 */
	public Activity update(String id, Activity newAct) {
		// TODO Auto-generated method stub
		Activity existingAct = ar.findOne(id);
		if (existingAct == null)
			return null;
		
		existingAct.setTitle(newAct.getTitle());
		existingAct.setContent(newAct.getContent());
		existingAct.setLocation(newAct.getLocation());
		existingAct.setCapacity(newAct.getCapacity());
		existingAct.setStartTime(newAct.getStartTime());
		existingAct.setEndTime(newAct.getEndTime());
		if (newAct.getFile() != null) {
			System.out.println("setting banner");
			MultipartFile bannerFile = newAct.getFile();
			if (bannerFile != null
					&& !bannerFile.getOriginalFilename().isEmpty()) {
				try {
					byte[] b = IOUtils.toByteArray(bannerFile.getInputStream());
					existingAct.setBanner(b);
				} catch (IOException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			}
			
		}

		return ar.save(existingAct);
	}

	public Activity remove(String id) {
		// TODO Auto-generated method stub
		Activity existingAct = ar.findOne(id);
		if (existingAct != null)
			ar.delete(id);
		// existingAct.setSponsor(null);//spring-data-mongo has no cascading feature???
		return existingAct;
	}

	public Activity findOne(String id) {
		return ar.findOne(id);
	}

	public List<Activity> findAll() {
		// TODO Auto-generated method stub
		return ar.findAll();
	}

	/**
	 * @param count
	 * @return The newest {count} activities, ordered by start time <b>desc</b>
	 */
	public List<Activity> findLatest(int count) {
		// TODO Auto-generated method stub
		// count = Math.min(count, (int)ar.count());//This line is in no need,PageRequest will automatically fit the page size
		//return findPage(1, count).getContent();
		Date now = new Date();
		return mongoTemplate.find(new Query(Criteria.where("startTime").lte(now).and("endTime").gte(now)), Activity.class, "activities");
	}

	/**
	 * @param keyword fuzzy matching
	 * @param pageNum must be a positive integer
	 * @param pageSize
	 * @return
	 */
	public Page<Activity> findPage(String keyword, int pageNum, int pageSize) {
		if (pageNum < 1)
			return null;
		PageRequest pgr = new PageRequest(pageNum - 1, pageSize,
				Sort.Direction.DESC, "startTime");
		Page<Activity> page;
		if(keyword.isEmpty()||keyword==null)
			page = ar.findAll(pgr);
		else
			page = ar.findByTitleLike(keyword, pgr);
		return page;
	}

	/**
	 * Find activities sponsored by the specific sponsor
	 * 
	 * @param sponsor
	 * @return
	 */
	public List<Activity> findBySponsor(User sponsor) {
		return ar.findBySponsor(sponsor);
	}

	public Activity findByTitle(String title) {
		return ar.findByTitle(title);
	}

}
