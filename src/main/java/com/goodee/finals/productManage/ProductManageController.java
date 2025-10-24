package com.goodee.finals.productManage;

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

import com.goodee.finals.product.ProductDTO;
import com.goodee.finals.product.ProductService;
import com.goodee.finals.product.ProductTypeDTO;
import com.goodee.finals.staff.StaffDTO;

import jakarta.servlet.http.HttpServletResponse;
import jakarta.validation.Valid;
import lombok.extern.slf4j.Slf4j;

@Controller
@RequestMapping("/productManage/**")
@Slf4j
public class ProductManageController {

	@Autowired
	private ProductService pService;
	
	@Autowired
	private ProductManageService pmService;
	
	@GetMapping("")
	public String getProductManageList(@PageableDefault(size = 10, sort = "pm_num", direction = Direction.DESC) Pageable pageable, 
										@RequestParam(required = false) String pmType,
										@RequestParam(value="startDate", required = false) String startDateStr,
								        @RequestParam(value="endDate", required = false) String endDateStr,
								        @RequestParam(required = false) String search, 
										Model model) {
		Integer pmTypeInt = null;
		if (pmType != null && !pmType.trim().isEmpty()) {
		    pmTypeInt = Integer.parseInt(pmType);
		}
		if (search == null) search = "";
		LocalDate startDate = (startDateStr == null) ? null : LocalDate.parse(startDateStr);
		LocalDate endDate = (endDateStr == null) ? null : LocalDate.parse(endDateStr);
		
		Page<ProductManageDTO> productManageList = pmService.getProductManageSearchList(startDate, endDate, pmTypeInt, search, pageable);
		
		model.addAttribute("productManageList", productManageList);
		model.addAttribute("search", search);
		model.addAttribute("pmType", pmType);
		model.addAttribute("startDate", startDateStr);
		model.addAttribute("endDate", endDateStr);
		
		StaffDTO staffDTO = (StaffDTO) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
		model.addAttribute("staffDTO", staffDTO);
		
		long totalProductManage = pmService.getTotalProduct();
		model.addAttribute("totalProductManage", totalProductManage);
		
		return "productManage/manageList";
	}
	
	@GetMapping("/excel")
	public void downloadExcel(@RequestParam(required = false) String search, 
								@RequestParam(required = false) String pmType,
								@RequestParam(value="startDate", required = false) String startDateStr,
						        @RequestParam(value="endDate", required = false) String endDateStr,
								HttpServletResponse response) throws IOException {
		Integer pmTypeInt = null;
		if (pmType != null && !pmType.trim().isEmpty()) {
		    pmTypeInt = Integer.parseInt(pmType);
		}
	    if (search == null) search = "";
	    LocalDate startDate = (startDateStr == null) ? null : LocalDate.parse(startDateStr);
		LocalDate endDate = (endDateStr == null) ? null : LocalDate.parse(endDateStr);

	    // 전체 데이터 조회
	    List<ProductManageDTO> list = pmService.getProductManageSearchListForExcel(startDate, endDate, pmTypeInt, search);

	    // 파일명 지정
	    String fileName = URLEncoder.encode("물품관리대장.xlsx", StandardCharsets.UTF_8);

	    response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
	    response.setHeader("Content-Disposition", "attachment; filename=" + fileName);

	    // 서비스에서 엑셀 파일 생성
	    pmService.writeProductManageExcel(list, response.getOutputStream());
	}
	
	@GetMapping("{pmNum}")
	@ResponseBody
	public ProductManageDTO getProductManageDetail(@PathVariable Long pmNum, Model model) {
		ProductManageDTO productManageDTO = pmService.getProductManage(pmNum);
		model.addAttribute("productManageDTO", productManageDTO);
		
		return productManageDTO;
	}
	
	@GetMapping("write")
	public String write(@ModelAttribute ProductManageDTO productManageDTO, @PageableDefault(size = 10, sort = "product_code", direction = Direction.ASC) Pageable pageable, String search, Model model) {
		return "productManage/manageWrite";
	}
	
	
	@GetMapping("loadProducts")
	@ResponseBody
	public List<ProductDTO> loadloadProducts() {
		List<ProductDTO> productList =  pmService.list();
		
		return productList;
	}
	
	@PostMapping("write")
	public String Write(@Valid ProductManageDTO pmDTO, BindingResult bindingResult, ProductDTO pDTO, Model model) {
		List<Integer> checkList = new ArrayList<>();
		long pAmount = 0L;
		
		// 입출고대상 선택 안 했을 때
		if(pDTO == null || pDTO.getProductCode() == null) {
			checkList.add(2);
			
		}else {
			
			ProductDTO productCheck = pService.getProduct(pDTO.getProductCode());
			pAmount = productCheck.getProductAmount();
			
			if(pmDTO != null && pmDTO.getPmAmount() != null) {
				if(pmDTO.getPmType() == 80 && pmDTO.getPmAmount() < 0 && -(pmDTO.getPmAmount()) > pAmount) {
					checkList.add(3);
				}
				if(pmDTO.getPmType() == 90 && pmDTO.getPmAmount() > 0 && pmDTO.getPmAmount() > pAmount) {
					checkList.add(3);
				}
			}
		}
		
		if (!checkList.isEmpty()) {
			for (int check : checkList) {
				if(check == 2) {
					model.addAttribute("pmAmount", pmDTO.getPmAmount());
					model.addAttribute("productCodeMsg", "입출고 대상을 지정해주세요. (우측상단 물품검색)");
				}
				if (check == 3) {
					model.addAttribute("pmAmountMsg", "현재 재고 수량을 확인해주세요. (재고수량: " + pAmount + ")");
				}
			}
			return "productManage/manageWrite";
		}
		
		if(bindingResult.hasErrors()) return "productManage/manageWrite";
		
		ProductManageDTO result = pmService.write(pDTO, pmDTO);
		
		String resultMsg = "입출고 등록 중 오류가 발생했습니다.";
		String resultIcon = "warning";
		
		if (result != null) {
			resultMsg = "입출고를 성공적으로 등록했습니다.";
			resultIcon = "success";
			String resultUrl = "/productManage";
			model.addAttribute("resultUrl", resultUrl);
		}
		
		model.addAttribute("resultMsg", resultMsg);
		model.addAttribute("resultIcon", resultIcon);
		
		return "common/result";
	}
	
//	@PostMapping("{pmNum}/delete")
//	public String delete(ProductDTO pDTO, ProductManageDTO pmDTO, Model model) {
//		ProductManageDTO result = pmService.delete(pDTO, pmDTO);
//		
//		String resultMsg = "입출고내역 삭제 중 오류가 발생했습니다.";
//		String resultIcon = "warning";
//		
//		if (result != null) {
//			resultMsg = "입출고내역을 삭제했습니다.";
//			resultIcon = "success";
//			String resultUrl = "/productManage";
//			model.addAttribute("resultUrl", resultUrl);
//		}
//		
//		model.addAttribute("resultMsg", resultMsg);
//		model.addAttribute("resultIcon", resultIcon);
//		
//		return "common/result";
//	}
	
	@GetMapping("stockReport")
	public String getStockReport(Model model) {
		List<ProductTypeDTO> productTypeList = pService.getProductTypeList();
		model.addAttribute("productTypeList", productTypeList);
		
		return "productManage/stockReport";
	}
	
}
