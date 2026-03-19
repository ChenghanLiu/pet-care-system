<template>
  <div>
    <header class="header-wrap">
      <div class="header-inner">
        <router-link class="brand" to="/admin">农业信息管理后台</router-link>
        <nav class="nav">
          <router-link to="/admin/dashboard">概览</router-link>
          <router-link to="/admin/infos">农业信息</router-link>
          <router-link to="/admin/categories">分类管理</router-link>
          <router-link to="/admin/notices">公告管理</router-link>
          <router-link to="/admin/password">改密</router-link>
        </nav>
        <div class="actions">
          <span class="username">{{ userStore.user?.username || '管理员' }}</span>
          <el-button link type="danger" @click="logout">退出</el-button>
        </div>
      </div>
    </header>
    <router-view />
  </div>
</template>

<script setup>
import { useRouter } from 'vue-router'
import { useUserStore } from '../stores/user'

const userStore = useUserStore()
const router = useRouter()

const logout = () => {
  userStore.logout()
  router.push('/login')
}
</script>

<style scoped>
.header-wrap { background: #fff; border-bottom: 1px solid var(--line-color); position: sticky; top: 0; z-index: 10; }
.header-inner { max-width: 1200px; margin: 0 auto; height: 68px; display: flex; align-items: center; justify-content: space-between; gap: 24px; padding: 0 20px; }
.brand { font-size: 22px; font-weight: 700; color: var(--brand-deep); }
.nav { display: flex; gap: 20px; }
.nav a.router-link-active { color: var(--brand-deep); font-weight: 600; }
.actions { display: flex; align-items: center; gap: 10px; }
.username { color: var(--text-secondary); }
</style>
