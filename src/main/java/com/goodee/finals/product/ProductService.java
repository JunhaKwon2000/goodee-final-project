package com.goodee.finals.product;

import java.io.IOException;
import java.io.OutputStream;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;
import org.springframework.validation.BindingResult;
import org.springframework.web.multipart.MultipartFile;

import com.goodee.finals.common.attachment.AttachmentDTO;
import com.goodee.finals.common.attachment.AttachmentRepository;
import com.goodee.finals.common.attachment.ProductAttachmentDTO;
import com.goodee.finals.common.file.FileService;
import com.goodee.finals.staff.StaffDTO;

import jakarta.transaction.Transactional;
import lombok.extern.slf4j.Slf4j;

@Service
@Transactional
@Slf4j
public class ProductService {

	@Autowired
	private FileService fileService;
	@Autowired
	private AttachmentRepository attachmentRepository;
	@Autowired
	private ProductRepository productRepository;
	@Autowired
	private ProductTypeRepository productTypeRepository;
	
	public Page<ProductDTO> getProductSearchList(String search, Pageable pageable) {
		return productRepository.findAllBySearch(search, pageable);
	}
	
	public long getTotalProduct() {
		return productRepository.countByProductDeleteFalse();
	}
	
	public ProductDTO getProduct(Integer productCode) {
		return productRepository.findById(productCode).orElseThrow();
	}
	
	public List<ProductTypeDTO> getProductTypeList() {
		return productTypeRepository.findAll();
	}
	
	public ProductDTO write(ProductDTO productDTO, MultipartFile attach) {
		StaffDTO staffDTO = new StaffDTO();
		Integer staffCode = Integer.parseInt(SecurityContextHolder.getContext().getAuthentication().getName());
		staffDTO.setStaffCode(staffCode);
		
		productDTO.setStaffDTO(staffDTO);
		productDTO = setProductDefault(productDTO);
		
		String fileName = null;
		AttachmentDTO attachmentDTO = new AttachmentDTO();
		
		if (attach != null && attach.getSize() > 0) {
			try {
				fileName = fileService.saveFile(FileService.PRODUCT, attach);
				
				attachmentDTO.setAttachSize(attach.getSize());
				attachmentDTO.setOriginName(attach.getOriginalFilename());
				attachmentDTO.setSavedName(fileName);
				
				attachmentRepository.save(attachmentDTO);
			} catch (Exception e) {
				e.printStackTrace();
			}
		} else {
			attachmentDTO.setAttachSize(0L);
			attachmentDTO.setOriginName("default.png");
			attachmentDTO.setSavedName("default.png");
			
			attachmentRepository.save(attachmentDTO);
			
		}
		
		ProductAttachmentDTO productAttachmentDTO = new ProductAttachmentDTO();
		productAttachmentDTO.setProductDTO(productDTO);
		productAttachmentDTO.setAttachmentDTO(attachmentDTO);
		
		productDTO.setProductAttachmentDTO(productAttachmentDTO);
		ProductDTO result = productRepository.save(productDTO);
		
		if (result != null) return productDTO;
		else return null;
	}
	
	// 검증 메서드
	public List<Integer> hasOtherErrors(ProductDTO productDTO, BindingResult bindingResult, MultipartFile attach) throws Exception {
		
		List<Integer> checkList = new ArrayList<>();
		// check: 1이상  => 검증 실패
		// check: 0 => 검증 통과
		
		// 1. annotation 검증
		if(bindingResult.hasErrors()) { // true => 검증실패
			checkList.add(1);
		}
		
		// 2. 물품타입 선택여부
		if (productDTO.getProductTypeDTO().getProductTypeCode() == 0) {
			checkList.add(2);
		} 
		
		// 3. 파일 첨부여부
		if (attach == null || attach.getSize() <= 0) {
			checkList.add(3);
		}
		return checkList;
	}
	
