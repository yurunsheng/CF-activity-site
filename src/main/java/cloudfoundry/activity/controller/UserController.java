package cloudfoundry.activity.controller;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.ResponseBody;

import cloudfoundry.activity.domain.Activity;
import cloudfoundry.activity.domain.User;
import cloudfoundry.activity.service.ActivityService;
import cloudfoundry.activity.service.ParticipantService;
import cloudfoundry.activity.service.UserService;

@Controller
@RequestMapping("/user")
public class UserController {

	@Autowired
	private UserService us;
	@Autowired
	private ActivityService as;
	@Autowired
	private ParticipantService ps;
	
	private static final Logger logger = LoggerFactory.getLogger(UserController.class);

	@RequestMapping("/{id}")
	public String profile(@PathVariable("id") String id, @RequestParam String pos, Model model, HttpServletRequest request){
		User user = (User) request.getSession().getAttribute("user");
		if(user == null){
			return "redirect:/";
		}else if(!user.getId().equals(id)){
			return "warning";
		}
		List<Activity> acts = as.findBySponsor(us.findOne(id));
		for(Activity act : acts)
			act.setTotal(ps.findTotalOf(act));
		model.addAttribute("myActs", acts);
		model.addAttribute("pos", pos);
		if(user.getLevel()==User.LEVEL_ADMIN){
			List<User> users = us.findAll();
			for(User u:users)
				if(u.getLevel()==User.LEVEL_ADMIN){
					users.remove(u);
					break;
				}
			model.addAttribute("allUsers", users);
		}
		return "user/profile";
	}
	
	@RequestMapping(value="/update/{id}", method=RequestMethod.POST)
	public @ResponseBody String setting(@PathVariable("id") String id, @RequestParam String u_name, @RequestParam String cnfm_pswd, Model model, HttpServletRequest request){
		User user = (User) request.getSession().getAttribute("user");
		user.setName(u_name);
		if(!cnfm_pswd.isEmpty())
			user.setPassword(cnfm_pswd);
		user = us.update(user);
		model.addAttribute("pos", "profile");
		return "success";
//		return "redirect:/user/"+user.getId();
	}
	
	@RequestMapping(value="/create",method=RequestMethod.POST)
	public @ResponseBody Map<String,String> createUser(@RequestParam String email,@RequestParam String name){
		System.out.println(email+" "+name);
		Map<String,String> response = new HashMap<String, String>();
		User user = us.findByEmail(email);
		if(user==null){
			User u = new User(email,name,"",User.LEVEL_DEFAULT);
			u=us.create(u);
			logger.info("New user created: [email:"+u.getEmail()+",name:"+u.getName()+"]");
			response.put("result", "success");
			response.put("id", u.getId());
		}else{
			logger.warn("Failed in creating new user, email '"+email+"' already used.");
			response.put("result", "repeated");
		}
		return response;
	}
	
	@RequestMapping(value="/delete",method=RequestMethod.POST)
	public @ResponseBody Map<String,String> deleteUser(@RequestParam String id){
		Map<String,String> response = new HashMap<String, String>();
		User removed = us.remove(id);
		if(removed!=null){
			logger.info("User removed successfully: [email:"+removed.getEmail()+",name:"+removed.getName()+"]");
			response.put("result", "success");
		}
		else{
			logger.warn("No user found to remove.");
			response.put("result", "fail");
		}
		return response;
	}
}
