package com.goodee.finals.product;

import lombok.extern.slf4j.Slf4j;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.time.LocalDate;
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

import com.goodee.finals.lost.LostDTO;
import com.goodee.finals.staff.StaffDTO;

import jakarta.servlet.http.HttpServletResponse;
import jakarta.validation.Valid;

@Controller
@RequestMapping("/product/**")
@Slf4j
public class ProductController {
			
	@Autowired
	private ProductService productService;
	
	@GetMapping("")
	public String getProductList(@PageableDefault(size = 10, sort = "product_code", direction = Direction.ASC) Pageable pageable, String search, Model model) {
		if (search == null) search = "";
		
		Page<ProductDTO> productList = productService.getProductSearchList(search,pageable);
		
		model.addAttribute("productList", productList);
		model.addAttribute("search", search);
		
		long totalProduct = productService.getTotalProduct();
		model.addAttribute("totalProduct", totalProduct);
		
		StaffDTO staffDTO = (StaffDTO) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
		model.addAttribute("staffDTO", staffDTO);
		
		return "product/list";
	}
	
	@GetMapping("/excel")
	public void downloadExcel(@RequestParam(required = false) String search, 
								HttpServletResponse response) throws IOException {
	    if (search == null) search = "";

	    // 전체 데이터 조회
	    List<ProductDTO> list = productService.getProductSearchListForExcel(search);

	    // 파일명 지정
	    String fileName = URLEncoder.encode("물품리스트.xlsx", StandardCharsets.UTF_8);

	    response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
	    response.setHeader("Content-Disposition", "attachment; filename=" + fileName);

	    // 서비스에서 엑셀 파일 생성
	    productService.writeProductExcel(list, response.getOutputStream());
	}
	
	@GetMapping("{productCode}")
	@ResponseBody
	public ProductDTO getProductDetail(@PathVariable Integer productCode, Model model) {
		ProductDTO productDTO = productService.getProduct(productCode);
		model.addAttribute("productDTO", productDTO);
		
		return productDTO;
	}
	
	@GetMapping("write")
	public String getWrite(@ModelAttribute ProductDTO productDTO, Model model) {
		// 품목타입리스트 가져오기
		List<ProductTypeDTO> productTypeList = productService.getProductTypeList();
		ProductTypeDTO addSelect = new ProductTypeDTO();
		addSelect.setProductTypeCode(0);
		addSelect.setProductTypeName("--선택--");
		
		productTypeList.addFirst(addSelect);
		model.addAttribute("productTypeList", productTypeList);
		
		return "product/write";
	}
	
	@PostMapping("write")
	public String postWrite(@Valid ProductDTO productDTO, BindingResult bindingResult, MultipartFile attach, Model model) throws Exception {
		List<Integer> checkList = productService.hasOtherErrors(productDTO, bindingResult, attach);
		
		if (!checkList.isEmpty()) {
			List<ProductTypeDTO> productTypeList = productService.getProductTypeList();
			ProductTypeDTO addSelect = new ProductTypeDTO();
			addSelect.setProductTypeCode(0);
			addSelect.setProductTypeName("--선택--");
			productTypeList.addFirst(addSelect);
			model.addAttribute("productTypeList", productTypeList);
			
			for (int check : checkList) {
				if(check == 2) model.addAttribute("productTypeErrorMsg", "물품 타입은 필수입니다.");
				if(check == 3) model.addAttribute("fileErrorMsg", "파일을 첨부해주세요.");
			}
			return "product/write";
				
		} else {
		
		ProductDTO result = productService.write(productDTO, attach);
		
		String resultMsg = "물품 등록 중 오류가 발생했습니다.";
		String resultIcon = "warning";
		
		if (result != null) {
			resultMsg = "물품을 성공적으로 등록했습니다.";
			resultIcon = "success";
			String resultUrl = "/product";
			model.addAttribute("resultUrl", resultUrl);
		}
		
		model.addAttribute("resultMsg", resultMsg);
		model.addAttribute("resultIcon", resultIcon);
		
		return "common/result";
		}
	}
	
	@GetMapping("{productCode}/update")
	public String getProductUpdate(@PathVariable Integer productCode, Model model) {
		ProductDTO productDTO = productService.getProduct(productCode);
		
		model.addAttribute("productDTO", productDTO);
		// 품목타입리스트 가져오기
		List<ProductTypeDTO> productTypeList = productService.getProductTypeList();
		model.addAttribute("productTypeList", productTypeList);
		
		return "product/write";
	}
	
	@PostMapping("{productCode}/update")
	public String postProductUpdate(@Valid ProductDTO productDTO, BindingResult bindingResult, MultipartFile attach, Model model) throws Exception {
		if(bindingResult.hasErrors()) {
			// 품목타입리스트 가져오기
			List<ProductTypeDTO> productTypeList = productService.getProductTypeList();
			model.addAttribute("productTypeList", productTypeList);
			
			return "product/write";
		}
		
		boolean result = productService.updateProduct(productDTO, attach);
		
		String resultMsg = "물품 수정 중 오류가 발생했습니다.";
		String resultIcon = "warning";
		
		if (result) {
			resultMsg = "물품 정보를 수정했습니다.";
			resultIcon = "success";
			String resultUrl = "/product";
			model.addAttribute("resultUrl", resultUrl);
		}
		
		model.addAttribute("resultMsg", resultMsg);
		model.addAttribute("resultIcon", resultIcon);
		
		return "common/result";
	}
	
	@PostMapping("{productCode}/delete")
	public String delete(ProductDTO productDTO, Model model) {
		ProductDTO result = productService.delete(productDTO);
		
		String resultMsg = "물품 삭제 중 오류가 발생했습니다.";
		String resultIcon = "warning";
		
		if (result != null) {
			resultMsg = "물품 정보를 삭제했습니다.";
			resultIcon = "success";
			String resultUrl = "/product";
			model.addAttribute("resultUrl", resultUrl);
		}
		
		model.addAttribute("resultMsg", resultMsg);
		model.addAttribute("resultIcon", resultIcon);
		
		return "common/result";
	}
	
	
	
	
}
