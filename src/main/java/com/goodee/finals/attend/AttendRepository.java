package com.goodee.finals.attend;

import java.time.LocalDate;
import java.time.LocalTime;
import java.util.List;
import java.util.Optional;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import com.goodee.finals.approval.EarlyDTO;
import com.goodee.finals.approval.OvertimeDTO;
import com.goodee.finals.approval.VacationDTO;

@Repository
public interface AttendRepository extends JpaRepository<AttendDTO, Long>{

	Optional<AttendDTO> findByStaffDTOStaffCodeAndAttendDate(Integer staffCode, LocalDate attendDate);
	boolean existsByStaffDTOStaffCodeAndAttendDate(Integer staffCode, LocalDate attendDate);
	
	@Query("SELECT COUNT(a) FROM AttendDTO a " +
		       "WHERE a.attendIn > :time " +
		       "AND a.staffDTO.staffCode = :staffCode " +
		       "AND a.attendDate BETWEEN :startDate AND :endDate")
	long countLateByStaffCodeInMonth(@Param("staffCode") int staffCode,
		                                 @Param("time") LocalTime time,
		                                 @Param("startDate") LocalDate startDate,
		                                 @Param("endDate") LocalDate endDate);

	@Query("SELECT COUNT(a) FROM AttendDTO a " +
	       "WHERE a.attendOut < :time " +
	       "AND a.staffDTO.staffCode = :staffCode " +
	       "AND a.attendDate BETWEEN :startDate AND :endDate")
	long countEarlyLeaveByStaffCodeInMonth(@Param("staffCode") int staffCode,
	                                       @Param("time") LocalTime time,
	                                       @Param("startDate") LocalDate startDate,
	                                       @Param("endDate") LocalDate endDate);
	
	// 휴무일 리스트 (주말 + 공휴일)
	@Query("SELECT h FROM HolidayDTO h WHERE to_char(h.date, 'yyyymm') = :monthStr")
	List<HolidayDTO> findByMonth(String monthStr);
	
	// 연장근로 리스트	
	@Query("SELECT o FROM OvertimeDTO o JOIN o.approvalDTO a WHERE a.aprvState = 702 AND a.staffDTO.staffCode = :staffCode AND to_char(o.overStart, 'yyyymm') = :monthStr")
	List<OvertimeDTO> findAllOvertimeByStaffCodeAndByMonth(Integer staffCode, String monthStr);
	
	// 휴가연차 리스트	
	@Query("SELECT v FROM VacationDTO v JOIN v.approvalDTO a WHERE a.aprvState = 702 AND a.staffDTO.staffCode = :staffCode AND to_char(v.vacStart, 'yyyymm') = :monthStr AND to_char(v.vacEnd, 'yyyymm') = :monthStr")
	List<VacationDTO> findAllVacationByStaffCodeAndByMonth(Integer staffCode, String monthStr);
	
	// 조기퇴근 리스트	
	@Query("SELECT e FROM EarlyDTO e JOIN e.approvalDTO a WHERE a.aprvState = 702 AND a.staffDTO.staffCode = :staffCode AND to_char(e.earlyDtm, 'yyyymm') = :monthStr")
	List<EarlyDTO> findAllEarlyByStaffCodeAndByMonth(Integer staffCode, String monthStr);
	
	// 휴무일 제외한 출퇴근 내역 가져오기
	@Query("SELECT a FROM AttendDTO a " +
	           "WHERE FUNCTION('YEAR', a.attendDate) = :year " +
	           "AND FUNCTION('MONTH', a.attendDate) = :month " +
	           "AND FUNCTION('DAY', a.attendDate) NOT IN :holiday " +
	           "AND a.staffDTO.staffCode = :staffCode " + 
			   "AND a.attendDate <= :today")
	Page<AttendDTO> findMonthlyAttendancesUntilToday(@Param("year") int year,
		                                             @Param("month") int month,
		                                             @Param("staffCode") Integer staffCode,
		                                             @Param("today") LocalDate today,
		                                             Pageable pageable, List<Integer> holiday);
	
	// 휴무일 제외한 출퇴근 내역 중 결근 갯수
	@Query("SELECT COUNT(a) FROM AttendDTO a " +
		       "WHERE FUNCTION('YEAR', a.attendDate) = :year " +
		       "AND FUNCTION('MONTH', a.attendDate) = :month " +
		       "AND FUNCTION('DAY', a.attendDate) NOT IN :holiday " +
		       "AND a.staffDTO.staffCode = :staffCode " +
		       "AND a.attendDate <= :today " +
		       "AND a.attendIn IS NULL AND a.attendOut IS NULL")
	Long countAbsentDays(@Param("year") int year,
	                     @Param("month") int month,
	                     @Param("staffCode") Integer staffCode,
	                     @Param("today") LocalDate today,
	                     @Param("holiday") List<Integer> holiday);
	
	// 주단위 출퇴근목록 조회
    List<AttendDTO> findByStaffDTO_StaffCodeAndAttendDateBetween(
            Integer staffCode,
            LocalDate startDate,
            LocalDate endDate
    );
    
 	// 주단위 주말,공휴일 리스트 조회
 	@Query("""
    	    SELECT h 
    	    FROM HolidayDTO h 
    	    WHERE h.date BETWEEN :startDate AND :endDate
    	         OR h.date BETWEEN :startDate AND :endDate
    	         OR h.date <= :startDate AND h.date >= :endDate
    	""")
 	List<HolidayDTO> findHolidayByWeek(
 			Integer staffCode,
 			LocalDate startDate,
 			LocalDate endDate);
 	
    // 주단위 연장근로 리스트 조회
    @Query("""
    	    SELECT o 
    	    FROM OvertimeDTO o 
    	    JOIN o.approvalDTO a 
    	    WHERE a.aprvState = 702
    	      AND a.staffDTO.staffCode = :staffCode
    	      AND to_char(o.overStart, 'yyyy-mm-dd') BETWEEN :startDate AND :endDate
    	  """)
    List<OvertimeDTO> findOvertimeByStaffCodeAndWeek(
    		Integer staffCode,
    		LocalDate startDate,
    		LocalDate endDate);
    
    // 주단위 조기퇴근 리스트 조회
    @Query("""
    	    SELECT e 
    	    FROM EarlyDTO e 
    	    JOIN e.approvalDTO a
    	    WHERE a.aprvState = 702 
    	    AND a.staffDTO.staffCode = :staffCode
    	      AND to_char(e.earlyDtm, 'yyyy-mm-dd') BETWEEN :startDate AND :endDate
    	  """)
    List<EarlyDTO> findEarlyByStaffCodeAndWeek(
    		Integer staffCode,
    		LocalDate startDate,
    		LocalDate endDate);
    
}
