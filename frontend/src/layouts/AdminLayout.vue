<template>
  <div class="admin-shell">
    <aside class="side-panel">
      <router-link class="brand" to="/admin">
        <span class="brand-mark">PET</span>
        <span>
          <strong>宠物信息后台</strong>
          <small>宠物档案与平台内容管理</small>
        </span>
      </router-link>
      <nav class="menu">
        <router-link to="/admin/dashboard">后台概览</router-link>
        <router-link to="/admin/statistics">数据看板</router-link>
        <router-link to="/admin/infos">宠物资料</router-link>
        <router-link to="/admin/categories">宠物分类</router-link>
        <router-link to="/admin/notices">爱心公告</router-link>
        <router-link to="/admin/banners">首页轮播</router-link>
        <router-link to="/admin/users">用户管理</router-link>
        <router-link to="/admin/password">安全设置</router-link>
      </nav>
    </aside>
    <section class="main-panel">
      <header class="topbar">
        <div>
          <div class="topbar-title">爱心宠物系统管理中心</div>
          <div class="topbar-subtitle">统一维护宠物档案、领养公告、首页内容与用户资料</div>
        </div>
        <div class="actions">
          <span class="username">{{ userStore.user?.username || '管理员' }}</span>
          <el-button link type="danger" @click="logout">退出登录</el-button>
        </div>
      </header>
      <router-view />
    </section>
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
.admin-shell {
  min-height: 100vh;
  display: grid;
  grid-template-columns: 260px minmax(0, 1fr);
}

.side-panel {
  position: sticky;
  top: 0;
  height: 100vh;
  padding: 24px 18px;
  background: linear-gradient(180deg, #fff8f1 0%, #fffdfb 100%);
  border-right: 1px solid rgba(239, 127, 87, 0.12);
}

.brand {
  display: flex;
  align-items: center;
  gap: 12px;
  margin-bottom: 24px;
  color: var(--brand-deep);
}

.brand strong {
  display: block;
  font-size: 20px;
}

.brand small {
  display: block;
  margin-top: 4px;
  color: var(--text-secondary);
  font-size: 12px;
}

.brand-mark {
  width: 44px;
  height: 44px;
  display: inline-flex;
  align-items: center;
  justify-content: center;
  border-radius: 14px;
  background: linear-gradient(135deg, var(--brand-main), var(--brand-gold));
  color: #fff;
  font-weight: 800;
  letter-spacing: 0.08em;
}

.menu {
  display: grid;
  gap: 8px;
}

.menu a {
  padding: 12px 14px;
  border-radius: 14px;
  color: var(--text-secondary);
  transition: background .2s ease, color .2s ease, transform .2s ease;
}

.menu a.router-link-active {
  background: rgba(255, 138, 101, 0.12);
  color: var(--brand-deep);
  font-weight: 700;
}

.menu a:hover {
  transform: translateX(3px);
  color: var(--brand-main);
}

.main-panel {
  min-width: 0;
}

.topbar {
  position: sticky;
  top: 0;
  z-index: 8;
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 24px;
  padding: 20px 24px;
  background: rgba(255, 252, 249, 0.92);
  border-bottom: 1px solid rgba(239, 127, 87, 0.12);
  backdrop-filter: blur(10px);
}

.topbar-title {
  color: var(--brand-deep);
  font-size: 22px;
  font-weight: 700;
}

.topbar-subtitle {
  margin-top: 4px;
  color: var(--text-secondary);
  font-size: 13px;
}

.actions {
  display: flex;
  align-items: center;
  gap: 12px;
}

.username {
  color: var(--text-secondary);
}

@media (max-width: 960px) {
  .admin-shell {
    grid-template-columns: 1fr;
  }

  .side-panel {
    position: static;
    height: auto;
    border-right: 0;
    border-bottom: 1px solid rgba(239, 127, 87, 0.12);
  }

  .menu {
    grid-template-columns: repeat(2, minmax(0, 1fr));
  }

  .topbar {
    padding: 18px 20px;
    align-items: flex-start;
    flex-direction: column;
  }
}
</style>
