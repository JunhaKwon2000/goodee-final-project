package com.goodee.finals.lost;

import java.io.IOException;
import java.io.OutputStream;
import java.time.LocalDate;
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
import org.springframework.web.multipart.MultipartFile;

import com.goodee.finals.common.attachment.AttachmentDTO;
import com.goodee.finals.common.attachment.AttachmentRepository;
import com.goodee.finals.common.attachment.LostAttachmentDTO;
import com.goodee.finals.common.file.FileService;
import com.goodee.finals.productManage.ProductManageDTO;
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
	
	public Page<LostDTO> getLostSearchList(LocalDate startDate, LocalDate endDate, String search, Pageable pageable) {
		return lostRepository.findAllBySearch(startDate, endDate, search, pageable);
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
			attachmentRepository.deleteById(beforeAttach.getAttachNum());
			fileService.fileDelete(FileService.LOST, savedName);
			
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
		LostDTO before = lostRepository.findById(after.getLostNum()).orElseThrow();
		
		after.setStaffDTO(before.getStaffDTO());
	}
	
	
	public LostDTO delete(LostDTO lostDTO) {
		lostDTO = lostRepository.findById(lostDTO.getLostNum()).orElseThrow();
		lostDTO.setLostDelete(true);
		LostDTO result = lostRepository.save(lostDTO);
		return result;
	}
	
	// 엑셀용 전체 리스트
    public List<LostDTO> getLostSearchListForExcel(LocalDate startDate, LocalDate endDate, String search) {
        return lostRepository.findBySearchKeyword(startDate, endDate, search);
    }

    // 엑셀 작성
    public void writeLostExcel(List<LostDTO> list, OutputStream os) throws IOException {
        Workbook workbook = new XSSFWorkbook();
        Sheet sheet = workbook.createSheet("분실물");

        // 헤더 작성
        Row header = sheet.createRow(0);
        String[] headers = {"관리번호", "분실물명", "작성자", "연락처", "등록일자"};
        for (int i = 0; i < headers.length; i++) {
            Cell cell = header.createCell(i);
            cell.setCellValue(headers[i]);
        }

        // 데이터 작성
        int rowIdx = 1;
        for (LostDTO lost : list) {
            Row row = sheet.createRow(rowIdx++);
            row.createCell(0).setCellValue(lost.getLostNum());
            row.createCell(1).setCellValue(lost.getLostName());
            row.createCell(2).setCellValue(lost.getStaffDTO().getStaffName());
            row.createCell(3).setCellValue(lost.getStaffDTO().getStaffPhone());
            row.createCell(4).setCellValue(lost.getLostDate());
        }

        // 열 너비 자동 조정
        for (int i = 0; i < headers.length; i++) {
            sheet.autoSizeColumn(i);
        }

        workbook.write(os);
        workbook.close();
    }
}
