package cloudfoundry.activity.controller;

import java.io.File;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.ResourceBundle;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.io.FileUtils;
import org.apache.commons.io.IOUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import cloudfoundry.activity.domain.Activity;
import cloudfoundry.activity.domain.Participant;
import cloudfoundry.activity.domain.User;
import cloudfoundry.activity.service.ActivityService;
import cloudfoundry.activity.service.ParticipantService;
import cloudfoundry.activity.service.UserService;
import cloudfoundry.activity.util.HTML2Text;
import cloudfoundry.activity.util.URLChecker;

@Controller
@RequestMapping("/act")
public class ActivityController {

	@Autowired
	UserService us;
	@Autowired
	ActivityService as;
	@Autowired
	ParticipantService ps;
	
	private static final Logger logger = LoggerFactory.getLogger(ActivityController.class);
	
	/**
	 * 
	 * @param s_time
	 * @param e_time
	 * @param act
	 * @param model
	 * @param request
	 * @return
	 * @throws ParseException
	 */
	@RequestMapping(value = "/create.do", method = RequestMethod.POST)
	public String createActivity(@RequestParam String s_time,
			@RequestParam String e_time, Activity act, Model model,
			HttpServletRequest request) throws ParseException {

		User user = (User) request.getSession().getAttribute("user");

		MultipartFile bannerFile = act.getFile();
		if (bannerFile != null && !bannerFile.getOriginalFilename().isEmpty()) {
			try {
				byte[] b = IOUtils.toByteArray(bannerFile.getInputStream());
				act.setBanner(b);
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
		act.setSponsor(user);
		act.setStartTime(new SimpleDateFormat(ResourceBundle.getBundle("config").getString("TIME_FORMAT")).parse(s_time));
		act.setEndTime(new SimpleDateFormat(ResourceBundle.getBundle("config").getString("TIME_FORMAT")).parse(e_time));

		Activity saved = as.create(act);
		if (saved != null) {
			logger.info("Activity "+act.getTitle()+" created successfully by user "+user.getName());
			String imgBase = request.getSession().getServletContext()
					.getRealPath("/")
					+ "resources/img/";
			File imgCache = new File(imgBase + saved.getId());
			try {
				if (saved.getBanner() == null)
					FileUtils.copyFile(new File(imgBase + "noImg.gif"),
							imgCache);
				else
					FileUtils.writeByteArrayToFile(imgCache, saved.getBanner());
				System.out.println("Image cache created");
			} catch (IOException e) {
				e.printStackTrace();
			}
			model.addAttribute("pos", "mine");
			model.addAttribute("info", "created");
		} else {
			logger.error("Failed in creating activity "+act.getTitle()+"!");
			model.addAttribute("pos", "create");
			model.addAttribute("info", "fail");
		}
		return "redirect:/user/" + user.getId();
	}

	@RequestMapping(value = "/update.do/{id}")
	public String update(@PathVariable("id") String id, Activity act,
			Model model, HttpServletRequest request) throws ParseException {
		User user = (User) request.getSession().getAttribute("user");
		act.setStartTime(new SimpleDateFormat(ResourceBundle.getBundle("config").getString("TIME_FORMAT")).parse(act.getS_time()));
		act.setEndTime(new SimpleDateFormat(ResourceBundle.getBundle("config").getString("TIME_FORMAT")).parse(act.getE_time()));
		Activity updated = as.update(id, act);
		if (updated != null) {
			logger.info("Activity "+updated.getTitle()+" updated successfully by user "+user.getName());
			String imgBase = request.getSession().getServletContext()
					.getRealPath("/")
					+ "resources/img/";
			File imgCache = new File(imgBase + updated.getId());
			try {
				System.out.println(act.getFile()==null);
				if (act.getFile() != null)
					FileUtils.writeByteArrayToFile(imgCache,updated.getBanner());
				System.out.println("Image cache updated");
			} catch (IOException e) {
				e.printStackTrace();
			}
			model.addAttribute("info", "updated");
		} else {
			logger.error("Failed in updating activity "+act.getTitle()+"!");
			model.addAttribute("info", "fail");
		}
		model.addAttribute("pos", "mine");
		return "redirect:/user/" + user.getId();
	}

	@RequestMapping(value = "/remove.do")
	public String remove(@RequestParam String id, Model model, HttpServletRequest request) {
		int n = ps.removeByActivity(id);// remove its correlated participants
		Activity removed = as.remove(id);// remove the activity
		String imgBase = request.getSession().getServletContext().getRealPath("/") + "resources/img/";
		new File(imgBase + id).delete();// remove its banner file cached in server's file system
		User user = (User) request.getSession().getAttribute("user");
		if(removed==null)
			logger.warn("No activity found to remove.");
		else
			logger.info("Activity " + removed.getTitle() + " & "+n+" participants removed successfully by user "+user.getName());
		model.addAttribute("pos", "mine");
		return "redirect:/user/" + user.getId();
	}

	@RequestMapping(value = "/{id}/participate.do", method = RequestMethod.POST)
	public @ResponseBody Map<String, String> participate(@PathVariable("id") String id,@RequestBody Participant part) {
		System.out.println(id + "," + part.getEmail() + "," + part.getUrl());
		String url = part.getUrl().trim();
		part.setUrl(url.substring(0, url.indexOf(".cloudfoundry.com")+17));
		Map<String, String> map = new HashMap<String, String>();
		if (!URLChecker.isValid(part.getUrl())) {
			map.put("msg", ResourceBundle.getBundle("config").getString("URL_INVALID_ERROR"));
			System.out.println(map.get("msg"));
			return map;
		}
		Activity act = as.findOne(id);
		if (act != null) {
			part.setActivity(act);
			long total = ps.findTotalOf(act);//current total participants before this
			if(total>=act.getCapacity()){
				map.put("total", String.valueOf(total));
				map.put("msg", ResourceBundle.getBundle("config").getString("PARTICIPANT_FULL_ERROR"));
			}else if (ps.create(part) != null) {
				map.put("total", String.valueOf(total+1));
				map.put("msg", ResourceBundle.getBundle("config").getString("PARTICIPANT_OK_INFO"));
			} else {
				map.put("msg", ResourceBundle.getBundle("config").getString("PARTICIPANT_REPEAT_ERROR"));
			}
		}
		System.out.println(map.get("msg"));
		return map;
	}

	@RequestMapping(value = "/report/{id}")
	public String report(@PathVariable("id") String id, Model model) {
		Activity act = as.findOne(id);
		List<Participant> parts = ps.findByActivity(act);
		model.addAttribute("parts", parts);
		return "act/report";
	}

	@RequestMapping(value = "/detail/{id}")
	public String showActivity(@PathVariable("id") String id, Model model,
			HttpServletRequest request) {
		System.out.println("view detail/" + id);
		Activity act = as.findOne(id);
		String imgBase = request.getSession().getServletContext()
				.getRealPath("/")
				+ "resources/img/";
		act.setImgSrc(imgBase + act.getId());
		File imgCache = new File(act.getImgSrc());
		if (!imgCache.exists())
			try {
				if (act.getBanner() == null)
					FileUtils.copyFile(new File(imgBase + "noImg.gif"),
							imgCache);
				else
					FileUtils.writeByteArrayToFile(imgCache, act.getBanner());
			} catch (IOException e) {
				e.printStackTrace();
			}
		act.setTotal(ps.findTotalOf(act));
		model.addAttribute("act", act);
		return "act/detail";
	}

	@RequestMapping(value = "/list/{pageNum}")
	public String listAll(@PathVariable Integer pageNum, Model model, @RequestParam String q,
			HttpServletRequest request) throws UnsupportedEncodingException {
		q=new String(q.getBytes("iso-8859-1"), "UTF-8"); 
		Page<Activity> page = as.findPage(q.trim(), pageNum, Integer.parseInt(ResourceBundle.getBundle("config").getString("LIST_PAGE_SIZE")));
		String imgBase = request.getSession().getServletContext()
				.getRealPath("/")
				+ "resources/img/";
		File imgCache;
		for (Activity act : page.getContent()) {
			act.setImgSrc(imgBase + act.getId());
			act.setContent(HTML2Text.transform(act.getContent()));
			imgCache = new File(act.getImgSrc());
			if (!imgCache.exists())
				try {
					if (act.getBanner() == null)
						FileUtils.copyFile(new File(imgBase + "noImg.gif"),
								imgCache);
					else
						FileUtils.writeByteArrayToFile(imgCache,
								act.getBanner());
				} catch (IOException e) {
					e.printStackTrace();
				}
		}
		model.addAttribute("q", q);
		model.addAttribute("curPage", page);
		return "act/list";
	}

}
