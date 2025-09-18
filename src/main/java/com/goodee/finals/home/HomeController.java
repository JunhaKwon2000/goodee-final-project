package com.goodee.finals.home;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import com.goodee.finals.attend.AttendDTO;
import com.goodee.finals.attend.AttendService;
import com.goodee.finals.notice.NoticeDTO;
import com.goodee.finals.notice.NoticeService;

import lombok.extern.slf4j.Slf4j;

@Controller
@Slf4j
public class HomeController {

	@Autowired
	private AttendService attendService;
	
	@Autowired
	private NoticeService noticeService;
	
	@GetMapping("/")
	public String getHome(Model model) {
		Authentication auth = SecurityContextHolder.getContext().getAuthentication();

        // 로그인 안 된 경우, 대시보드 접근
        if (auth == null || auth.getName().equals("anonymousUser")) {
            return "redirect:/staff/login";
        }
        
        // 출퇴근 - 오늘날짜
        String todayDate = LocalDate.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd"));
        model.addAttribute("todayDate", todayDate);

        // 출퇴근 - 기록확인 및 출력
		AttendDTO attendDTO = attendService.findAttend();
		model.addAttribute("attendDTO", attendDTO);
		
		// 공지사항 - 목록 5개 출력
		List<NoticeDTO> noticeList = noticeService.getRecentNoticesForDashboard();
		model.addAttribute("noticeList", noticeList);
	    log.info("{}", noticeList.toString());
		
		return "index";
	}
	
}
