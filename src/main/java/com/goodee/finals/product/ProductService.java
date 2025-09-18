package com.goodee.finals.product;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;
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
	
	public Page<ProductDTO> getProductSearchList(String search, Pageable pageable) {
		return productRepository.findAllBySearch(search, pageable);
	}
	
	public long getTotalProduct() {
		return productRepository.count();
	}
	
	public ProductDTO getProduct(Integer productCode) {
		return productRepository.findById(productCode).orElseThrow();
	}
	
	public ProductDTO write(ProductDTO productDTO, MultipartFile attach) {
		StaffDTO staffDTO = new StaffDTO();
		Integer staffCode = Integer.parseInt(SecurityContextHolder.getContext().getAuthentication().getName());
		staffDTO.setStaffCode(staffCode);
		
		productDTO.setStaffDTO(staffDTO);
		
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
	
}
