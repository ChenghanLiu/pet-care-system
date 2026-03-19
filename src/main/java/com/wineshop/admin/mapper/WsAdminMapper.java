package com.wineshop.admin.mapper;

import com.wineshop.admin.entity.WsAdmin;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

@Mapper
public interface WsAdminMapper {
    WsAdmin selectByUsername(@Param("username") String username);

    WsAdmin selectByUsernameAndPassword(@Param("username") String username, @Param("password") String password);

    WsAdmin selectById(@Param("id") Long id);

    int insert(WsAdmin admin);

    int updatePasswordById(@Param("id") Long id, @Param("password") String password);
}
