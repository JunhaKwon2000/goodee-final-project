package com.goodee.finals.product;

import java.time.LocalDate;
import java.util.List;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.NativeQuery;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import com.goodee.finals.lost.LostDTO;

@Repository
public interface ProductRepository extends JpaRepository<ProductDTO, Integer>{
	
	@Query(
			  value = "SELECT * FROM product p " +
			          "INNER JOIN staff s USING(staff_code) " +
			          "INNER JOIN product_type pt USING(product_type_code) " +
			          "WHERE (p.product_name LIKE %:search% " +
			          "OR p.product_code LIKE %:search% " +
			          "OR p.product_spec LIKE %:search% " +
			          "OR pt.product_type_name LIKE %:search%) " +
			          "AND p.product_delete = false",
			  countQuery = "SELECT COUNT(*) FROM product p " +
			               "INNER JOIN staff s USING(staff_code) " +
			               "INNER JOIN product_type pt USING(product_type_code) " +
			               "WHERE (p.product_name LIKE %:search% " +
			               "OR p.product_code LIKE %:search% " +
			               "OR p.product_spec LIKE %:search% " +
			               "OR pt.product_type_name LIKE %:search%) " +
			               "AND p.product_delete = false",
			  nativeQuery = true
			)
	Page<ProductDTO> findAllBySearch(String search, Pageable pageable);
	
	
	@Query(value = "SELECT p.product_code " +
            "FROM product p " +
            "WHERE p.product_type_code = :productTypeCode " +
            "ORDER BY p.product_code DESC LIMIT 1",
    nativeQuery = true)
	Integer findTopProductCodeByProductType(@Param("productTypeCode") Integer productTypeCode);
	
	long countByProductDeleteFalse();
	
	@NativeQuery(value = "DELETE FROM product_attach WHERE attach_num = :attachNum")
	void deleteBeforeAttach(Long attachNum);
	
	@Query("SELECT p FROM ProductDTO p " +
		       "JOIN p.staffDTO s " +
		       "JOIN p.productTypeDTO pt " +
		       "WHERE (" +
		       "LOWER(pt.productTypeName) LIKE LOWER(CONCAT('%', :search, '%')) OR " +
		       "LOWER(p.productName) LIKE LOWER(CONCAT('%', :search, '%')) OR " +
		       "LOWER(p.productSpec) LIKE LOWER(CONCAT('%', :search, '%'))" +
		       ") " +
		       "ORDER BY p.productCode DESC")
		List<ProductDTO> findBySearchKeyword(@Param("search") String search);
}
