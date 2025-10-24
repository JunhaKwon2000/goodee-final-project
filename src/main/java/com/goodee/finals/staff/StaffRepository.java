package com.goodee.finals.staff;

import java.util.List;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.NativeQuery;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

@Repository
public interface StaffRepository extends JpaRepository<StaffDTO, Integer> {

	@NativeQuery(value = "SELECT staff_code FROM staff ORDER BY staff_code DESC LIMIT 1")
	Integer findLastStaffCode();
	
	List<StaffDTO> findByStaffEnabled(Boolean staffEnabled);
	
	@NativeQuery(value = "SELECT * FROM staff s INNER JOIN dept d USING(dept_code) INNER JOIN job j USING(job_code) WHERE (s.staff_name LIKE %:search% OR d.dept_detail LIKE %:search% OR j.job_detail LIKE %:search% OR s.staff_phone LIKE %:search% OR s.staff_email LIKE %:search% OR s.staff_code LIKE %:search%) AND s.staff_enabled = 1")
	Page<StaffDTO> findAllBySearch(String search, Pageable pageable);
	
	@NativeQuery(value = "SELECT * FROM staff s INNER JOIN dept d USING(dept_code) INNER JOIN job j USING(job_code) LEFT OUTER JOIN (SELECT * FROM attend WHERE attend_date = :today) a USING(staff_code) WHERE (s.staff_name LIKE %:search% OR d.dept_detail LIKE %:search% OR j.job_detail LIKE %:search% OR s.staff_phone LIKE %:search% OR s.staff_code LIKE %:search%) AND s.staff_enabled = 1")
	Page<StaffDTO> findAllBySearchWithTodayAttend(String today, String search, Pageable pageable);
	
	@Query(value = "SELECT * FROM staff s INNER JOIN dept d USING(dept_code) INNER JOIN job j USING(job_code) WHERE s.dept_code = :deptCode AND (s.staff_name LIKE %:search% OR d.dept_detail LIKE %:search% OR j.job_detail LIKE %:search% OR s.staff_phone LIKE %:search% OR s.staff_email LIKE %:search% OR s.staff_code LIKE %:search%) AND s.staff_enabled = 1", nativeQuery = true)
	Page<StaffDTO> findAllByDeptCodeAndSearch(Integer deptCode, String search, Pageable pageable);
	
	@Query("SELECT s FROM StaffDTO s JOIN FETCH s.deptDTO JOIN FETCH s.jobDTO WHERE s.staffEnabled = true")
	List<StaffDTO> findAllEnabledStaffWithDeptAndJob();
	
	@NativeQuery(value = "SELECT * FROM staff s INNER JOIN dept d USING(dept_code) INNER JOIN job j USING(job_code) WHERE (s.staff_name LIKE %:search% OR d.dept_detail LIKE %:search% OR j.job_detail LIKE %:search% OR s.staff_phone LIKE %:search% OR s.staff_code LIKE %:search%) AND s.staff_enabled = 0")
	Page<StaffDTO> findAllQuitBySearch(String search, Pageable pageable);
	
	List<StaffDTO> findByStaffCodeNotAndStaffNameContaining(Integer loggedStaff, String keyword);
	
	// deptDTO.deptCode 시설부서의 코드 꺼내옴
   List<StaffDTO> findByDeptDTO_DeptCodeAndStaffEnabledTrue(Integer deptCode);
  
	List<StaffDTO> findByStaffCodeNotIn(List<Integer> currentMemeber);
	
	@Query("SELECT new com.goodee.finals.staff.StaffVacationDTO(al.aprvCode, s.staffName, d.deptDetail, j.jobDetail, v.vacNum, v.vacType, v.vacStart, v.vacEnd) "
			+ " FROM ApprovalDTO al JOIN al.staffDTO s JOIN al.vacationDTO v JOIN s.deptDTO d JOIN s.jobDTO j"
			+ " WHERE al.aprvType = 901 AND al.aprvState = 702 AND s.staffName LIKE %:search%"
			+ " ORDER BY v.vacNum DESC")
	Page<StaffVacationDTO> findAllStaffVacation(String search, Pageable pageable);
	
	@Query("SELECT new com.goodee.finals.staff.StaffOvertimeDTO(al.aprvCode, s.staffName, d.deptDetail, j.jobDetail, o.overNum, o.overStart, o.overEnd) "
			+ " FROM ApprovalDTO al JOIN al.staffDTO s JOIN al.overtimeDTO o JOIN s.deptDTO d JOIN s.jobDTO j"
			+ " WHERE al.aprvType = 902 AND al.aprvState = 702 AND s.staffName LIKE %:search%"
			+ " ORDER BY o.overNum DESC")
	Page<StaffOvertimeDTO> findAllStaffOvertime(String search, Pageable pageable);
	
	@Query("SELECT new com.goodee.finals.staff.StaffEarlyDTO(al.aprvCode, s.staffName, d.deptDetail, j.jobDetail, e.earlyNum, e.earlyType, e.earlyDtm) "
			+ " FROM ApprovalDTO al JOIN al.staffDTO s JOIN al.earlyDTO e JOIN s.deptDTO d JOIN s.jobDTO j"
			+ " WHERE al.aprvType = 903 AND al.aprvState = 702 AND s.staffName LIKE %:search%"
			+ " ORDER BY e.earlyNum DESC")
	Page<StaffEarlyDTO> findAllStaffEarly(String search, Pageable pageable);
	
	@NativeQuery(value = "SELECT SUM(staff_remain_leave) FROM staff WHERE staff_enabled = 1")
	Integer findStaffLeaveTotal();
	
	@NativeQuery(value = "SELECT SUM(staff_used_leave) FROM staff WHERE staff_enabled = 1")
	Integer findStaffLeaveUsed();
	
	@NativeQuery(value = "SELECT staff_code FROM staff s INNER JOIN approval p USING(staff_code) INNER JOIN vacation v USING(aprv_code) WHERE now() BETWEEN v.vac_start AND v.vac_end")
	List<Integer> findLeavedStaffToday();
	
	@NativeQuery(value = "SELECT COUNT(*) FROM attend WHERE attend_date = DATE_FORMAT(now(), '%Y-%m-%d') AND attend_in IS NOT NULL;")
	Integer findWorkingStaff();
	
    @Query(value = "SELECT s.dept_code AS deptCode, COUNT(*) AS deptGroup FROM staff s " +
     	   "WHERE s.staff_code != :loggedStaff AND s.staff_name LIKE CONCAT('%', :keyword, '%')" +
     	   "GROUP BY s.dept_code", nativeQuery = true)
 	List<DeptDTOProjection> findCountDeptByStaffCodeAndKeyword(Integer loggedStaff, String keyword);
}
