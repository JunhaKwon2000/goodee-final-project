package com.goodee.finals.lost;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort.Direction;
import org.springframework.data.web.PageableDefault;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.goodee.finals.staff.StaffDTO;

import jakarta.validation.Valid;
import lombok.extern.slf4j.Slf4j;

@Controller
@RequestMapping("/lost/**")
@Slf4j
public class LostController {

	@Autowired
	private LostService lostService;
	
	@GetMapping("")
	public String getLostList(@PageableDefault(size = 10, sort = "lost_num", direction = Direction.DESC) Pageable pageable, String search, Model model) {
		if (search == null) search = "";
		
		Page<LostDTO> lostList = lostService.getLostSearchList(search, pageable);
		
		model.addAttribute("lostList", lostList);
		model.addAttribute("search", search);
		
		StaffDTO staffDTO = (StaffDTO) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
		model.addAttribute("staffDTO", staffDTO);
		
		long totalLost = lostService.getTotalLost();
		model.addAttribute("totalLost", totalLost);
		
		return "lost/list";
	}
	
	@GetMapping("{lostNum}")
	@ResponseBody
	public LostDTO getLostDetail(@PathVariable Long lostNum, Model model) {
		LostDTO lostDTO = lostService.getLost(lostNum);
		model.addAttribute("lostDTO", lostDTO);
		
		return lostDTO;
	}
	
	@GetMapping("write")
	public String write(@ModelAttribute("lostDTO") LostDTO lostDTO, Model model) {
		return "lost/write";
	}
	
	@PostMapping("write")
	public String write(@Valid LostDTO lostDTO, BindingResult bindingResult, MultipartFile attach, Model model) throws Exception {
		if(bindingResult.hasErrors()) {
			return "lost/write";
		}
		
		LostDTO result = lostService.write(lostDTO, attach);
		
		String resultMsg = "분실물 등록 중 오류가 발생했습니다.";
		String resultIcon = "warning";
		
		if (result != null) {
			resultMsg = "분실물을 성공적으로 등록했습니다.";
			resultIcon = "success";
			String resultUrl = "/lost";
			model.addAttribute("resultUrl", resultUrl);
		}
		
		model.addAttribute("resultMsg", resultMsg);
		model.addAttribute("resultIcon", resultIcon);
		
		return "common/result";
	}
	
	@GetMapping("{lostNum}/update")
	public String getLostUpdate(@PathVariable Long lostNum, Model model) {
		LostDTO lostDTO = lostService.getLost(lostNum);
		model.addAttribute("lostDTO", lostDTO);
		
		return "lost/write";
	}
	
	@PostMapping("{lostNum}/update")
	public String postLostUpdate(@Valid LostDTO lostDTO, BindingResult bindingResult, MultipartFile attach, Model model) {
		if(bindingResult.hasErrors()) {
			return "lost/write";
		}
		
		boolean result = lostService.updateLost(lostDTO, attach);
		
		String resultMsg = "분실물 수정 중 오류가 발생했습니다.";
		String resultIcon = "warning";
		
		if (result) {
			resultMsg = "분실물 정보를 수정했습니다.";
			resultIcon = "success";
			String resultUrl = "/lost";
			model.addAttribute("resultUrl", resultUrl);
		}
			
		model.addAttribute("resultMsg", resultMsg);
		model.addAttribute("resultIcon", resultIcon);
		
		return "common/result";
	}
	
	@PostMapping("{lostNum}/delete")
	public String delete(LostDTO lostDTO, Model model) {
		LostDTO result = lostService.delete(lostDTO);
		
		String resultMsg = "분실물 삭제 중 오류가 발생했습니다.";
		String resultIcon = "warning";
		
		if (result != null) {
			resultMsg = "분실물 정보를 삭제했습니다.";
			resultIcon = "success";
			String resultUrl = "/lost";
			model.addAttribute("resultUrl", resultUrl);
		}
		
		model.addAttribute("resultMsg", resultMsg);
		model.addAttribute("resultIcon", resultIcon);
		
		return "common/result";
	}
	
}
