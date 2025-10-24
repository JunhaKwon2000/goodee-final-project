package com.goodee.finals.lost;

import java.time.LocalDate;
import java.util.List;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import com.goodee.finals.productManage.ProductManageDTO;

@Repository
public interface LostRepository extends JpaRepository<LostDTO, Long>{

	@Query(
		    value = "SELECT * FROM lost l " +
		            "INNER JOIN staff s USING(staff_code) " +
		            "WHERE (l.lost_name LIKE %:search% " +
		            "OR s.staff_name LIKE %:search%) " +  // ← 괄호로 OR 조건 묶기
		            "AND l.lost_delete = false " +
		            "AND (:startDate IS NULL OR l.lost_date >= :startDate) " +
		            "AND (:endDate IS NULL OR l.lost_date <= :endDate) ",
		    countQuery = "SELECT COUNT(*) FROM lost l " +
		                 "INNER JOIN staff s USING(staff_code) " +
		                 "WHERE (l.lost_name LIKE %:search% " +
		                 "OR s.staff_name LIKE %:search%) " +
		                 "AND l.lost_delete = false " +
		                 "AND (:startDate IS NULL OR l.lost_date >= :startDate) " +
		                 "AND (:endDate IS NULL OR l.lost_date <= :endDate) ",
		    nativeQuery = true
		)
	Page<LostDTO> findAllBySearch(LocalDate startDate, LocalDate endDate, String search, Pageable pageable);
	
	long countByLostDeleteFalse();
	
	@Query("SELECT l FROM LostDTO l " +
		       "JOIN l.staffDTO s " +
		       "WHERE (" +
		       "LOWER(s.staffName) LIKE LOWER(CONCAT('%', :search, '%')) OR " +
		       "LOWER(l.lostName) LIKE LOWER(CONCAT('%', :search, '%'))" +
		       ") " +
		       "AND (:startDate IS NULL OR l.lostDate >= :startDate) " +
		       "AND (:endDate IS NULL OR l.lostDate <= :endDate) " +
		       "ORDER BY l.lostNum DESC")
		List<LostDTO> findBySearchKeyword(@Param("startDate") LocalDate startDate,
		                                           @Param("endDate") LocalDate endDate,
		                                           @Param("search") String search);
	
}
