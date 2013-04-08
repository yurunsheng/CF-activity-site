package cloudfoundry.activity.controller;

import java.io.File;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.ResourceBundle;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.io.FileUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.*;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import cloudfoundry.activity.domain.Activity;
import cloudfoundry.activity.domain.User;
import cloudfoundry.activity.service.ActivityService;
import cloudfoundry.activity.service.ParticipantService;
import cloudfoundry.activity.service.UserService;
import cloudfoundry.activity.util.HTML2Text;

@Controller
public class HomeController {
	
	@Autowired
	UserService us;
	@Autowired
	ActivityService as;
	@Autowired
	ParticipantService ps;
	
	@RequestMapping(value="/", method=RequestMethod.GET)
	public String home(Model model, HttpServletRequest request) throws IOException{
		List<Activity> acts = as.findLatest(Integer.parseInt(ResourceBundle.getBundle("config").getString("MAX_COUNT_ON_HOMEPAGE")));
		String rootPath = request.getSession().getServletContext().getRealPath("/");//get the web-root path(ie,webapp folder)
		String imgBase = rootPath+"resources/img/";
		File imgCache;
		for(Activity act : acts){
			act.setTotal(ps.findTotalOf(act));
			act.setContent(HTML2Text.transform(act.getContent()));
			act.setImgSrc(imgBase + act.getId());
			imgCache = new File(act.getImgSrc());
			if (!imgCache.exists())
				try {
					if (act.getBanner() == null)
						FileUtils.copyFile(new File(imgBase + "noImg.gif"),imgCache);
					else
						FileUtils.writeByteArrayToFile(imgCache, act.getBanner());
				} catch (IOException e) {
					e.printStackTrace();
				}
		}
		model.addAttribute("homeActs", acts);
		return "home";
	}
	
	@RequestMapping(value="/login",method=RequestMethod.GET)
	public String getLoginPage(){
		return "user/login";
	}
	
	@RequestMapping(value="/login",method=RequestMethod.POST)
	public @ResponseBody Map<String,String> login(@RequestParam String email,@RequestParam String pswd,HttpServletRequest request){
		System.out.println(email+" "+pswd);
		Map<String,String> response = new HashMap<String, String>();
		User user = us.isValid(email, pswd);
		if(user!=null){
			response.put("result", "success");
			request.getSession().setAttribute("user", user);
		}else
			response.put("result", "fail");
		return response;
	}
	
	@RequestMapping(value="/logout")
	public String logout(@RequestParam String user, HttpServletRequest request){
		request.getSession().removeAttribute("user");
		System.out.println(user+" has signed out.");
		return "redirect:/";
	}
}
