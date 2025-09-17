package com.goodee.finals.notice;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.data.web.PageableDefault;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import com.goodee.finals.common.attachment.AttachmentDTO;

@RequestMapping("/notice/**") @Controller
public class NoticeController {
	
	@Autowired
	private NoticeService noticeService;
	
	@GetMapping("")
	public String list(@PageableDefault(size = 10, sort = "noticeNum", direction= Sort.Direction.DESC) Pageable pageable, NoticePager noticePager, Model model) {
		String keyword = noticePager.getKeyword();
		if (keyword == null) keyword = "";
		
		Page<NoticeDTO> resultNotice = noticeService.list(pageable, keyword);
		List<NoticeDTO> resultPinned = noticeService.pinned(keyword);
		noticePager.calc(resultNotice);
		model.addAttribute("notice", resultNotice);
		model.addAttribute("pinned", resultPinned);
		model.addAttribute("pager", noticePager);
		model.addAttribute("totalNotice", resultNotice.getContent().size() + resultPinned.size());
		return "notice/list";
	}
	
	@GetMapping("write")
	public String write() {
		return "notice/write";
	}
	
	@PostMapping("write")
	public String write(NoticeDTO noticeDTO, MultipartFile[] files) {
		NoticeDTO result = noticeService.write(noticeDTO, files);
		if (result != null) {			
			return "redirect:/notice";
		} else {
			return null;
		}
	}
	
	@GetMapping("{noticeNum}")
	public String detail(@PathVariable("noticeNum") NoticeDTO noticeDTO, Model model) {
		NoticeDTO result = noticeService.detail(noticeDTO);
		model.addAttribute("notice", result);
		return "notice/detail";
	}
	
	@GetMapping("{noticeNum}/edit")
	public String edit(@PathVariable("noticeNum") NoticeDTO noticeDTO, Model model) {
		NoticeDTO result = noticeService.detail(noticeDTO);
		model.addAttribute("notice", result);
		return "notice/write";
	}
	
	@PostMapping("{noticeNum}/edit")
	public String edit(NoticeDTO noticeDTO, @RequestParam(required = false) List<Long> deleteFiles, MultipartFile[] files) {
		NoticeDTO result = noticeService.edit(noticeDTO, files, deleteFiles);
		if (result != null) {			
			return "redirect:/notice/" + noticeDTO.getNoticeNum();
		} else {
			return null;
		}
	}
	
	@PostMapping("{noticeNum}/delete")
	public String delete(@PathVariable("noticeNum") NoticeDTO noticeDTO, Model model) {
		NoticeDTO result = noticeService.delete(noticeDTO);
		if (result != null) {
			model.addAttribute("msg", "게시글이 삭제되었습니다.");
			model.addAttribute("url", "/notice");
			return "notice/result";
		} else {
			return null;
		}
	}
	
	@GetMapping("{attachNum}/download")
	public String download(@PathVariable("attachNum") AttachmentDTO attachmentDTO, Model model) {
		AttachmentDTO result = noticeService.download(attachmentDTO);
		model.addAttribute("file", result);
		model.addAttribute("type", "notice");
		return "fileDownView";
	}
	
}
