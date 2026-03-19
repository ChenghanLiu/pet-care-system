<template>
  <div class="card product-card" @click="goDetail">
    <img :src="imageSrc" class="cover" alt="农业信息封面" @error="handleImageError" />
    <div class="body">
      <div class="name">{{ safeName }}</div>
      <div class="meta-row">
        <div class="meta">关注指数 {{ product.sales || 0 }}</div>
        <div class="badge">参考指标 {{ Number(product.price || 0).toFixed(1) }}</div>
      </div>
      <div class="summary">{{ product.description || '点击查看农业主题说明、分类归属与基础指标。' }}</div>
    </div>
  </div>
</template>

<script setup>
import { computed, ref, watch } from 'vue'
import { useRouter } from 'vue-router'

const props = defineProps({ product: { type: Object, required: true } })
const router = useRouter()
const fallback = '/images/agri-placeholder.png?v=phase8'
const imageSrc = ref(props.product?.coverImage || fallback)
const safeName = computed(() => props.product?.name || `农业信息 #${props.product?.id ?? '-'}`)

watch(
  () => props.product?.coverImage,
  (value) => {
    imageSrc.value = value || fallback
  },
  { immediate: true }
)

const handleImageError = (event) => {
  if (imageSrc.value === fallback) return
  imageSrc.value = fallback
  event.target.src = fallback
}

const goDetail = () => router.push(`/info/${props.product.id}`)
</script>

<style scoped>
.product-card {
  cursor: pointer;
  overflow: hidden;
  transition: transform .2s ease, box-shadow .2s ease;
}
.product-card:hover {
  transform: translateY(-4px);
  box-shadow: 0 16px 30px rgba(56, 97, 50, 0.16);
}
.cover {
  width: 100%;
  height: 180px;
  object-fit: cover;
  display: block;
  background: #f8f8f8;
}
.body {
  padding: 14px;
}
.name {
  font-weight: 600;
  line-height: 1.4;
  min-height: 44px;
}
.meta {
  color: var(--text-secondary);
  font-size: 13px;
}

.meta-row {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 10px;
  margin-top: 8px;
}

.badge {
  padding: 4px 10px;
  border-radius: 999px;
  background: #edf5e7;
  color: var(--brand-deep);
  font-size: 12px;
  white-space: nowrap;
}

.summary {
  margin-top: 10px;
  color: var(--text-secondary);
  font-size: 14px;
  line-height: 1.7;
  min-height: 72px;
  display: -webkit-box;
  -webkit-line-clamp: 3;
  -webkit-box-orient: vertical;
  overflow: hidden;
}
</style>
