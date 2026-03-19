<template>
  <div class="login-page">
    <div class="login-card card">
      <h2>农业信息管理系统</h2>
      <p class="sub-title">面向农业信息浏览、公告发布与后台维护的演示平台。</p>
      <el-alert type="info" :closable="false" show-icon class="demo-alert">
        <template #title>
          演示账号：普通用户 `user1 / 123456`，管理员 `admin / admin123`
        </template>
      </el-alert>
      <el-tabs v-model="active">
        <el-tab-pane label="登录" name="login">
          <el-form :model="loginForm" @submit.prevent>
            <el-form-item>
              <el-radio-group v-model="loginRole">
                <el-radio-button label="user">普通用户</el-radio-button>
                <el-radio-button label="admin">系统管理员</el-radio-button>
              </el-radio-group>
            </el-form-item>
            <el-form-item>
              <el-input v-model="loginForm.username" placeholder="用户名" />
            </el-form-item>
            <el-form-item>
              <el-input v-model="loginForm.password" type="password" placeholder="密码" show-password />
            </el-form-item>
            <el-button type="primary" :loading="loading" @click="onLogin" style="width:100%">登录</el-button>
          </el-form>
        </el-tab-pane>
        <el-tab-pane label="注册" name="register">
          <el-form :model="regForm" @submit.prevent>
            <el-form-item>
              <el-input v-model="regForm.username" placeholder="用户名" />
            </el-form-item>
            <el-form-item>
              <el-input v-model="regForm.password" type="password" placeholder="密码" show-password />
            </el-form-item>
            <el-form-item>
              <el-input v-model="regForm.nickname" placeholder="昵称(可选)" />
            </el-form-item>
            <el-button type="primary" :loading="loading" @click="onRegister" style="width:100%">注册并登录</el-button>
          </el-form>
        </el-tab-pane>
      </el-tabs>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { ElMessage } from 'element-plus'
import { adminLogin, login, register } from '../api/auth'
import { useUserStore } from '../stores/user'

const active = ref('login')
const loginRole = ref('user')
const loading = ref(false)
const loginForm = ref({ username: '', password: '' })
const regForm = ref({ username: '', password: '', nickname: '', phone: '' })
const userStore = useUserStore()
const router = useRouter()
const route = useRoute()

const onLogin = async () => {
  if (!loginForm.value.username || !loginForm.value.password) {
    ElMessage.warning('请输入用户名和密码')
    return
  }

  loading.value = true
  try {
    const api = loginRole.value === 'admin' ? adminLogin : login
    const data = await api(loginForm.value)
    userStore.setToken(data.token)
    await userStore.fetchMe()
    ElMessage.success('登录成功')
    const role = (userStore.user?.role || '').toUpperCase()
    if (role === 'ADMIN') {
      router.push('/admin')
    } else {
      router.push(route.query.redirect || '/')
    }
  } catch (error) {
    if (error?.status === 401) {
      userStore.logout()
    }
  } finally {
    loading.value = false
  }
}

const onRegister = async () => {
  if (!regForm.value.username || !regForm.value.password) {
    ElMessage.warning('请输入用户名和密码')
    return
  }

  loading.value = true
  try {
    await register(regForm.value)
    const data = await login({ username: regForm.value.username, password: regForm.value.password })
    userStore.setToken(data.token)
    await userStore.fetchMe()
    ElMessage.success('注册成功')
    router.push('/')
  } catch (error) {
    if (error?.status === 401) {
      userStore.logout()
    }
  } finally {
    loading.value = false
  }
}
</script>

<style scoped>
.login-page {
  min-height: 100vh;
  display: flex;
  align-items: center;
  justify-content: center;
  background:
    radial-gradient(circle at top, rgba(211, 167, 79, 0.2), transparent 30%),
    linear-gradient(180deg, #f4f1e7 0%, #eef5e7 100%);
  padding: 20px;
}
.login-card {
  width: 430px;
  padding: 28px;
}
h2 {
  margin: 0 0 18px;
  color: var(--brand-deep);
}
.sub-title {
  margin: -6px 0 18px;
  color: var(--text-secondary);
}
.demo-alert {
  margin-bottom: 18px;
}
</style>