	private ProductDTO setProductDefault(ProductDTO productDTO) {
		Integer productTypeCode = productDTO.getProductTypeDTO().getProductTypeCode();
		Integer lastProductCode = productRepository.findTopProductCodeByProductType(productTypeCode);
		
		if(lastProductCode == null) {
			productDTO.setProductCode((productTypeCode * 10000) + 1);
		} else {
			productDTO.setProductCode(lastProductCode + 1);
		}
		
		return productDTO;
	}
	
	public boolean updateProduct(ProductDTO productDTO, MultipartFile attach) {
		setProductUpdate(productDTO);
		
		
		if(attach != null && attach.getSize() > 0) {
			ProductDTO before = productRepository.findById(productDTO.getProductCode()).orElseThrow();
			AttachmentDTO beforeAttach = before.getProductAttachmentDTO().getAttachmentDTO();
			
			String savedName = attachmentRepository.findById(beforeAttach.getAttachNum()).get().getSavedName();
			attachmentRepository.deleteById(beforeAttach.getAttachNum());
			fileService.fileDelete(FileService.PRODUCT, savedName);
			
//			productRepository.deleteBeforeAttach(beforeAttach.getAttachNum());
			
			AttachmentDTO attachmentDTO = new AttachmentDTO();
			
			try {
				String fileName = fileService.saveFile(FileService.PRODUCT, attach);
				
				attachmentDTO.setAttachSize(attach.getSize());
				attachmentDTO.setOriginName(attach.getOriginalFilename());
				attachmentDTO.setSavedName(fileName);
				
				attachmentRepository.save(attachmentDTO);
				
				ProductAttachmentDTO productAttachmentDTO = new ProductAttachmentDTO();
				productAttachmentDTO.setProductDTO(productDTO);
				productAttachmentDTO.setAttachmentDTO(attachmentDTO);
				
				productDTO.setProductAttachmentDTO(productAttachmentDTO);
			} catch (Exception e) {
				e.printStackTrace();
			}
			
		}
		
		ProductDTO result = productRepository.saveAndFlush(productDTO);
		
		if (result != null) return true;
		else return false;
	}
	
	private void setProductUpdate(ProductDTO after) {
		ProductDTO before = productRepository.findById(after.getProductCode()).orElseThrow();
		after.setStaffDTO(before.getStaffDTO());
	}
	
	public ProductDTO delete(ProductDTO productDTO) {
		productDTO = productRepository.findById(productDTO.getProductCode()).orElseThrow();
		productDTO.setProductDelete(true);
		ProductDTO result = productRepository.save(productDTO);
		return result;
	}
	
	// 엑셀용 전체 리스트
    public List<ProductDTO> getProductSearchListForExcel(String search) {
        return productRepository.findBySearchKeyword(search);
    }

    // 엑셀 작성
    public void writeProductExcel(List<ProductDTO> list, OutputStream os) throws IOException {
        Workbook workbook = new XSSFWorkbook();
        Sheet sheet = workbook.createSheet("물품리스트");

        // 헤더 작성
        Row header = sheet.createRow(0);
        String[] headers = {"물품번호", "물품타입", "물품명", "규격", "재고수량"};
        for (int i = 0; i < headers.length; i++) {
            Cell cell = header.createCell(i);
            cell.setCellValue(headers[i]);
        }

        // 데이터 작성
        int rowIdx = 1;
        for (ProductDTO p : list) {
            Row row = sheet.createRow(rowIdx++);
            row.createCell(0).setCellValue(p.getProductCode());
            row.createCell(1).setCellValue(p.getProductTypeDTO().getProductTypeName());
            row.createCell(2).setCellValue(p.getProductName());
            row.createCell(3).setCellValue(p.getProductSpec());
            row.createCell(4).setCellValue(p.getProductAmount());
        }

        // 열 너비 자동 조정
        for (int i = 0; i < headers.length; i++) {
            sheet.autoSizeColumn(i);
        }

        workbook.write(os);
        workbook.close();
    }
	
}
