package com.goodee.finals.lost;

import java.io.IOException;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import com.goodee.finals.common.attachment.AttachmentDTO;
import com.goodee.finals.common.attachment.AttachmentRepository;
import com.goodee.finals.common.attachment.LostAttachmentDTO;
import com.goodee.finals.common.file.FileService;
import com.goodee.finals.staff.StaffDTO;

import jakarta.transaction.Transactional;
import lombok.extern.slf4j.Slf4j;

@Service
@Transactional
@Slf4j
public class LostService {

	@Autowired
	private FileService fileService;
	@Autowired
	private AttachmentRepository attachmentRepository;
	@Autowired
	private LostRepository lostRepository;
	
	public Page<LostDTO> getLostSearchList(String search, Pageable pageable) {
		return lostRepository.findAllBySearch(search, pageable);
	}
	
	public long getTotalLost() {
	    return lostRepository.countByLostDeleteFalse();
	}
	
	public LostDTO getLost(Long lostNum) {
		return lostRepository.findById(lostNum).orElseThrow();
	}
	
	public LostDTO write(LostDTO lostDTO, MultipartFile attach) {
		StaffDTO staffDTO = new StaffDTO();
		Integer staffCode = Integer.parseInt(SecurityContextHolder.getContext().getAuthentication().getName());
		staffDTO.setStaffCode(staffCode);
		
		lostDTO.setStaffDTO(staffDTO);
		
		String fileName = null;
		AttachmentDTO attachmentDTO = new AttachmentDTO();
		
		if (attach != null && attach.getSize() > 0) {
			try {
				fileName = fileService.saveFile(FileService.LOST, attach);
				
				attachmentDTO.setAttachSize(attach.getSize());
				attachmentDTO.setOriginName(attach.getOriginalFilename());
				attachmentDTO.setSavedName(fileName);
				
				attachmentRepository.save(attachmentDTO);
			} catch (IOException e) {
				e.printStackTrace();
			}
		} else {
			attachmentDTO.setAttachSize(0L);
			attachmentDTO.setOriginName("default.png");
			attachmentDTO.setSavedName("default.png");
			
			attachmentRepository.save(attachmentDTO);
		}
		
		LostAttachmentDTO lostAttachmentDTO = new LostAttachmentDTO();
		lostAttachmentDTO.setLostDTO(lostDTO);
		lostAttachmentDTO.setAttachmentDTO(attachmentDTO);
		
		lostDTO.setLostAttachmentDTO(lostAttachmentDTO);
		LostDTO result = lostRepository.save(lostDTO);
		
		if (result != null) return lostDTO;
		else return null;
	}
	
	public boolean updateLost(LostDTO lostDTO, MultipartFile attach) {
		setLostUpdate(lostDTO);
		
		if(attach != null && attach.getSize() > 0) {
			LostDTO before = lostRepository.findById(lostDTO.getLostNum()).orElseThrow();
			AttachmentDTO beforeAttach = before.getLostAttachmentDTO().getAttachmentDTO();
			
			String savedName = attachmentRepository.findById(beforeAttach.getAttachNum()).get().getSavedName();
			boolean deleteResult = fileService.fileDelete(FileService.LOST, savedName);
			
			if(deleteResult) {
				attachmentRepository.deleteById(beforeAttach.getAttachNum());
			}
			
			AttachmentDTO attachmentDTO = new AttachmentDTO();
			
			try {
				String fileName = fileService.saveFile(FileService.LOST, attach);
				
				attachmentDTO.setAttachSize(attach.getSize());
				attachmentDTO.setOriginName(attach.getOriginalFilename());
				attachmentDTO.setSavedName(fileName);
				
				attachmentRepository.save(attachmentDTO);
				
				LostAttachmentDTO lostAttachmentDTO = new LostAttachmentDTO();
				lostAttachmentDTO.setLostDTO(lostDTO);
				lostAttachmentDTO.setAttachmentDTO(attachmentDTO);
				
				lostDTO.setLostAttachmentDTO(lostAttachmentDTO);
			} catch (Exception e) {
				e.printStackTrace();
			}
		}

		LostDTO result = lostRepository.saveAndFlush(lostDTO);
		
		if (result != null) return true;
		else return false;
	}
	
	private void setLostUpdate(LostDTO after) {
		
		log.info("{}", after.getLostNum());
		log.info("{}", after.getLostFinder());
		log.info("{}", after.getLostFinderPhone());
		log.info("{}", after.getLostName());
		log.info("{}", after.getLostDate());
		
		LostDTO before = lostRepository.findById(after.getLostNum()).orElseThrow();
		
		after.setStaffDTO(before.getStaffDTO());
		
		log.info("{}", before.getLostNum());
		log.info("{}", before.getLostFinder());
		log.info("{}", before.getLostFinderPhone());
		log.info("{}", before.getLostName());
		log.info("{}", before.getLostDate());
		log.info("{}", before.getStaffDTO().getInputDeptCode());
		log.info("{}", before.getStaffDTO().getInputJobCode());
		log.info("{}", before.getStaffDTO().getPassword());
		log.info("{}", before.getStaffDTO().getStaffAddress());
		log.info("{}", before.getStaffDTO().getStaffAddressDetail());
		log.info("{}", before.getStaffDTO().getStaffCode());
		log.info("{}", before.getStaffDTO().getStaffEmail());
		log.info("{}", before.getStaffDTO().getStaffEnabled());
		log.info("{}", before.getStaffDTO().getStaffGender());
		log.info("{}", before.getStaffDTO().getStaffLocked());
		log.info("{}", before.getStaffDTO().getStaffName());
		log.info("{}", before.getStaffDTO().getStaffPhone());
		log.info("{}", before.getStaffDTO().getStaffPostcode());
		log.info("{}", before.getStaffDTO().getStaffPw());
		log.info("{}", before.getStaffDTO().getUsername());
	}
	
	public LostDTO delete(LostDTO lostDTO) {
		lostDTO.setLostDelete(true);
		LostDTO result = lostRepository.save(lostDTO);
		return result;
	}
	
}
