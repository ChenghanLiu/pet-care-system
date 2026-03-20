<template>
  <div class="page-wrap" v-loading="loading">
    <div class="back-row">
      <el-button plain @click="goBack">返回爱心公告</el-button>
    </div>

    <div v-if="loadError" class="card state-card">
      <el-result icon="warning" title="公告查看失败" :sub-title="loadError">
        <template #extra>
          <el-button type="primary" @click="router.push('/announcements')">查看全部公告</el-button>
        </template>
      </el-result>
    </div>

    <article v-else-if="notice" class="card detail-card">
      <div class="detail-head">
        <div class="title-wrap">
          <el-tag size="small" effect="plain">{{ noticeTypeText }}</el-tag>
          <h1>{{ notice.title || '未命名公告' }}</h1>
        </div>
        <div class="meta-grid">
          <div class="meta-item">
            <span>发布时间</span>
            <strong>{{ formatTime(notice.publishTime || notice.createdAt) }}</strong>
          </div>
          <div class="meta-item">
            <span>更新时间</span>
            <strong>{{ formatTime(notice.updatedAt || notice.publishTime || notice.createdAt) }}</strong>
          </div>
          <div class="meta-item">
            <span>内容编号</span>
            <strong>{{ notice.id || '-' }}</strong>
          </div>
        </div>
      </div>

      <el-divider />

      <div class="content-wrap">
        <div class="section-title">详细内容</div>
        <p class="content-text">{{ safeContent }}</p>
      </div>
    </article>
  </div>
</template>

<script setup>
import { computed, onMounted, ref, watch } from 'vue'
import dayjs from 'dayjs'
import { useRoute, useRouter } from 'vue-router'
import { getPublicNotices } from '../api/content'

const route = useRoute()
const router = useRouter()
const loading = ref(false)
const loadError = ref('')
const notice = ref(null)

const formatTime = (value) => value ? dayjs(value).format('YYYY-MM-DD HH:mm') : '暂无时间信息'
const noticeTypeText = computed(() => Number(notice.value?.type) === 2 ? '养宠指南' : '平台公告')
const safeContent = computed(() => notice.value?.content || '当前内容暂无详细说明，请返回列表查看其他爱心公告。')

const goBack = () => {
  if (window.history.length > 1) {
    router.back()
    return
  }
  router.push('/announcements')
}

const loadNotice = async () => {
  loading.value = true
  loadError.value = ''
  notice.value = null

  try {
    const id = Number(route.params.id)
    const notices = await getPublicNotices()
    const matched = (Array.isArray(notices) ? notices : []).find((item) => Number(item.id) === id)

    if (!matched) {
      loadError.value = '该内容不存在、已下线，或当前无法访问。'
      return
    }

    notice.value = matched
  } catch {
    loadError.value = '公告数据加载失败，请稍后重试。'
  } finally {
    loading.value = false
  }
}

onMounted(loadNotice)
watch(() => route.params.id, loadNotice)
</script>

<style scoped>
.back-row {
  margin-bottom: 18px;
}

.state-card,
.detail-card {
  padding: 24px;
}

.detail-head {
  display: flex;
  flex-direction: column;
  gap: 20px;
}

.title-wrap h1 {
  margin: 14px 0 0;
  font-size: 32px;
  color: var(--brand-deep);
  line-height: 1.4;
}

.meta-grid {
  display: grid;
  grid-template-columns: repeat(3, minmax(0, 1fr));
  gap: 14px;
}

.meta-item {
  padding: 16px;
  border-radius: 12px;
  background: #fff8f2;
}

.meta-item span {
  display: block;
  margin-bottom: 8px;
  color: var(--text-secondary);
  font-size: 13px;
}

.meta-item strong {
  color: var(--brand-deep);
  font-size: 16px;
  word-break: break-word;
}

.content-wrap {
  display: flex;
  flex-direction: column;
  gap: 14px;
}

.content-text {
  margin: 0;
  color: var(--text-main);
  line-height: 1.9;
  white-space: pre-line;
  word-break: break-word;
}

@media (max-width: 768px) {
  .title-wrap h1 {
    font-size: 26px;
  }

  .meta-grid {
    grid-template-columns: 1fr;
  }
}
</style>
