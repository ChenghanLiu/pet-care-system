<template>
  <div class="page-wrap">
    <div class="section-head">
      <div>
        <div class="section-title">爱心公告</div>
        <div class="section-desc">查看平台发布的领养通知、救助动态、养宠指南与站内更新说明。</div>
      </div>
    </div>

    <el-alert v-if="loadError" :title="loadError" type="warning" :closable="false" style="margin-bottom: 18px;" />

    <div class="notice-grid">
      <article
        v-for="item in notices"
        :key="item.id"
        class="card notice-card"
        role="button"
        tabindex="0"
        @click="goDetail(item)"
        @keyup.enter="goDetail(item)"
        @keyup.space.prevent="goDetail(item)"
      >
        <div class="notice-meta">
          <el-tag size="small" effect="plain">{{ item.type === 2 ? '养宠指南' : '平台公告' }}</el-tag>
          <span>{{ formatTime(item.publishTime || item.createdAt) }}</span>
        </div>
        <h3>{{ item.title || `公告 #${item.id || '-'}` }}</h3>
        <p>{{ getSummary(item.content) }}</p>
        <div class="notice-action">查看详情</div>
      </article>
    </div>

    <div class="card empty-wrap" v-if="!notices.length">
      <el-empty description="暂未发布公告内容" />
    </div>
  </div>
</template>

<script setup>
import { onMounted, ref } from 'vue'
import dayjs from 'dayjs'
import { useRouter } from 'vue-router'
import { getPublicNotices } from '../api/content'

const router = useRouter()
const notices = ref([])
const loadError = ref('')

const formatTime = (value) => value ? dayjs(value).format('YYYY-MM-DD HH:mm') : '-'
const getSummary = (value) => {
  const text = String(value ?? '').trim()
  if (!text) return '当前内容暂无摘要，点击查看详情。'
  return text.length > 88 ? `${text.slice(0, 88)}...` : text
}
const goDetail = (item) => {
  if (!item?.id) return
  router.push(`/announcements/${item.id}`)
}

onMounted(async () => {
  try {
    const data = await getPublicNotices()
    notices.value = Array.isArray(data) ? data : []
  } catch {
    notices.value = []
    loadError.value = '公告数据加载失败，请稍后重试。'
  }
})
</script>

<style scoped>
.section-head {
  display: flex;
  align-items: end;
  justify-content: space-between;
  gap: 16px;
  margin-bottom: 18px;
}

.section-desc {
  color: var(--text-secondary);
}

.notice-grid {
  display: grid;
  grid-template-columns: repeat(2, minmax(0, 1fr));
  gap: 18px;
}

.notice-card {
  padding: 22px;
  cursor: pointer;
  transition: transform .2s ease, box-shadow .2s ease;
}

.notice-card:hover,
.notice-card:focus-visible {
  transform: translateY(-4px);
  box-shadow: 0 16px 32px rgba(45, 91, 102, 0.12);
}

.notice-card:focus-visible {
  outline: 2px solid rgba(255, 138, 101, 0.38);
  outline-offset: 2px;
}

.notice-meta {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 12px;
  color: var(--text-secondary);
  font-size: 13px;
}

h3 {
  margin: 16px 0 10px;
  font-size: 22px;
  color: var(--brand-deep);
}

p {
  margin: 0;
  color: var(--text-secondary);
  line-height: 1.8;
  white-space: pre-line;
}

.notice-action {
  margin-top: 18px;
  color: var(--brand-main);
  font-weight: 600;
}

.empty-wrap {
  margin-top: 18px;
  padding: 12px;
}

@media (max-width: 768px) {
  .notice-grid {
    grid-template-columns: 1fr;
  }
}
</style>
