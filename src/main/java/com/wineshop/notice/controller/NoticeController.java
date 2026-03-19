package com.wineshop.notice.controller;

import com.wineshop.common.result.Result;
import com.wineshop.notice.entity.WsNotice;
import com.wineshop.notice.mapper.WsNoticeMapper;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/notices")
public class NoticeController {

    private final WsNoticeMapper wsNoticeMapper;

    public NoticeController(WsNoticeMapper wsNoticeMapper) {
        this.wsNoticeMapper = wsNoticeMapper;
    }

    @GetMapping
    public Result<List<WsNotice>> list() {
        return Result.ok(wsNoticeMapper.selectAll().stream()
                .filter(item -> item.getStatus() != null && item.getStatus() == 1)
                .collect(Collectors.toList()));
    }
}
