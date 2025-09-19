package com.goodee.finals.messenger;

import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.data.web.PageableDefault;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import com.goodee.finals.common.security.CustomAuthenticationFailureHandler;
import com.goodee.finals.staff.StaffDTO;

@RequestMapping("/msg/**") @Controller
public class MessengerController {

    private final CustomAuthenticationFailureHandler customAuthenticationFailureHandler;
	
	@Autowired
	MessengerService messengerService;

    MessengerController(CustomAuthenticationFailureHandler customAuthenticationFailureHandler) {
        this.customAuthenticationFailureHandler = customAuthenticationFailureHandler;
    }
	
	@GetMapping("")
	public String pop(Model model) {
		List<ChatRoomDTO> result = messengerService.list();
		model.addAttribute("room", result);
		return "messenger/list";
	}
	
	@GetMapping("create")
	public String create(Model model) {
		List<StaffDTO> result = messengerService.getStaff();
		model.addAttribute("staff", result);
		return "messenger/create";
	}
	
	@PostMapping("create")
	public String create(@RequestParam(required = false) List<Integer> addedStaff, ChatRoomDTO chatRoomDTO, Model model) {
		ChatRoomDTO result = messengerService.createRoom(addedStaff, chatRoomDTO);
		model.addAttribute("resultMsg", "채팅방이 생성되었습니다.");
		model.addAttribute("resultIcon", "success");
		model.addAttribute("resultUrl", "msg");
		return "common/result";
	}
	
	@PostMapping("chat")
	public String chat(@PageableDefault(size = 20, sort = "chatBodyNum", direction= Sort.Direction.DESC) Pageable pageable, ChatRoomDTO chatRoomDTO, Model model) {
		Page<MessengerTestDTO> result = messengerService.chatList(pageable, chatRoomDTO.getChatRoomNum());
		List<MessengerTestDTO> messages = new ArrayList<>(result.getContent());
		messages.sort(Comparator.comparing(MessengerTestDTO::getChatBodyNum));
		model.addAttribute("chatRoomNum", chatRoomDTO.getChatRoomNum());
		model.addAttribute("chat", messages);
		model.addAttribute("next", result.hasNext());
		return "messenger/chat";
	}
	
	@PostMapping("load") @ResponseBody
	public boolean load(@RequestBody Map<String, Object> loadData, @PageableDefault(size = 20, sort = "chatBodyNum", direction= Sort.Direction.DESC) Pageable pageable) {
		System.out.println(loadData.get("chatRoomNum"));
		System.out.println(loadData.get("page"));
		// 1. pageable에 page 번호 세팅
		// 2. 쿼리로 다음 메시지 가져오기
		// 3. Map에 다음 메시지 목록 + hasNext() 값 세팅해서 json으로 보내주기
		// 4. 프론트에서는 그걸 받아서 next 값 업데이트 하고 프론트 화면 업데이트하기
		return true;
	}
	
}
