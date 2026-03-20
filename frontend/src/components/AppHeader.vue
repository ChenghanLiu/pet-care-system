<template>
  <header class="header-wrap">
    <div class="header-inner">
      <router-link class="brand" to="/">
        <span class="brand-mark">PAW</span>
        <span>
          <strong>爱心宠物系统</strong>
          <small>宠物领养与关怀展示平台</small>
        </span>
      </router-link>
      <nav class="nav" v-if="!userStore.isAdmin">
        <router-link to="/">首页</router-link>
        <router-link to="/info">宠物信息</router-link>
        <router-link to="/announcements">爱心公告</router-link>
        <router-link v-if="userStore.isLogin" to="/followed-items">我的关注</router-link>
        <router-link v-if="userStore.isLogin" to="/profile">用户中心</router-link>
      </nav>
      <nav class="nav" v-else>
        <router-link to="/admin">宠物后台</router-link>
      </nav>
      <div class="actions">
        <template v-if="userStore.isLogin">
          <span class="username">{{ userStore.user?.username || '用户' }}</span>
          <el-tag v-if="userStore.isAdmin" size="small" type="success">管理员</el-tag>
          <el-button link type="danger" @click="logout">退出登录</el-button>
        </template>
        <el-button v-else type="primary" @click="router.push('/login')">登录 / 注册</el-button>
      </div>
    </div>
  </header>
</template>

<script setup>
import { onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { useUserStore } from '../stores/user'

const userStore = useUserStore()
const router = useRouter()

const logout = () => {
  userStore.logout()
  router.push('/login')
}

onMounted(async () => {
  if (userStore.isLogin) {
    await userStore.fetchMe().catch(() => userStore.logout())
  }
})
</script>

<style scoped>
.header-wrap {
  background: rgba(255, 251, 247, 0.92);
  border-bottom: 1px solid rgba(239, 127, 87, 0.14);
  backdrop-filter: blur(12px);
  position: sticky;
  top: 0;
  z-index: 10;
}

.header-inner {
  max-width: 1200px;
  margin: 0 auto;
  height: 72px;
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 24px;
  padding: 0 20px;
}

.brand {
  display: flex;
  align-items: center;
  gap: 12px;
  color: var(--brand-deep);
}

.brand strong {
  display: block;
  font-size: 22px;
  line-height: 1.2;
}

.brand small {
  display: block;
  margin-top: 2px;
  font-size: 12px;
  color: var(--text-secondary);
}

.brand-mark {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  width: 42px;
  height: 42px;
  border-radius: 14px;
  background: linear-gradient(135deg, var(--brand-main), var(--brand-gold));
  color: #fff;
  font-size: 12px;
  font-weight: 800;
  letter-spacing: 0.12em;
}

.nav {
  display: flex;
  gap: 12px;
}

.nav a {
  padding: 8px 14px;
  border-radius: 999px;
  color: var(--text-secondary);
  transition: background .2s ease, color .2s ease, transform .2s ease;
}

.nav a.router-link-active {
  color: var(--brand-deep);
  font-weight: 600;
  background: rgba(255, 138, 101, 0.12);
}

.nav a:hover {
  transform: translateY(-1px);
  color: var(--brand-main);
}

.actions {
  display: flex;
  align-items: center;
  gap: 10px;
}

.username {
  color: var(--text-secondary);
}

@media (max-width: 900px) {
  .header-inner {
    height: auto;
    flex-wrap: wrap;
    padding: 14px 20px;
  }

  .nav {
    width: 100%;
    overflow-x: auto;
    padding-bottom: 4px;
  }
}
</style>
