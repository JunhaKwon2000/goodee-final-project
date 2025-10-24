package com.goodee.finals.lost;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

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
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.goodee.finals.productManage.ProductManageDTO;
import com.goodee.finals.staff.StaffDTO;

import jakarta.servlet.http.HttpServletResponse;
import jakarta.validation.Valid;
import lombok.extern.slf4j.Slf4j;

@Controller
@RequestMapping("/lost/**")
@Slf4j
public class LostController {

	@Autowired
	private LostService lostService;
	
	@GetMapping("")
	public String getLostList(@PageableDefault(size = 10, sort = "lost_num", direction = Direction.DESC) Pageable pageable, 
								@RequestParam(value="startDate", required = false) String startDateStr,
						        @RequestParam(value="endDate", required = false) String endDateStr,
						        String search,
								Model model) {
		if (search == null) search = "";
		LocalDate startDate = (startDateStr == null) ? null : LocalDate.parse(startDateStr);
		LocalDate endDate = (endDateStr == null) ? null : LocalDate.parse(endDateStr);
				
		Page<LostDTO> lostList = lostService.getLostSearchList(startDate, endDate, search, pageable);
		
		model.addAttribute("lostList", lostList);
		model.addAttribute("search", search);
		model.addAttribute("startDate", startDate);
		model.addAttribute("endDate", endDate);
		
		StaffDTO staffDTO = (StaffDTO) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
		model.addAttribute("staffDTO", staffDTO);
		
		long totalLost = lostService.getTotalLost();
		model.addAttribute("totalLost", totalLost);
		
		return "lost/list";
	}
	
	@GetMapping("/excel")
	public void downloadExcel(@RequestParam(required = false) String search, 
								@RequestParam(value="startDate", required = false) String startDateStr,
						        @RequestParam(value="endDate", required = false) String endDateStr,
								HttpServletResponse response) throws IOException {
	    if (search == null) search = "";
	    LocalDate startDate = (startDateStr == null) ? null : LocalDate.parse(startDateStr);
		LocalDate endDate = (endDateStr == null) ? null : LocalDate.parse(endDateStr);

	    // 전체 데이터 조회
	    List<LostDTO> list = lostService.getLostSearchListForExcel(startDate, endDate, search);

	    // 파일명 지정
	    String fileName = URLEncoder.encode("분실물.xlsx", StandardCharsets.UTF_8);

	    response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
	    response.setHeader("Content-Disposition", "attachment; filename=" + fileName);

	    // 서비스에서 엑셀 파일 생성
	    lostService.writeLostExcel(list, response.getOutputStream());
	}
	
	@GetMapping("{lostNum}")
	@ResponseBody
	public LostDTO getLostDetail(@PathVariable Long lostNum, Model model) {
		LostDTO lostDTO = lostService.getLost(lostNum);
		model.addAttribute("lostDTO", lostDTO);
		
		return lostDTO;
	}
	
	@GetMapping("write")
	public String write(@ModelAttribute LostDTO lostDTO, Model model) {
		return "lost/write";
	}
	
	@PostMapping("write")
	public String write(@Valid LostDTO lostDTO, BindingResult bindingResult, MultipartFile attach, Model model) throws Exception {
		List<Integer> checkList = new ArrayList<>();
		
		if (bindingResult.hasErrors()) checkList.add(1);
		if (attach == null || attach.getSize() <= 0) checkList.add(2);
		
		if (!checkList.isEmpty()) {
			for (int check : checkList) {
				if(check == 2) {
					model.addAttribute("fileErrorMsg", "파일을 첨부해주세요.");
				}
			}
			return "lost/write";
			
		} else {
				
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
