package com.goodee.finals.attend;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/attend/**")
public class AttendController {

	@Autowired
	private AttendService attendService;
	
	@GetMapping("in")
	public String attendIn(AttendDTO attendDTO, Model model) {
		
		AttendDTO result = attendService.attendIn(attendDTO);
		
		if (result != null) {
			model.addAttribute("attendDTO", result);
			System.out.println(result);
			return "index";
		} else {
			return null;
		}
		
	}
	
	@GetMapping("out")
	public void attendOut() {
//		attendService.attendOut();
		System.out.println("퇴근함");
	}
	
}
