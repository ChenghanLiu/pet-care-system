package com.wineshop.banner.controller;

import com.wineshop.banner.entity.WsBanner;
import com.wineshop.banner.mapper.WsBannerMapper;
import com.wineshop.common.result.Result;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/banners")
public class BannerController {

    private final WsBannerMapper wsBannerMapper;

    public BannerController(WsBannerMapper wsBannerMapper) {
        this.wsBannerMapper = wsBannerMapper;
    }

    @GetMapping
    public Result<List<WsBanner>> list() {
        return Result.ok(wsBannerMapper.selectAll().stream()
                .filter(item -> item.getStatus() != null && item.getStatus() == 1)
                .collect(Collectors.toList()));
    }
}
