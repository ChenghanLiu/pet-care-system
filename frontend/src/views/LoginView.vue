<template>
  <div class="login-page">
    <div class="login-shell card">
      <div class="intro-panel">
        <div class="intro-badge">宠物信息平台</div>
        <h2>连接领养、陪伴与温暖救助</h2>
        <p class="sub-title">面向宠物信息展示、平台公告发布、分类浏览与后台维护的综合信息平台。</p>
        <ul class="intro-list">
          <li>浏览宠物档案、分类信息与详细照护建议</li>
          <li>收藏心仪毛孩子，查看平台公告与领养说明</li>
          <li>管理员可维护宠物资料、轮播内容和通知公告</li>
        </ul>
      </div>
      <div class="login-card">
        <el-alert type="info" :closable="false" show-icon class="demo-alert">
          <template #title>
            体验账号：普通用户 `user1 / 123456`，管理员 `admin / admin123`
          </template>
        </el-alert>
        <el-tabs v-model="active">
          <el-tab-pane label="登录" name="login">
            <el-form :model="loginForm" @submit.prevent>
              <el-form-item>
                <el-radio-group v-model="loginRole">
                  <el-radio-button label="user">爱心用户</el-radio-button>
                  <el-radio-button label="admin">后台管理员</el-radio-button>
                </el-radio-group>
              </el-form-item>
              <el-form-item>
                <el-input v-model="loginForm.username" placeholder="请输入用户名" />
              </el-form-item>
              <el-form-item>
                <el-input v-model="loginForm.password" type="password" placeholder="请输入密码" show-password />
              </el-form-item>
              <el-button type="primary" :loading="loading" @click="onLogin" style="width:100%">立即登录</el-button>
            </el-form>
          </el-tab-pane>
          <el-tab-pane label="注册" name="register">
            <el-form :model="regForm" @submit.prevent>
              <el-form-item>
                <el-input v-model="regForm.username" placeholder="设置用户名" />
              </el-form-item>
              <el-form-item>
                <el-input v-model="regForm.password" type="password" placeholder="设置密码" show-password />
              </el-form-item>
              <el-form-item>
                <el-input v-model="regForm.nickname" placeholder="宠物爱好者昵称（可选）" />
              </el-form-item>
              <el-button type="primary" :loading="loading" @click="onRegister" style="width:100%">注册并进入平台</el-button>
            </el-form>
          </el-tab-pane>
        </el-tabs>
      </div>
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
    radial-gradient(circle at top, rgba(243, 191, 120, 0.28), transparent 30%),
    radial-gradient(circle at right, rgba(255, 138, 101, 0.14), transparent 24%),
    linear-gradient(180deg, #fff8f2 0%, #fffdf9 100%);
  padding: 20px;
}

.login-shell {
  width: min(980px, 100%);
  display: grid;
  grid-template-columns: 1.1fr 0.9fr;
  overflow: hidden;
}

.intro-panel {
  padding: 34px;
  background: linear-gradient(160deg, rgba(255, 138, 101, 0.94), rgba(243, 191, 120, 0.88));
  color: #fff;
}

.intro-badge {
  display: inline-flex;
  align-items: center;
  padding: 6px 12px;
  border-radius: 999px;
  background: rgba(255, 255, 255, 0.16);
  font-size: 12px;
  letter-spacing: 0.12em;
}

.login-card {
  padding: 28px;
  background: rgba(255, 255, 255, 0.92);
}

h2 {
  margin: 18px 0;
  font-size: 36px;
  line-height: 1.25;
}

.sub-title {
  margin: 0;
  color: rgba(255, 255, 255, 0.92);
  line-height: 1.8;
}

.demo-alert {
  margin-bottom: 18px;
}

.intro-list {
  margin: 24px 0 0;
  padding-left: 18px;
  line-height: 1.9;
}

@media (max-width: 860px) {
  .login-shell {
    grid-template-columns: 1fr;
  }

  h2 {
    font-size: 28px;
  }
}
</style>
