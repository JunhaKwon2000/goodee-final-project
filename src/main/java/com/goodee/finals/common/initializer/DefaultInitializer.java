package com.goodee.finals.common.initializer;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.ApplicationArguments;
import org.springframework.boot.ApplicationRunner;
import org.springframework.context.annotation.Configuration;

import com.goodee.finals.staff.DeptDTO;
import com.goodee.finals.staff.DeptRepository;
import com.goodee.finals.staff.JobDTO;
import com.goodee.finals.staff.JobRepository;
import com.goodee.finals.staff.StaffDTO;
import com.goodee.finals.staff.StaffRepository;
import com.goodee.finals.staff.StaffService;

import jakarta.transaction.Transactional;
import lombok.extern.slf4j.Slf4j;

@Configuration
@Transactional
@Slf4j
public class DefaultInitializer implements ApplicationRunner {
	@Autowired
	private DeptRepository deptRepository;
	@Autowired
	private JobRepository jobRepository;
	@Autowired
	private StaffRepository staffRepository;
	@Autowired
	private StaffService staffService;

	@Override
	public void run(ApplicationArguments args) throws Exception {
		setDeptDefault();
		setJobDefault();
		setAdmin();
	}

	private void setDeptDefault() {
		if (deptRepository.count() == 0) {
			Integer[] deptCodeArr = {1000, 1001, 1002, 1003};
			String[] deptNameArr = {"ROLE_HQ", "ROLE_HR", "ROLE_OP", "ROLE_FA"};
			String[] deptDetailArr = {"임원", "인사", "운영", "시설"};
			
			for (int i = 0; i < deptCodeArr.length; i++) {
				DeptDTO deptDTO = new DeptDTO();
				deptDTO.setDeptCode(deptCodeArr[i]);
				deptDTO.setDeptName(deptNameArr[i]);
				deptDTO.setDeptDetail(deptDetailArr[i]);
				
				deptRepository.save(deptDTO);
			}
		}
	}

	private void setJobDefault() {
		if (jobRepository.count() == 0) {
			Integer[] jobCodeArr = {1100, 1101, 1102, 1200, 1201, 1202};
			String[] jobNameArr = {"ROLE_CEO", "ROLE_EVP", "ROLE_SVP", "ROLE_GM", "ROLE_SM", "ROLE_EM"};
			String[] jobDetailArr = {"사장", "전무", "상무", "부장", "과장", "사원"};
			
			for (int i = 0; i < jobCodeArr.length; i++) {
				JobDTO jobDTO = new JobDTO();
				jobDTO.setJobCode(jobCodeArr[i]);
				jobDTO.setJobName(jobNameArr[i]);
				jobDTO.setJobDetail(jobDetailArr[i]);
				
				jobRepository.save(jobDTO);
			}
		}
	}
	
	private void setAdmin() {
		if (staffRepository.count() == 0) {
			StaffDTO staffDTO = new StaffDTO();
			staffDTO.setInputDeptCode(1000);
			staffDTO.setInputJobCode(1100);
			staffDTO.setStaffName("정도현");
			
			staffService.registStaff(staffDTO, null);
		}
	}
}
