package com.goodee.finals.notice;

import java.time.LocalDate;

import com.goodee.finals.staff.StaffDTO;

import jakarta.persistence.CascadeType;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Entity @Table(name = "notice")
@Getter @Setter @ToString
public class NoticeDTO {
	@Id @GeneratedValue(strategy = GenerationType.IDENTITY)
	private Long noticeNum;
	private String noticeTitle;
	@Column(columnDefinition = "LONGTEXT")
	private String noticeContent;
	private LocalDate noticeDate = LocalDate.now();
	@Column(columnDefinition = "boolean default false")
	private boolean noticePinned;
	private Long noticeHits = 0L;
	@Column(columnDefinition = "boolean default false")
	private boolean noticeTmp;
	
	@ManyToOne(fetch = FetchType.EAGER, cascade = CascadeType.ALL) 
	@JoinColumn(name = "staffCode")
	private StaffDTO staffDTO;
}
