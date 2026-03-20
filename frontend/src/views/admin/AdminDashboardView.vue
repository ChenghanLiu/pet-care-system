<template>
  <div class="page-wrap" v-loading="loading">
    <div class="section-title">后台概览</div>

    <div class="summary-grid">
      <div class="summary-card">
        <div class="label">注册用户</div>
        <div class="value">{{ Number(overview.userCount || 0) }}</div>
      </div>
      <div class="summary-card">
        <div class="label">宠物档案总数</div>
        <div class="value">{{ Number(overview.productCount || 0) }}</div>
      </div>
      <div class="summary-card">
        <div class="label">跟进记录总数</div>
        <div class="value">{{ Number(overview.orderCount || 0) }}</div>
      </div>
      <div class="summary-card">
        <div class="label">平台热度指数</div>
        <div class="value">{{ Number(overview.paidAmount || 0).toFixed(0) }}</div>
      </div>
    </div>

    <div class="panel-grid">
      <div class="card panel">
        <div class="panel-title">展示策略</div>
        <ul>
          <li>前台以宠物档案浏览、搜索筛选与爱心公告查看为主。</li>
          <li>后台沿用现有信息结构，映射为宠物资料、领养档案和分类标签维护。</li>
          <li>历史兼容流程仅作为底层数据适配保留，不再作为当前系统的主展示链路。</li>
        </ul>
      </div>
      <div class="card panel">
        <div class="panel-title">维护入口</div>
        <ul>
          <li>宠物资料：维护萌宠档案、封面配图、关注热度与展示状态。</li>
          <li>分类管理：维护一级/二级宠物分类，继续支持两级联动。</li>
          <li>公告管理：发布平台公告、领养提醒和养宠指南内容。</li>
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
