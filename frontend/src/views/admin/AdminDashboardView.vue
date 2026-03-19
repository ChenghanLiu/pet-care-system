<template>
  <div class="page-wrap" v-loading="loading">
    <div class="section-title">管理台概览</div>

    <div class="summary-grid">
      <div class="summary-card">
        <div class="label">注册用户</div>
        <div class="value">{{ Number(overview.userCount || 0) }}</div>
      </div>
      <div class="summary-card">
        <div class="label">农业信息条目</div>
        <div class="value">{{ Number(overview.productCount || 0) }}</div>
      </div>
      <div class="summary-card">
        <div class="label">平台历史记录</div>
        <div class="value">{{ Number(overview.orderCount || 0) }}</div>
      </div>
      <div class="summary-card">
        <div class="label">平台活跃指数</div>
        <div class="value">{{ Number(overview.paidAmount || 0).toFixed(0) }}</div>
      </div>
    </div>

    <div class="panel-grid">
      <div class="card panel">
        <div class="panel-title">改造策略</div>
        <ul>
          <li>前台以农业信息浏览、搜索与公告查看为主。</li>
          <li>后台延续现有信息表结构，映射为作物资料、农业专题和分类条目。</li>
          <li>购物、支付、发货等页面不再暴露在新系统主流程中。</li>
        </ul>
      </div>
      <div class="card panel">
        <div class="panel-title">维护入口</div>
        <ul>
          <li>作物信息：维护重点农业主题、栽培资料与推荐内容。</li>
          <li>分类管理：维护一级/二级农业分类，继续支持两级联动。</li>
          <li>公告管理：发布系统公告、农业资讯与平台通知说明。</li>
        </ul>
      </div>
    </div>
  </div>
</template>

<script setup>
import { onMounted, ref } from 'vue'
import { getAdminOverview } from '../../api/admin'

const loading = ref(false)
const overview = ref({})

onMounted(async () => {
  loading.value = true
  try {
    overview.value = await getAdminOverview()
  } finally {
    loading.value = false
  }
})
</script>

<style scoped>
.summary-grid {
  display: grid;
  grid-template-columns: repeat(4, minmax(0, 1fr));
  gap: 12px;
}

.summary-card,
.panel {
  padding: 18px;
}

.label {
  color: var(--text-secondary);
  font-size: 13px;
}

.value {
  margin-top: 8px;
  color: var(--brand-deep);
  font-size: 26px;
  font-weight: 700;
}

.panel-grid {
  display: grid;
  grid-template-columns: repeat(2, minmax(0, 1fr));
  gap: 12px;
  margin-top: 14px;
}

.panel-title {
  margin-bottom: 12px;
  font-size: 18px;
  font-weight: 700;
  color: var(--brand-deep);
}

ul {
  margin: 0;
  padding-left: 18px;
  color: var(--text-secondary);
  line-height: 1.9;
}

@media (max-width: 900px) {
  .summary-grid,
  .panel-grid {
    grid-template-columns: 1fr;
  }
}
</style>
