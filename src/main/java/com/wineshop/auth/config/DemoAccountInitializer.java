package com.wineshop.auth.config;

import com.wineshop.admin.entity.WsAdmin;
import com.wineshop.admin.mapper.WsAdminMapper;
import com.wineshop.user.entity.WsUser;
import com.wineshop.user.mapper.WsUserMapper;
import lombok.extern.slf4j.Slf4j;
import org.springframework.boot.ApplicationArguments;
import org.springframework.boot.ApplicationRunner;
import org.springframework.stereotype.Component;

@Slf4j
@Component
public class DemoAccountInitializer implements ApplicationRunner {

    private static final String DEMO_ADMIN_USERNAME = "admin";
    private static final String DEMO_ADMIN_PASSWORD = "admin123";
    private static final String DEMO_USER_USERNAME = "user1";
    private static final String DEMO_USER_PASSWORD = "123456";

    private final WsAdminMapper wsAdminMapper;
    private final WsUserMapper wsUserMapper;

    public DemoAccountInitializer(WsAdminMapper wsAdminMapper, WsUserMapper wsUserMapper) {
        this.wsAdminMapper = wsAdminMapper;
        this.wsUserMapper = wsUserMapper;
    }

    @Override
    public void run(ApplicationArguments args) {
        try {
            ensureAdminAccount();
            ensureUserAccount();
        } catch (Exception e) {
            log.warn("Skipping demo account bootstrap, database may not be initialized yet: {}", e.getMessage());
        }
    }

    private void ensureAdminAccount() {
        if (wsAdminMapper.selectByUsername(DEMO_ADMIN_USERNAME) != null) {
            return;
        }

        WsAdmin admin = new WsAdmin();
        admin.setUsername(DEMO_ADMIN_USERNAME);
        admin.setPassword(DEMO_ADMIN_PASSWORD);
        admin.setRealName("系统管理员");
        admin.setStatus(1);
        wsAdminMapper.insert(admin);
        log.info("Created missing demo admin account: {}", DEMO_ADMIN_USERNAME);
    }

    private void ensureUserAccount() {
        if (wsUserMapper.selectByUsername(DEMO_USER_USERNAME) != null) {
            return;
        }

        WsUser user = new WsUser();
        user.setUsername(DEMO_USER_USERNAME);
        user.setPassword(DEMO_USER_PASSWORD);
        user.setNickname("演示用户");
        user.setPhone("13800000001");
        user.setStatus(1);
        wsUserMapper.insert(user);
        log.info("Created missing demo user account: {}", DEMO_USER_USERNAME);
    }
}
