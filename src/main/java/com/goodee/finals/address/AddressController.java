package com.goodee.finals.address;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort.Direction;
import org.springframework.data.web.PageableDefault;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.goodee.finals.staff.StaffDTO;

@Controller
@RequestMapping("/address/**")
public class AddressController {

	@Autowired
	private AddressService addressService;
	
	// 전체 직원
	@GetMapping("")
	public String list(@PageableDefault(size = 10, sort = "staff_code", direction = Direction.ASC) Pageable pageable, String search, Model model) {
		if (search == null) search = "";
		
		Page<StaffDTO> addressList = addressService.getAddressSearchList(search, pageable);
		
		model.addAttribute("addressList", addressList);
		model.addAttribute("search", search);
		
		long totalAddress = addressService.getTotalAddress();
		model.addAttribute("totalAddress", totalAddress);
		
		return "address/list";
	}
	
//	@GetMapping()
//	public String deptList(@PathVariable(name = "dept_code") @PageableDefault(size = 10, sort = "staff_code", direction = Direction.ASC) Pageable pageable, String search, Model model) {
//		if (search == null) search = "";
//		
//		return "address/list";
//	}
	
}
